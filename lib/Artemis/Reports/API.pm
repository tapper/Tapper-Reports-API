package Artemis::Reports::API;

use 5.010;

use strict;
use warnings;

our $VERSION = '2.010001';

use parent 'Net::Server::PreForkSimple';
use Artemis::Model 'model';
use Data::Dumper;

sub process_request
{
        my ($self) = @_;

        $self->{input} = '';
        while (<STDIN>) {
                $self->{input} .= $_ ;
        }
}

sub handle_input
{
        my ($self, $cmd, $payload, @args) = @_;

}

sub handle_upload
{
        my ($self, $payload, $report_id, $filename, $contenttype) = @_;

        my $reportfile = model('ReportsDB')->resultset('ReportFile')->new({ report_id   => $report_id,
                                                                            filename    => $filename,
                                                                            filecontent => $payload,
                                                                            contenttype => $contenttype || 'plain', # 'application/octet-stream',
                                                                          });
        $reportfile->insert;
}

sub _split_cmdline
{
        my ($cmdline) = @_;

        $cmdline =~ s/^\s+//;
        my @list = split (/\s+/, $cmdline);
        shift @list; # no shebang
        return @list;
}

sub post_process_request_hook
{
        my ($self) = shift;

        # split cmd and args from payload
        my ($cmdline, $payload) = split (/\n/, $self->{input}, 2);
        my ($cmd, @args) = _split_cmdline( $cmdline );

        no strict 'refs';
        my $handle = "handle_$cmd";
        $self->$handle ($payload, @args);

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
