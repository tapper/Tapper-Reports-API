#! /usr/bin/env perl

use 5.010;
use strict;
use warnings;

BEGIN {
        use Class::C3;
        use MRO::Compat;
}

use Cwd;
use Test::More;
use Data::Dumper;
use Artemis::Schema::TestTools;
use Test::Fixture::DBIC::Schema;
use Artemis::Reports::API::Daemon;

plan tests => 1;

# ----- Prepare test db -----

# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => reportsdb_schema, fixture => 't/fixtures/reportsdb/report.yml' );
# -----------------------------------------------------------------------------------------------------------------

my $port = 54321;
my $payload_file = 't/test_payload.txt';
my $grace_period = 2;

# ----- Start server -----
$ENV{MX_DAEMON_STDOUT} = getcwd."/test-artemis_reports_api_daemon_stdout.log";
$ENV{MX_DAEMON_STDERR} = getcwd."/test-artemis_reports_api_daemon_stderr.log";

my $api = new Artemis::Reports::API::Daemon (
                                             basedir => getcwd,
                                             pidfile => getcwd.'/test-artemis-reports-api-daemon-test.pid',
                                             port    => $port,
                                            );
$api->run("start");
sleep $grace_period;

# ----- Client communication -----

my $dsn = Artemis::Config->subconfig->{test}{database}{ReportsDB}{dsn};
my $reportsdb_schema = Artemis::Schema::ReportsDB->connect($dsn,
                                                           Artemis::Config->subconfig->{test}{database}{ReportsDB}{username},
                                                           Artemis::Config->subconfig->{test}{database}{ReportsDB}{password},
                                                           {
                                                            ignore_version => 1
                                                           }
                                                          );

my $cmd = "( echo '#! upload 23 $payload_file' ; cat $payload_file ) | netcat -w1 localhost $port";
my $res = `$cmd`;

# ----- Check DB content -----

# wait, because the server is somewhat slow until the upload is visible in DB
sleep $grace_period;

is( $reportsdb_schema->resultset('ReportFile')->count, 1,  "new reportfile count" );

# ----- Close server -----
$api->run("stop");
