use strict;
use warnings;

use inc::Module::Install;

name     'Artemis-Reports-API';
all_from 'lib/Artemis/Reports/API.pm';
author   'OSRC SysInt Team <osrc-sysint@elbe.amd.com>';


build_requires 'Cwd'                         => 0;
build_requires 'Test::More'                  => 0;
build_requires 'Test::Deep'                  => 0;
build_requires 'Artemis::Test'               => '2.010004';
build_requires 'Test::Fixture::DBIC::Schema' => 0;

requires 'perl'                       => '5.010';
requires 'Module::Build'              => 0;
requires 'Artemis::Config'            => '2.010004';
requires 'Artemis::Schema'            => '2.010028';
requires 'Artemis::Reports::DPath'    => '2.010015';
requires 'Data::Structure::Util'      => 0;
requires 'Method::Signatures'         => 0;
requires 'Moose'                      => "0.72";
requires 'Net::Server'                => 0;
requires 'MooseX::Daemonize'          => "0.08";

WriteAll;
