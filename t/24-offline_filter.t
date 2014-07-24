#!perl -T
use strict;
use File::Spec;
use Test::More;
use Net::Pcap;
use lib 't';
use Utils;

my $has_test_exception = eval "use Test::Exception; 1";

plan tests => 7;

# Testing error messages
SKIP: {
    skip "Test::Exception not available", 1 unless $has_test_exception;

    # offline_filter() errors
    throws_ok(sub {
        Net::Pcap::offline_filter()
    }, '/^arg2 not a hash ref/',
       "calling offline_filter() with no argument");
}

my ($err, $pcap);
my ($icmpfilter, $tcpfilter);

ok($pcap = Net::Pcap::open_offline(File::Spec->catfile(qw(t samples ping-ietf-20pk-be.dmp)), \$err), 'Open testfile');

ok(pcap_compile($pcap, \$icmpfilter, 'icmp', 1, 0xffffffff)==0, 'Compile icmp filter');
ok(pcap_compile($pcap, \$tcpfilter, 'tcp', 1, 0xffffffff)==0, 'Compile tcp filter');

my (%header, $packet);
my ($n, $icmp, $tcp) = (0, 0, 0);
while(pcap_next_ex($pcap, \%header, \$packet)==1) {
        $n++;
        if (my $rc=pcap_offline_filter($icmpfilter, \%header, $packet)) {
                $icmp++;
        }
        if (my $rc=pcap_offline_filter($tcpfilter, \%header, $packet)) {
                $tcp++;
        }
}
Net::Pcap::close($pcap);
ok($n==20, 'Read all packets');
ok($icmp==20, 'Found all icmp packets');
ok($tcp==0, 'Test for tcp packets in an icmp-only testfile');

