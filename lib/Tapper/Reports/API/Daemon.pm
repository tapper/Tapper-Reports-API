package Tapper::Reports::API::Daemon;

use 5.010;

use strict;
use warnings;

use Tapper::Reports::API;
use Moose;

with 'MooseX::Daemonize';

has server => (is => 'rw');
has port   => (is => 'rw', isa => 'Int', default => 7358);

after start => sub {
                    my $self = shift;

                    return unless $self->is_daemon;

                    $self->initialize_server;
                    $self->server->server_loop;
                   }
;

sub initialize_server
{
        my $self = shift;
        
        my $EUID = `id -u`; chomp $EUID;
        my $EGID = `id -g`; chomp $EGID;
        Tapper::Reports::API->run(
                                   port         => $self->port,
                                   log_level    => 2,
                                   max_servers  => 10,
                                   max_requests => 10,
                                   user         => $EUID,
                                   group        => $EGID,
                                  );
}
;

sub run
{
        my $self = shift;

        my ($command) = @ARGV ? @ARGV : @_;
        return unless $command && grep /^$command$/, qw(start status restart stop);
        $self->$command;
        say $self->status_message;
}
;


1;
