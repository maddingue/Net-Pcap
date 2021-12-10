#!perl -T
use strict;
use Test::More;
use Net::Pcap;
use lib 't';
use Utils;

plan skip_all => "pcap_create() is not available" unless is_available('pcap_create');
plan tests => 27;

my $has_test_exception = eval "use Test::Exception; 1";

my($dev,$pcap,$r,$err) = ('','','','');

# Find a device and open it
$dev = find_network_device();

# Testing error messages
SKIP: {
    skip "Test::Exception not available", 12 unless $has_test_exception;

    # pcap_create() errors
    throws_ok(sub {
        Net::Pcap::create()
    }, '/^Usage: Net::Pcap::create\(source, err\)/',
       "calling pcap_create() with no argument");

    throws_ok(sub {
        Net::Pcap::create(0, 0)
    }, '/^arg2 not a reference/',
       "calling pcap_create() with incorrect argument type for arg2");

    # pcap_set_buffer_size() errors
    throws_ok(sub {
        Net::Pcap::set_buffer_size()
    }, '/^Usage: Net::Pcap::set_buffer_size\(p, dim\)/',
       "calling pcap_set_buffer_size() with no argument");

    throws_ok(sub {
        Net::Pcap::set_buffer_size(0, 0)
    }, '/^p is not of type pcap_tPtr/',
       "calling pcap_set_buffer_size() with incorrect pcap argument");

    # set_promisc() errors
    throws_ok(sub {
        Net::Pcap::set_promisc()
    }, '/^Usage: Net::Pcap::set_promisc\(p, promisc\)/',
       "calling pcap_set_promisc() with no argument");

    throws_ok(sub {
        Net::Pcap::set_promisc(0, 0)
    }, '/^p is not of type pcap_tPtr/',
       "calling pcap_set_promisc() with incorrect pcap argument");

    # pcap_set_snaplen() errors
    throws_ok(sub {
        Net::Pcap::set_snaplen()
    }, '/^Usage: Net::Pcap::set_snaplen\(p, snaplen\)/',
       "calling pcap_set_snaplen() with no argument");

    throws_ok(sub {
        Net::Pcap::set_snaplen(0, 0)
    }, '/^p is not of type pcap_tPtr/',
       "calling pcap_set_snaplen() with incorrect pcap argument");

    # pcap_set_timeout() errors
    throws_ok(sub {
        Net::Pcap::set_timeout()
    }, '/^Usage: Net::Pcap::set_timeout\(p, timeout\)/',
       "calling pcap_set_timeout() with no argument");

    throws_ok(sub {
        Net::Pcap::set_timeout(0, 0)
    }, '/^p is not of type pcap_tPtr/',
       "calling pcap_set_timeout() with incorrect pcap argument");

    # pcap_activate() errors
    throws_ok(sub {
        Net::Pcap::activate()
    }, '/^Usage: Net::Pcap::activate\(p\)/',
       "calling pcap_activate() with no argument");

    throws_ok(sub {
        Net::Pcap::activate(0)
    }, '/^p is not of type pcap_tPtr/',
       "calling pcap_activate() with incorrect pcap argument");
}

SKIP: {
    skip "must be run as root", 15 unless is_allowed_to_use_pcap();
    skip "no network device available", 15 unless find_network_device();

    # Testing pcap_create()
    $pcap = eval { Net::Pcap::create($dev, \$err) };
    is( $@, '', "pcap_create()" );
    is( $err, '', " - \$err must be null: $err" );
    ok( defined $pcap, " - returned a defined value" );
    isa_ok( $pcap, 'SCALAR', " - \$pcap" );
    isa_ok( $pcap, 'pcap_tPtr', " - \$pcap" );

    # Testing pcap_set_buffer_size()
    $r = eval { Net::Pcap::set_buffer_size($pcap, 8*1024) };
    is( $@, '', "pcap_set_buffer_size()" );
    is( $r, 0, " - returns 0 for true" );

    # Testing pcap_set_promisc()
    $r = eval { Net::Pcap::set_promisc($pcap, 0) };
    is( $@, '', "pcap_set_promisc()" );
    is( $r, 0, " - returns 0 for true" );

    # Testing pcap_set_snaplen()
    $r = eval { Net::Pcap::set_snaplen($pcap, 1024) };
    is( $@, '', "pcap_set_snaplen()" );
    is( $r, 0, " - returns 0 for true" );

    # Testing pcap_set_timeout()
    $r = eval { Net::Pcap::set_timeout($pcap, 1000) };
    is( $@, '', "pcap_set_timeout()" );
    is( $r, 0, " - returns 0 for true" );

    # Testing pcap_activate()
    $r = eval { Net::Pcap::activate($pcap) };
    is( $@, '', "pcap_activate()" );
    is( $r, 0, " - returns 0 for true" );

    Net::Pcap::close($pcap);
}
