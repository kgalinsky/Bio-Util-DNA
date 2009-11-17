use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'JCVI::DNATools',
    license             => 'perl',
    dist_author         => 'Kevin Galinsky <kgalinsk@jcvi.org>',
    dist_version_from   => 'lib/JCVI/DNATools.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'JCVI-DNATools-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
