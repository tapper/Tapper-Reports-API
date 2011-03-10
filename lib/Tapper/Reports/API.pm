package Tapper::Reports::API;

use 5.010;
use strict;
use warnings;

our $VERSION = '3.000004';

use parent 'Net::Server::Fork';

use Tapper::Reports::DPath::Mason;
use Tapper::Reports::DPath::TT;
use Tapper::Model 'model';
use Data::Dumper;

sub process_request
{
        my ($self) = @_;

        my $cmdline = <STDIN>;
        my ($cmd, @args) = _split_cmdline( $cmdline );
        no strict 'refs'; ## no critic (ProhibitNoStrict)
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

sub handle_download
{
        my ($self, $report_id, $filename, $index) = @_;

        $index ||= 0;
        my ($reportfile) =
         model('ReportsDB')
          ->resultset('ReportFile')
           ->search ({ report_id => $report_id,
                       filename  => $filename },
                     { order_by  => 'id' })
            ->slice($index, $index);
        print $reportfile->filecontent if $reportfile->report_id;
}

sub get_payload
{
        my ($self, @args) = @_;

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
        return $payload;

}

sub handle_tt
{
        my ($self, @args) = @_;
        do { print "Template Toolkit is not enabled\n"; return } unless Tapper::Config->subconfig->{reports_enable_tt};

        my %args = _parse_args(@args[0..$#args-1]);
        my $payload = $self->get_payload(@args);

        my $tt  = new Tapper::Reports::DPath::TT(debug => $args{debug} ? 1 : 0);
        my $answer = $tt->render(template => $payload);

        print $answer;
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
        do { print "Mason is not enabled\n"; return } unless Tapper::Config->subconfig->{reports_enable_mason};

        my %args = _parse_args(@args[0..$#args-1]);
        my $payload = $self->get_payload(@args);

        my $mason  = new Tapper::Reports::DPath::Mason(debug => $args{debug} ? 1 : 0);
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

Tapper::Reports::API - Tapper - Remote network API for result evaluation


=head1 SYNOPSIS

    use Tapper::Reports::API;
    my $foo = Tapper::Reports::API->new();
    ...

=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2008-2011 AMD OSRC Tapper Team, all rights reserved.

This program is released under the following license: freebsd


=cut

1; # End of Tapper::Reports::API
