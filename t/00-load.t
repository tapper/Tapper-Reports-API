#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Artemis::Reports::API' );
}

diag( "Testing Artemis::Reports::API $Artemis::Reports::API::VERSION, Perl $], $^X" );
