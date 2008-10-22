#! /usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Data::Dumper;
use Artemis::Reports::API;

my @cmdlines = (
                # trailing spaces matter!
                '#! upload 552 /tmp/foo.bar application/octet-stream',
                '#! upload 552 /tmp/foo.bar application/octet-stream   ',
                '#!     upload      552      /tmp/foo.bar   application/octet-stream',
                '#!     upload      552      /tmp/foo.bar   application/octet-stream    ',
               );

plan tests => 2*4*@cmdlines;

my $i = 0;
foreach my $cmdline (@cmdlines) {
        my ($cmd, $id, $file, $contenttype) = Artemis::Reports::API::_split_cmdline( $cmdline );

        is($cmd,         "upload",                   "cmd $i");
        is($id,          "552",                      "id $i");
        is($file,        "/tmp/foo.bar",             "file $i");
        is($contenttype, "application/octet-stream", "contenttype $i");

        $i++;
}

# -- same but without optional content type --

@cmdlines = (
             # trailing spaces matter!
             '#! upload 552 /tmp/foo.bar',
             '#! upload 552 /tmp/foo.bar   ',
             '#!     upload      552      /tmp/foo.bar',
             '#!     upload      552      /tmp/foo.bar    ',
            );

foreach my $cmdline (@cmdlines) {
        my ($cmd, $id, $file, $contenttype) = Artemis::Reports::API::_split_cmdline( $cmdline );

        is($cmd,         "upload",                   "cmd $i");
        is($id,          "552",                      "id $i");
        is($file,        "/tmp/foo.bar",             "file $i");
        is($contenttype, undef,                      "contenttype $i");

        $i++;
}

