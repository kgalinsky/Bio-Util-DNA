# DNATools
#
# $Author$
# $Date$
# $Revision$
# $HeadURL$

=head1 NAME

JCVI::DNATools - JCVI Basic DNA tools

=head1 SYNOPSES

    use JCVI::DNATools qw(:all);

    my $clean_ref = cleanDNA($seq_ref);
    my $seq_ref = randomDNA(100);
    my $rev_ref = reverse_complement($seq_ref);

=head1 DESCRIPTION

Provides a set of functions and predefined variables which
are handy when working with DNA.

=cut

package JCVI::DNATools;

use strict;
use warnings;

use version; our $VERSION = qv('0.1.10');

use Exporter 'import';

our %EXPORT_TAGS;
$EXPORT_TAGS{funcs} = [
    qw(
      cleanDNA
      randomDNA
      reverse_complement
      rev_comp
      )
];
$EXPORT_TAGS{all} = [
    @{ $EXPORT_TAGS{funcs} },
    qw(
      $nucleotides              $nucs
      @nucleotides              @nucs
      $nucleotide_match         $nuc_match
      $nucleotide_fail          $nuc_fail

      $degenerates              $degens
      @degenerates              @degens
      $degenerate_match         $degen_match
      $degenerate_fail          $degen_fail

      %degenerate_map           %degen_map
      %degenerate_hierarchy     %degen_hierarchy
      )
];

our @EXPORT_OK = @{ $EXPORT_TAGS{all} };

=head1 VARIABLES

=head2 BASIC VARIABLES

Basic nucleotide variables that could be useful. $nucs is a
string containing all the nucleotides (including the
degenerate ones). $nuc_match and $nuc_fail are precompiled
regular expressions that can be used to match for/against
a nucleotide. $degen* is the same thing but with degenerates.

=cut

our $nucleotides      = 'ABCDGHKMNRSTUVWY';
our @nucleotides      = split //, $nucleotides;
our $nucleotide_match = qr/[$nucleotides]/i;
our $nucleotide_fail  = qr/[^$nucleotides]/i;

our $nucs      = $nucleotides;
our @nucs      = @nucleotides;
our $nuc_match = $nucleotide_match;
our $nuc_fail  = $nucleotide_fail;

our $degenerates      = 'BDHKMNRSVWY';
our @degenerates      = split //, $degenerates;
our $degenerate_match = qr/[$degenerates]/i;
our $degenerate_fail  = qr/[^$degenerates]/i;

our $degens      = $degenerates;
our @degens      = @degenerates;
our $degen_match = $degenerate_match;
our $degen_fail  = $degenerate_fail;

=head2 %degenerate_map

Hash of degenerate nucleotides. Each entry contains a
reference to an array of nucleotides that each degenerate
nucleotide stands for.

=cut

our %degenerate_map = (
    N => [qw( A C G T )],
    B => [qw(   C G T )],    # !A
    D => [qw( A   G T )],    # !C
    H => [qw( A C   T )],    # !G
    V => [qw( A C G   )],    # !T
    M => [qw( A C     )],
    R => [qw( A   G   )],
    W => [qw( A     T )],
    S => [qw(   C G   )],
    Y => [qw(   C   T )],
    K => [qw(     G T )]
);
our %degen_map = %degenerate_map;

=head2 %degenerate_hierarchy

Contains the heirarchy of degenerate nucleotides; N of course contains all the
other degenerates, and the four degenerates that can stand for three different
bases contain three of the two-base degenerates.

=cut

our %degenerate_hierarchy = (
    N => [qw( M R W S Y K   V H D B )],
    B => [qw(       S Y K )],             # !A = [CG],[CT],[GT]
    D => [qw(   R W     K )],             # !C = [AT],[AG],[GT]
    H => [qw( M   W   Y   )],             # !G = [AC],[AT],[CT]
    V => [qw( M R   S     )]              # !T = [AC],[AG],[CG]
);
our %degen_hierarchy = %degenerate_hierarchy;

=head1 FUNCTIONS

=head2 cleanDNA

    my $clean_ref = cleanDNA($seq_ref);

Cleans the sequence for use. Strips out comments (lines starting with '>') and
whitespace, converts uracil to thymine, and capitalizes all characters.

Examples:

    my $clean_ref = cleanDNA($seq_ref);

    my $seq_ref = cleanDNA(\'actg');
    my $seq_ref = cleanDNA(\'act tag cta');
    my $seq_ref = cleanDNA(\'>some mRNA
                             acugauauagau
                             uauagacgaucc');

=cut

sub cleanDNA {
    my $seq_ref = shift;

    my $clean = uc $$seq_ref;
    $clean =~ s/^>.*//m;
    $clean =~ s/$nuc_fail+//g;
    $clean =~ tr/U/T/;

    return \$clean;
}

=head2 randomDNA

    my $seq_ref = randomDNA($length);

Generate random DNA for testing this module or your own
scripts. Default length is 100 nucleotides.

Example:

    my $seq_ref = randomDNA();
    my $seq_ref = randomDNA(600);

=cut

sub randomDNA {
    my $length = shift;
    $length = $length || 100;

    my $seq;
    $seq .= int rand 4 while ( $length-- > 0 );
    $seq =~ tr/0123/ACGT/;

    return \$seq;
}

=head2 reverse_complement

=head2 rev_comp

    my $reverse_ref = reverse_complement($seq_ref);

Finds the reverse complement of the sequence and handles
degenerate nucleotides.

Example:

    $reverse_ref = reverse_complement(\'act');

=cut

sub reverse_complement {
    my $seq_ref = shift;

    my $reverse = reverse $$seq_ref;
    $reverse =~ tr/acgtmrykvhdbnACGTMRYKVHDBN/tgcakyrmbdhvnTGCAKYRMBDHVN/;

    return \$reverse;
}

*rev_comp = \&reverse_complement;

1;

=head1 AUTHOR

Kevin Galinsky, <kgalinsk@jcvi.org>

=cut
