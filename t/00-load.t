#!perl -T
use strict;
use Test::More tests => 1;

BEGIN {
  use_ok( 'Net::Pcap' );
}

diag( "Testing Net::Pcap $Net::Pcap::VERSION under Perl $]" );

