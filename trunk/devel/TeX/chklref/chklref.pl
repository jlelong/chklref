#!/usr/bin/perl


#########################################################################
# Written and (C) by Jérôme Lelong <jerome.lelong@gmail.com>            #
#                                                                       #
# This program is free software; you can redistribute it and/or modify  #
# it under the terms of the GNU General Public License as published by  #
# the Free Software Foundation; either version 3 of the License, or     #
# (at your option) any later version.                                   #
#                                                                       #
# This program is distributed in the hope that it will be useful,       #
# but WITHOUT ANY WARRANTY; without even the implied warranty of        #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
# GNU General Public License for more details.                          #
#                                                                       #
# You should have received a copy of the GNU General Public License     #
# along with this program.  If not, see <http://www.gnu.org/licenses/>. #
#########################################################################



use math_entry;


## recognised math environments
@math_modes = ( "equation","eqnarray","align", "multline" );

## Parses tex file and looks for the environments defined by
## @math_modes. The first and last line of the environment are stored
## togetther with the name of the environment. One last variable is
## used to remember if the stared environment was used
sub tex_parse
{
    my ($file) = @_;
    my @entries = ();
    my @refs = ();
    my @labels = ();
    my ($str, $begin, $end, $star, $labeled_env, $label);
    my $math_mode = join('|', @math_modes);
    $math_mode = "($math_mode)";
    open (FIC, $file) or die("open: $!");
    while (<FIC>)
    {
        if (m/^[^%]*\\label{([^{}]*)}/)
        {
            push(@labels, $1);
        } elsif (m/^[^%]*\\ref{([^{}]*)}/)
        {
            push(@refs, $1);
        }
        if (m/\\begin{$math_mode(\**)}[ ]*([^%]*\\label{([^{}]*)})*/)
        {
            $str = $1;
            $labeled_env = 0;
            if ($3)
            {
                push(@labels,$4) ;
                $labeled_env = $.;
            }
            $star = 1; 
            $star = 0 unless ($2);
            $begin = $.;
            while (<FIC>)
            {
                if (m/^[^%]*\\label{([^{}]*)}/)
                {
                    push(@labels, $1);
                    $label=$1;
                    $labeled_env = $.;
                } elsif (m/\\ref{([^{}]*)}/)
                {
                    push(@refs, $1);
                }
                if (m/\\end{$str\*{$star}}/)
                {
                    $end = $.;
                    $entry = math_entry->new($str, $begin, $end, $star, $labeled_env, $label);
                    push(@entries, $entry);
                    last;
                }
            }
        } 

    }
    close FIC;
    return (\@entries, \@labels, \@refs);
}

## find labeled star environment
sub star_label
{
    my ($entries) = @_;
    my @entries = @$entries;
    my $e;
    foreach $e (@entries)
    {
        if (($e->{star} == 1) && ($e->{label_line} > 0))
        {
            print "line $e->{label_line} remove label $e->{label}\n" ;
        }
    }
}


sub unused_label
{
    my ($labels, $refs) = @_;
    my @labels = @$labels;
    my @refs = @$refs;
    my $found;
     
    foreach $l (@labels)
    {
        $found = 0;
        foreach $r (@refs)
        {
            if ($r eq $l)
                {
                    $found=1;
                    last;
                }
        }
        print "remove label $l\n" if (!$found);
    }
}

sub disp_msg
{
    my ($entries) = @_;
    my @entries = @$entries;

    foreach $e (@entries)
    {
        print ("env $e->{str} \n");
        print ("\tbeginning : $e->{begin}\n\tend : $e->{end}\n");
        print ("\tstar environment\n") if ($e->{star}==1);
        print ("\tlabeled environement\n") if ($e->{label}>0);
        print("\n");
    }
    
}

($entries, $labels, $refs)=tex_parse $ARGV[0];
star_label($entries);
unused_label($labels, $refs);
