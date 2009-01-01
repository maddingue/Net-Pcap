#!perl -T
use strict;
use Test::More tests => 1;

use_ok( 'Net::Pcap', ':functions' );
diag( "Testing Net::Pcap $Net::Pcap::VERSION (", pcap_lib_version(), ") under Perl $]" );
