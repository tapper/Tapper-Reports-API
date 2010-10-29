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
use File::Slurp 'slurp';

# ----- Prepare test db -----

# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => reportsdb_schema, fixture => 't/fixtures/reportsdb/report.yml' );
# -----------------------------------------------------------------------------------------------------------------

my $port = 54321;
my $payload_file = 't/test_payload.txt';
my $expected_file;
my $grace_period = 5;
my $expected;
my $filecontent;

my $netcat = `if which netcat > /dev/null 2>&1 ; then echo netcat ; else echo nc ; fi`;
chomp $netcat;


# ____________________ START SERVER ____________________

$ENV{MX_DAEMON_STDOUT} = getcwd."/test-artemis_reports_api_daemon_stdout.log";
$ENV{MX_DAEMON_STDERR} = getcwd."/test-artemis_reports_api_daemon_stderr.log";

my $api = new Artemis::Reports::API::Daemon (
                                             basedir => getcwd,
                                             pidfile => getcwd.'/test-artemis-reports-api-daemon-test.pid',
                                             port    => $port,
                                            );
$api->run("start");
sleep $grace_period;


# ____________________ UPLOAD ____________________

# Client communication

my $dsn = Artemis::Config->subconfig->{test}{database}{ReportsDB}{dsn};
my $reportsdb_schema = Artemis::Schema::ReportsDB->connect($dsn,
                                                           Artemis::Config->subconfig->{test}{database}{ReportsDB}{username},
                                                           Artemis::Config->subconfig->{test}{database}{ReportsDB}{password},
                                                           {
                                                            ignore_version => 1
                                                           }
                                                          );

my $cmd = "( echo '#! upload 23 $payload_file' ; cat $payload_file ) | $netcat -w1 localhost $port";
my $res = `$cmd`;

# Check DB content

# wait, because the server is somewhat slow until the upload is visible in DB
sleep $grace_period;

is( $reportsdb_schema->resultset('ReportFile')->count, 1,  "new reportfile count" );

eval {
        $filecontent = $reportsdb_schema->resultset('ReportFile')->search({})->first->filecontent;
        $expected    = slurp $payload_file;
        is( $filecontent, $expected, "upload");
};

# ____________________ DOWNLOAD ____________________

# Client communication

# ----- depends on upload just before -----

$expected = slurp $payload_file;
my $sock = IO::Socket::INET->new( PeerAddr => 'localhost', PeerPort => $port, Proto => 'tcp', ReuseAddr => 1) or die $!;
is(ref($sock), 'IO::Socket::INET', "socket created");
my $success = $sock->print( "#! download 23 $payload_file\n" );
{ local $/;
  $res = <$sock>;
}
close $sock;
is($res, $expected, "same file downloaded");

# ____________________ MASON ____________________

# Client communication
my $EOFMARKER  = "MASONTEMPLATE".$$;
$payload_file  = "t/perfmon_tests_planned.mas";
$expected_file = "t/perfmon_tests_planned.expected";
$expected      = slurp $expected_file;

$cmd = "( echo '#! mason <<$EOFMARKER' ; cat $payload_file ; echo '$EOFMARKER' ) | $netcat -w1 localhost $port";
$res = `$cmd`;
is( $res, $expected, "mason 1");

# EOF marker with whitespace
$cmd = "( echo '#! mason << $EOFMARKER' ; cat $payload_file ; echo '$EOFMARKER' ) | $netcat -w1 localhost $port";
$res = `$cmd`;
is( $res, $expected, "mason eof marker with whitespace");

# ____________________ CLOSE SERVER ____________________

#sleep 60;
$api->run("stop");

done_testing();
