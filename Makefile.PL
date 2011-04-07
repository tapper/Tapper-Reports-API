use strict;
use warnings;

use inc::Module::Install;

name     'Tapper-Reports-API';
all_from 'lib/Tapper/Reports/API.pm';
author   'AMD OSRC Tapper Team <tapper@amd64.org>';
license  'freebsd';

build_requires 'Cwd'                         => 0;
build_requires 'Test::More'                  => 0;
build_requires 'Test::Deep'                  => 0;
build_requires 'Test::Perl::Critic'          => 0;
build_requires 'Tapper::Test' => "3.000010";
build_requires 'Test::Fixture::DBIC::Schema' => 0;

author_requires 'Module::Install::WriteAll';

requires 'perl'                       => '5.010';
requires 'Module::Build'              => 0;
requires 'Tapper::Config' => "3.000010";
requires 'Tapper::Schema' => "3.000010";
requires 'Tapper::Reports::DPath' => "3.000010";
requires 'Data::Structure::Util'      => 0;
requires 'Moose'                      => "0.72";
requires 'Net::Server'                => 0;
requires 'MooseX::Daemonize'          => "0.08";

install_script glob('bin/*');

repository 'git://github.com/amd/Tapper-Reports-API.git';
bugtracker 'http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tapper-Reports-API';

WriteAll;
