package Artemis::Reports::API;

use strict;
use warnings;

our $VERSION = '2.010001';

use parent 'Net::Server::PreForkSimple';

use Data::Dumper;
use Artemis::Model 'model';
use DateTime::Format::Natural;

sub process_request
{
        my $self = shift;

        $self->{payload} = '';
        while (<STDIN>) {
                $self->{payload} .= $_ ;
        }
}

sub evaluate_input
{
        my ($self) = shift;

        my $command_line = $self->{payload} =~ s/^(.*?\n)/;

        open (PAYLOAD, ">", "/tmp/payload.tmp") or die "Cannot open payload file";
        print PAYLOAD $self->{payload};
        close PAYLOAD;

        open (CMD, ">", "/tmp/cmd.tmp") or die "Cannot open cmd file";
        print CMD $command_line;
        close CMD;
}

sub post_process_request_hook
{
        my ($self) = shift;

        $self->evaluate_input();
        say "Thanks.";
}

1;


=head1 NAME

Artemis::Reports::API - A simple remote network API. First line declares language. Following lines are content.


=head1 SYNOPSIS

    use Artemis::Reports::API;
    my $foo = Artemis::Reports::API->new();
    ...

=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>

=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive


=cut

1; # End of Artemis::Reports::API
