#!perl 

use Test::More tests => 2;

BEGIN {
        use Class::C3;
        use MRO::Compat;

	use_ok( 'Tapper::Reports::API' );
	use_ok( 'Tapper::Reports::API::Daemon' );
}

diag( "Testing Tapper::Reports::API $Tapper::Reports::API::VERSION, Perl $], $^X" );
