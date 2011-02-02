use strict;
use warnings;

use inc::Module::Install;

name     'Tapper-Reports-API';
all_from 'lib/Tapper/Reports/API.pm';
author   'OSRC SysInt Team <osrc-sysint@elbe.amd.com>';
license  'freebsd';

build_requires 'Cwd'                         => 0;
build_requires 'Test::More'                  => 0;
build_requires 'Test::Deep'                  => 0;
build_requires 'Test::Perl::Critic'          => 0;
build_requires 'Tapper::Test'               => '2.010004';
build_requires 'Test::Fixture::DBIC::Schema' => 0;

requires 'perl'                       => '5.010';
requires 'Module::Build'              => 0;
requires 'Tapper::Config'            => '2.010004';
requires 'Tapper::Schema'            => '2.010028';
requires 'Tapper::Reports::DPath'    => '2.010022';
requires 'Data::Structure::Util'      => 0;
requires 'Moose'                      => "0.72";
requires 'Net::Server'                => 0;
requires 'MooseX::Daemonize'          => "0.08";

install_script glob('bin/*');

WriteAll;
