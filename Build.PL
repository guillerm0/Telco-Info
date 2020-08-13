use 5.006;
use strict;
use warnings;
use Module::Build;
Module::Build->VERSION('0.4004');

my $builder = Module::Build->new(
    module_name         => 'Telco::Info',
    license             => 'artistic_2',
    dist_author         => q{Guillermo Martinez <guillermo.marcial@gmail.com>},
    dist_version_from   => 'lib/Telco/Info.pm',
    release_status      => 'stable',
    script_files        => ['script/telco-info'],
    dat_files           => {'lib/Telco/Spec/network_information.dat' =>'lib/Telco/Spec/network_information.dat' },
    configure_requires => {
        'Module::Build' => '0.4004',
    },
    test_requires => {
        'Test::More' => '0',
    },
    requires => {
        'File::Spec'    => '0',
        'Text::CSV'     => '0',
        'Data::Printer' => => '0'
    },
    add_to_cleanup     => [ 'Telco-Info-*' ],
);
$builder->add_build_element('dat');
$builder->create_build_script();
