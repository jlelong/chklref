#!/usr/bin/perl

# * $Author: lelong $
# * $Revision: 1.1 $
# * $Source: /users/mathfi/lelong/cvsroot/devel/TeX/chklref/chkparser.pl,v $
# * $Date: 2008-04-12 16:27:43 $


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
@have_star_modes = ( "equation","eqnarray","align", "multline", "figure", "table");

## creates a hash with three keys "str", "line", "file" and returns a
## reference to it
##
## Input: 3 args a string, a line number, a filename
sub new_ref
{
    my ($str, $line, $file) = @_;
    my $ref = {};
    $ref->{str}=$str; $ref->{line}=$line; $ref->{file}=$file;
    return $ref;
}


## creates a hash with six keys "str", "begin", "end", "star",
## "label_line" and "label" and returns a reference to it.
##
## Input : 7 args
##    a string (the env name)
##    line of beginning
##    line of end
##    is the env starred?
##    line on which the label appears
##    value of the label
##    file name
sub new_math_env
{
    my ($str, $begin, $end, $star, $label_line, $label, $file) = @_;
    my $this = {};
    $this->{str} = $str;
    $this->{begin} = $begin;
    $this->{end} = $end;
    $this->{star} = $star;
    $this->{label_line} = $label_line;
    $this->{label} = $label;
    $this->{file}=$file;
    return $this;
}

## Parses .chk file and looks for the environments defined by
## @have_star_modes. The first and last line of the environment are stored
## togetther with the name of the environment. One last variable is
## used to remember if the stared environment was used.
##
## Input: a tex file, entries, refs, labels
## last 3 args are passed by reference and are modified
sub tex_parse
{
    my ($FIC,$entries,$refs,$labels) = @_;
    my ($str, $begin, $end, $star, $labeled_env, $label);
    
    while (<$FIC>)
    {
        if (m/^label (.+) line (\d+) file (.+)$/o)
        {
            push(@$labels, new_ref($1, $2, $3)) ;
        }
        elsif (m/^ref (.+) line (\d+) file (.+)$/o)
        {
            push(@$refs, new_ref($1, $2, $3)) ;
        }
        elsif (m/^begin{$have_star_mode(\**)} line (\d+) file (.+)$/o)
        {
            $str = $1;
            $star = 1; 
            $star = 0 unless ($2);
            $begin = $3;
            $file = $4;
            $label = "";
            $labeled_env = 0;
            while (<$FIC>)
            {
                if (m/^label (.+) line (\d+) file (.+)$/o)
                {
                    push(@$labels, new_ref($1, $2, $3)) ;
                    $label = $1;
                    $labeled_env = $2;
                }
                elsif (m/^ref (.+) line (\d+) file (.+)$/o)
                {
                    push(@$refs, new_ref($1, $2, $3)) ;
                }
                elsif (m/^end{$str\*{$star}} line (\d+) file (.+)$/)
                {
                    $end = $1;
                    $entry = new_math_env($str, $begin, $end, $star, $labeled_env, $label, $file);
                    push(@$entries, $entry);
                    last;
                }
                
            } 
        }
    }
}

## find labeled and starred environments
## Input : list of entries
sub star_label
{
    my ($entries) = @_;
    my $e;
    print "************************************
** Labels in starred environments **
************************************\n";
    foreach $e (@$entries)
    {
        printf("%s line %4d : remove label %s \n", $e->{file}, $e->{label_line}, $e->{label})
            if (($e->{star} == 1) && ($e->{label_line} > 0));

        printf("%s line %4d : consider using a STAR environment\n", $e->{file}, $e->{begin})
            if (($e->{star} == 0) && ($e->{label_line} == 0));
    }
    print "\n";
}

## find labels without any corresponding refs.
## refs must be sorted
##
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
        printf("%s line %4d : remove label %s\n", $l->{file}, $l->{line}, $l->{str})  if (!$found);
    }
    print "\n";
}


## find and remove duplicates in an
## array of { str, line } entries.
## Note that the array must be sorted according to str
## Input : ref or label list
## returns the corresponding list 
sub rm_duplicate
{
    my ($array) = @_;
    my $prev = '___________not_a_true_label______';
    my @uniq_array = grep($_->{str} ne $prev && (($prev) = $_->{str}), @$array);
    return \@uniq_array;
}


## display all math envs with their characteristics
## line of beginning
## line of end
## starred or not
## label
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


if (@ARGV != 1)
{
    print("chklref needs exactly one argument.\n");
    exit 0;
}

@entries=();
@refs=();
@labels=();
$have_star_mode = join('|', @have_star_modes);
$have_star_mode = "($have_star_mode)";
open (FIC, $ARGV[0]) or die("open: $!");
tex_parse(FIC, \@entries, \@refs, \@labels) ;
close(FIC);

@labels = sort { $a->{line} cmp $b->{line} } @labels ;
@refs = sort { $a->{str} cmp $b->{str} } @refs ;
$uniq_refs = rm_duplicate(\@refs);
star_label(\@entries);
disp_msg(\@entries);
unused_label(\@labels, $uniq_refs);
