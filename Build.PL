use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Artemis::Reports::API',
    license             => 'restrictive',
    dist_author         => 'OSRC SysInt Team <osrc-sysint@elbe.amd.com>',
    dist_version_from   => 'lib/Artemis/Reports/API.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Artemis-Reports-API-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
