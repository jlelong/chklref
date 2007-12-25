package math_entry;
use strict;

## this class is intended to store information gathered during the
## parsing of a tex file.
## Fields :
##     str : name of the entry. chosen agmonst the math modes
##     begin : first line of the mode
##     end : last line of the mode
##     star : is the environment starred ?
##

sub new
{
    my ($class, $str, $begin, $end, $star, $label_line, $label) = @_;
    my $this = {};
    bless($this, $class);
    $this->{str} = $str;
    $this->{begin} = $begin;
    $this->{end} = $end;
    $this->{star} = $star;
    $this->{label_line} = $label_line;
    $this->{label} = $label;
    return $this;
}

sub new_ref
{
    my ($class,$str,$line) = @_;
    my $this = {};
    bless($this, $class);
    $this->{str} = $str;
    $this->{line} = $line;
    return $this;
}

1;
