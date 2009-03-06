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
                        'Artemis::Test'               => '2.010004',
                        'Test::Fixture::DBIC::Schema' => 0,
                       },
     requires => {
                  'perl'                       => '5.010',
                  'Module::Build'              => 0,
                  'Artemis::Config'            => '2.010004',
                  'Artemis::Schema'            => '2.010018',
                  'Devel::Declare'             => "0.003004",
                  'B::Hooks::EndOfScope'       => "0.07",
                  'Class::MOP'                 => "0.78",
                  'Parse::Method::Signatures'  => "1.003000",
                  'Moose'                      => "0.72",
                  'MooseX::Types'              => "0.09",
                  'MooseX::Types::Structured'  => "0.07",
                  'MooseX::Method::Signatures' => "0.12",
                  'MooseX::Declare'            => "0.09",
                  'Net::Server::PreForkSimple' => 0,
                  'MooseX::Daemonize'          => 0,
                 },
     add_to_cleanup     => [ 'Artemis-Reports-API-*' ],
    );

$builder->create_build_script();
