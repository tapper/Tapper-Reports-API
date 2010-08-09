package Artemis::Reports::API;

use 5.010;
use strict;
use warnings;

our $VERSION = '2.010022';

use parent 'Net::Server::Fork';

use Artemis::Reports::DPath::Mason;
use Artemis::Model 'model';
use Data::Dumper;

sub process_request
{
        my ($self) = @_;

        my $cmdline = <STDIN>;
        my ($cmd, @args) = _split_cmdline( $cmdline );
        no strict 'refs';
        $cmd       //= "TAP";
        my $handle   = "handle_$cmd";
        $self->$handle (@args);
}

sub handle_TAP
{
        my ($self, @args) = @_;

        #print STDERR "Unrecognized input, interpret as TAP, but: TAP reporting via this API not yet implemented\n";
        print STDERR "Unrecognized input.\n";
}

sub handle_upload
{
        my ($self, $report_id, $filename, $contenttype) = @_;

        my $payload = '';
        $payload .= $_ while <STDIN>;

        my $reportfile = model('ReportsDB')->resultset('ReportFile')->new({ report_id   => $report_id,
                                                                            filename    => $filename,
                                                                            filecontent => $payload,
                                                                            contenttype => $contenttype || 'plain', # 'application/octet-stream',
                                                                          });
        $reportfile->insert;
}

sub _parse_args {
        my (@args) = @_;

        my %args = ();

        foreach (@args) {
                my ($k, $v) = split /=/;
                $k =~ s/^-+//;
                $args{$k} = $v;
        }
        return %args;
}

sub handle_mason
{
        my ($self, @args) = @_;

        my %args = _parse_args(@args[0..$#args-1]);

        # unite '<<' and EOFMARKER when whitespace separated, in order to fix confusion
        $args[-2] .= pop @args if $args[-2] && $args[-2] eq '<<';

        my $EOFMARKER;
        $EOFMARKER = $1 if $args[-1] =~ /<<(.*)/;
        return '' unless $EOFMARKER;

        # ----- read template -----

        my $line;
        my $payload = '';
        while ($line = <STDIN>)
        {
                last if ($line =~ /^$EOFMARKER\s*$/);
                $payload .= $line;
        }

        # ----- compile template -----

        my $mason  = new Artemis::Reports::DPath::Mason(debug => $args{debug} ? 1 : 0);
        my $answer = $mason->render(template => $payload);

        print $answer;
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
        my ($self) = @_;
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
