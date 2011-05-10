#!perl

use Test::More tests => 1;

BEGIN {
	use_ok( 'Bio::Tiny::Util::DNA' );
}

diag( "Testing Bio::Tiny::Util::DNA $Bio::Tiny::Util::DNA::VERSION, Perl $], $^X" );
