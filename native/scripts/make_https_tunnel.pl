#!/usr/bin/env perl

# Send stdin to a remote host; pass its response to stdout.

use v5.10;
use strict;
use warnings;
use autodie;
no feature "unicode_strings";

use Getopt::Long qw/GetOptions :config gnu_getopt no_ignore_case auto_version/;
use IO::Socket::SSL '$SSL_ERROR';

my $verbosity = 0;
GetOptions "v|verbose+" => \$verbosity
    and @ARGV == 1 or exit 2;
my ($remote_host) = @ARGV;

binmode STDIN;
binmode STDOUT;

sub debug {
    my $level = shift;
    print STDERR @_ if $verbosity >= $level;
}

sub stream {
    my ($from, $to, $headers) = @_;
    my $remaining = $headers =~ /^Content-Length: *(\d+)\r?$/im ? $1 : 0;
    my $buffer;
    print $to $headers;
    while ($remaining && (my $read = read $from, $buffer, $remaining >= 8192 ? 8192 : $remaining)) {
        $remaining -= $read;
        print $to $buffer;
    }
}

$/ = "\r\n\r\n";
while (my $headers = <STDIN>) {
    if ($verbosity == 1) {
        $headers =~ /.*/;
        print STDERR "$&\n";
    } else {
        debug 2, $headers;
    }
    $headers =~ s/^Host:\K[^\r\n]*/ $remote_host/im;

    debug 2, "Connecting.\n";
    # One connection per request. Could do better, but why? It's for development only anyway.
    my $socket = IO::Socket::SSL->new("$remote_host:443") or die "$!; $SSL_ERROR";

    debug 2, "Sending the request.\n";
    stream *STDIN, $socket, $headers;

    debug 2, "Receiving a response.\n";
    $headers = <$socket>;
    debug 3, $headers;
    stream $socket, *STDOUT, $headers;
    STDOUT->flush;

    $socket->close;
    debug 2, "Done.\n\n";
}
