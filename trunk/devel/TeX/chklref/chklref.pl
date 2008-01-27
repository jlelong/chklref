#!/usr/bin/perl

# * $Author: lelong $
# * $Revision: 1.10 $
# * $Source: /users/mathfi/lelong/cvsroot/devel/TeX/chklref/chklref.pl,v $
# * $Date: 2008-01-27 15:13:38 $


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

## recognised math environments
@math_modes = ( "equation","eqnarray","align", "multline" );

## labels starting with the following prefixes are ignored
@ignore_labels = ("hyp:");

## creates a hash with two keys "str" and "line" and returns a
## reference to it
##
## Input: 2 args a string and a line number
sub new_ref
{
    my ($str, $line) = @_;
    my $ref = {};
    $ref->{str}=$str; $ref->{line}=$line;
    return $ref;
}


## creates a hash with six keys "str", "begin", "end", "star",
## "label_line" and "label" and returns a reference to it.
##
## Input : 6 args
##    a string (the env name)
##    line of beginning
##    line of end
##    is the env starred?
##    line on which the label appears
##    value of the label
sub new_math_env
{
    my ($str, $begin, $end, $star, $label_line, $label) = @_;
    my $this = {};
    $this->{str} = $str;
    $this->{begin} = $begin;
    $this->{end} = $end;
    $this->{star} = $star;
    $this->{label_line} = $label_line;
    $this->{label} = $label;
    return $this;
}

## Parses tex file and looks for the environments defined by
## @math_modes. The first and last line of the environment are stored
## togetther with the name of the environment. One last variable is
## used to remember if the stared environment was used.
##
## Input: a tex file
sub tex_parse
{
    my ($file) = @_;
    my @entries = ();
    my @refs = ();
    my @labels = ();
    my ($str, $begin, $end, $star, $labeled_env, $label);
    my $math_mode = join('|', @math_modes);
    $math_mode = "($math_mode)";
    my $ignore_label = join('|', @ignore_labels);
    $ignore_label = "(?:$ignore_label)";
    open (FIC, $file) or die("open: $!");
    ## jump to the beginning of the document
    while (<FIC>)
    {
        last if (m/^[^%]*\\begin{document}/o);
    }
    while (<FIC>)
    {
        if (m/^[^%]*\\label{(?!$ignore_label)([^{}]*)}/o)
        {
            push(@labels, new_ref($1, $.)) ;
        } else
        {
            while (/\G[^%]*?\\(eq)*ref{([^{}]*)}/go)
            {
                push(@refs, new_ref($2,$.));
            }
        }
        if (/^[^%]*\\begin[ ]*{$math_mode(\**)}
             [ ]*
             ([^%]*\\label{(?!$ignore_label)([^{}]*)})*/ox) {
            $str = $1;
            $labeled_env = 0;
            if ($3)
            {
                push(@labels, new_ref($4, $.)) ;
                $labeled_env = $.;
            }
            $star = 1; 
            $star = 0 unless ($2);
            $begin = $.;
            while (<FIC>)
            {
                if (m/^[^%]*\\label{([^{}]*)}/o)
                {
                    push(@labels, new_ref($1, $.));
                    $label=$1;
                    $labeled_env = $.;
                } else
                {
                    while (m/\G[^%]*\\(eq)*ref{([^{}]*)}/go)
                    {
                        push(@refs, new_ref($2,$.));
                    }
                }
                if (m/^[^%]*\\end[ ]*{$str\*{$star}}/)
                {
                    $end = $.;
                    $entry = new_math_env($str, $begin, $end, $star, $labeled_env, $label);
                    push(@entries, $entry);
                    last;
                }
            }
        } 
    }
    close FIC;
    return (\@entries, \@labels, \@refs);
}

## find labeled and starred environments
sub star_label
{
    my ($entries) = @_;
    my $e;
    print "************************************
** Labels in starred environments **
************************************\n";
    foreach $e (@$entries)
    {
        printf("line %4d : remove label %s \n", $e->{label_line}, $e->{label})
        if (($e->{star} == 1) && ($e->{label_line} > 0));

        printf("line %4d : consider using a STAR environment\n", $e->{begin})
        if (($e->{star} == 0) && ($e->{label_line} == 0));
    }
    print "\n";
}

## find labels without any corresponding refs.
## refs must be sorted
## possibly it should
## also check for refs correpsonding to no label

sub unused_label
{
    my ($labels, $refs) = @_;
    my $found;

    print "*******************
** Unused Labels **
*******************\n";
    foreach $l (@$labels)
    {
        $found = 0;
        foreach $r (@$refs)
        {
            if ($r->{str} eq $l->{str})
            {
                $found=1; last;
            } elsif ($r->{str} ge $l->{str})
            {
                last;
            }
        }
        printf("line %4d : remove label %s\n",$l->{line}, $l->{str})  if (!$found);
    }
    print "\n";
}


## find and remove duplicates in an
## array of { str, line } entries.
## Note that the array must be sorted according to str
sub rm_duplicate
{
    my ($array) = @_;
    my $prev = '___________not_a_true_label______';
    my @uniq_array = grep($_->{str} ne $prev && (($prev) = $_->{str}), @$array);
    return \@uniq_array;
}

# ## display all math envs with their characteristics
# ## line of beginning
# ## line of end
# ## starred or not
# ## label
# sub disp_msg
# {
#     my ($entries) = @_;
#     my @entries = @$entries;

#     foreach $e (@entries)
#     {
#         print ("env $e->{str} \n");
#         print ("\tbeginning : $e->{begin}\n\tend : $e->{end}\n");
#         print ("\tstar environment\n") if ($e->{star}==1);
#         print ("\tlabeled environement\n") if ($e->{label}>0);
#         print("\n");
#     }
    
# }

($entries, $labels, $refs)=tex_parse $ARGV[0];
@labels = sort { $a->{str} cmp $b->{str} } @$labels ;
@refs = sort { $a->{str} cmp $b->{str} } @$refs ;
$uniq_refs = rm_duplicate(\@refs);
star_label($entries);
unused_label($labels, $uniq_refs);
