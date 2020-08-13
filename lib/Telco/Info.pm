package Telco::Info;

use 5.006;
use strict;
use warnings;
use File::Spec;
use Text::CSV;
=head1 NAME

Telco::Info - The great new Telco::Info!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '1.00';

sub new {
    my $class = shift;
    my $self = {};

    bless $self, $class;

    $self->{'_tadig'} = $self->loadTadigData();
    $self->{'_mccmnc'} = $self->loadMccData();

    return $self;
}

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Telco::Info;

    my $telco = Telco::Info->new();
    $telco->findTelcoByTadig('DOMCL');
    $telco->findTelcoByImsi('310840901471000');


=head1 SUBROUTINES/METHODS

=head2 loadTadigData

=cut

sub loadTadigData {
    my $self = shift;
    my %data;

    my $variable =  [ ( grep(-d $_, map(File::Spec->catdir($_, qw(Telco Spec)), @INC)), File::Spec->curdir) ];
    my $csv = Text::CSV->new ({ binary => 1});
    my $specFile = File::Spec->catfile($variable->[1], $variable->[0],'network_information.csv' );

    open my $io, "<", $specFile or die "$specFile: $!";
    while (my $row = $csv->getline ($io)) {
       $data{$row->[4]} = {} if(!defined($self->{'_tadig'}->{$row->[4]}));
       $data{$row->[4]}{'name'} = $row->[3];
       $data{$row->[4]}{'country'} = $row->[5];
       $data{$row->[4]}{'country_code'} = $row->[6];
        push(@{$data{$row->[4]}{'mcc_mnc'}}, { 'mcc' => $row->[0], 'mnc' => $row->[1], 'mnc3' => $row->[2]});
    }

    $self->{'_tadig'} = \%data;
}

=head2 loadMccData

=cut

sub loadMccData {
    my $self = shift;
    my %data;
    my $variable =  [ ( grep(-d $_, map(File::Spec->catdir($_, qw(Telco Spec)), @INC)), File::Spec->curdir) ];
    my $csv = Text::CSV->new ({ binary => 1});
    my $specFile = File::Spec->catfile($variable->[1], $variable->[0],'network_information.csv' );

    open my $io, "<", $specFile or die "$specFile: $!";
    $csv->getline($io); #Read header
    while (my $row = $csv->getline ($io)) {
        my $mccmnc = $row->[0].$row->[1];
        $data{$mccmnc} = {} if(!defined($data{$row->[4]}));
        $data{$mccmnc}->{'name'} = $row->[3];
        $data{$mccmnc}->{'country'} = $row->[5];
        $data{$mccmnc}->{'country_code'} = $row->[6];
        $data{$mccmnc}->{'mccmnc'} = $mccmnc;
        push(@{$data{$mccmnc}->{'tadig'}}, $row->[4]);
    }
    $self->{'_mccmnc'} = \%data;
}

=head2 findTelcoByTadig

=cut
sub findTelcoByTadig {
    my $self = shift;
    my $tadig = shift;

    if(!defined($self->{'_tadig'}->{$tadig})){
        return { };
    }

    return $self->{'_tadig'}->{$tadig};
}

=head2 findTelcoByImsi

=cut
sub findTelcoByImsi {
    my $self = shift;
    my $imsi = shift;
    my $mccmnc = substr($imsi,0,5);

    if(!defined($self->{'_mccmnc'}->{$mccmnc})){
        return { };
    }

    return $self->{'_mccmnc'}->{$mccmnc};
}

=head1 AUTHOR

Guillermo Martinez, C<< <guillermo.marcial at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-telco-info at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Telco-Info>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Telco::Info


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Telco-Info>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Telco-Info>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/Telco-Info>

=item * Search CPAN

L<https://metacpan.org/release/Telco-Info>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2020 by Guillermo Martinez.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)


=cut

1; # End of Telco::Info
