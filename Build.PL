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
                        'Cwd'                         => 0,
                        'Test::More'                  => 0,
                        'Test::Deep'                  => 0,
                        'Artemis::Test'               => '2.010004',
                        'Test::Fixture::DBIC::Schema' => 0,
                       },
     requires => {
                  'perl'                       => '5.010',
                  'Module::Build'              => 0,
                  'Artemis::Config'            => '2.010004',
                  'Artemis::Schema'            => '2.010028',
                  'Artemis::Reports::DPath'    => '2.010005',
                  'Method::Signatures'         => 0,
                  'Moose'                      => "0.72",
                  'Net::Server'                => 0,
                  'MooseX::Daemonize'          => "0.08",
                 },
     add_to_cleanup     => [ 'Artemis-Reports-API-*' ],
    );

$builder->create_build_script();
