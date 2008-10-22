use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new
    (
     module_name         => 'Artemis::Reports::API',
     license             => 'restrictive',
     dist_author         => 'OSRC SysInt Team <osrc-sysint@elbe.amd.com>',
     dist_version_from   => 'lib/Artemis/Reports/API.pm',
     build_requires => {
                        'Test::More' => 0,
                        'Artemis::Test' => '2.010004',
                       },
     requires => {
                  'perl'                       => '5.010',
                  'Artemis::Config'            => '2.010004',
                  'Artemis::Schema'            => '2.010018',
                  'Module::Build'              => 0,
                  'Moose'                      => 0,
                  'MooseX::Daemonize'          => 0,
                  'Net::Server::PreForkSimple' => 0,
                 },
     add_to_cleanup     => [ 'Artemis-Reports-API-*' ],
    );

$builder->create_build_script();
