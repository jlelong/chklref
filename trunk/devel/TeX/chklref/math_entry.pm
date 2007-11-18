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
    my ($class, $str, $begin, $end, $star) = @_;
    my $this = {};
    bless($this, $class);
    $this->{str} = $str;
    $this->{begin} = $begin;
    $this->{end} = $end;
    $this->{star} = $star;

    return $this;
}

1;
