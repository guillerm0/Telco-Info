#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Telco::Info' ) || print "Bail out!\n";
}

diag( "Testing Telco::Info $Telco::Info::VERSION, Perl $], $^X" );
