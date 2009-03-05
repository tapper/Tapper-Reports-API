#! /usr/bin/env perl

use strict;
use warnings;

BEGIN {
        use Class::C3;
        use MRO::Compat;
}

use Test::More;
use Data::Dumper;
use Artemis::Schema::TestTools;
use Test::Fixture::DBIC::Schema;
use Artemis::Reports::API::Daemon;
use Cwd;

plan tests => 1;

# ----- Prepare test db -----

# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => reportsdb_schema, fixture => 't/fixtures/reportsdb/report.yml' );
# -----------------------------------------------------------------------------------------------------------------

# ----- Start server -----

my $api = new Artemis::Reports::API::Daemon (
                                             pidfile => getcwd.'/test-artemis-reports-api-daemon-test.pid',
                                             port    => 54321,
                                            );
$api->run("start");
print STDERR "Start\n";

# ----- Client communication -----

# ----- Check DB content -----
sleep 15;
ok(1, "dummy");

# ----- Close server -----
$api->run("stop");


