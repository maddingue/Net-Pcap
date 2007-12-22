#!perl
use strict;
use Test::More;
plan skip_all => "Pod spelling: for developer interest only :)" unless -d 'releases';
plan skip_all => "Test::Spelling required for testing POD spell"
    unless eval "use Test::Spelling; 1";
set_spell_cmd('aspell -l --lang=en');
add_stopwords(<DATA>);
all_pod_files_spelling_ok();

__END__

SAPER
Sébastien
Aperghis
Tramoni
CPAN
README
TODO
AUTOLOADER
API
arrayref
arrayrefs
hashref
hashrefs
lookup
hostname
loopback
netmask
timestamp
BPF
CRC
IP
TCP
UDP
FDDI
Firewire
HDLC
IEEE
IrDA
LocalTalk
PPP
LBL
libpcap
pcap
WinPcap
BOADLER
JLMOREL
KCARNUT
PLISTER
TIMPOTTER
Bruhat
Carnut
Lanning
Maischen
Pradene
savefile
Savefile
savefiles
Savefiles
snaplen
endianness
pcapinfo
errbuf
PerlMonks
iptables
