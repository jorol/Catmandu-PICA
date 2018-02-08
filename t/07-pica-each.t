#!/usr/bin/perl

use strict;
use warnings;
use warnings qw(FATAL utf8);
use utf8;

use Test::More;

use Catmandu::Importer::PICA;
use Catmandu::Fix;

my $pkg;
BEGIN {
    $pkg = 'Catmandu::Fix::Bind::pica_each';
    use_ok $pkg;
}
require_ok $pkg;

my $fixer = Catmandu::Fix->new(fixes => [q|
	do pica_each()
		if pica_match("010@a",'ger')
			add_field(is_ger,true)
		end
		if pica_match("001U0")
			add_field(has_encoding,true)
		end
		if pica_match("001Ua")
			add_field(is_bogus,true)
		end
	end
|]);



my $importer = Catmandu::Importer::PICA->new( file => './t/files/picaplus.dat', type => "PLUS" );
my $record = $fixer->fix($importer->first);

ok exists $record->{record}, 'created a PICA record';
is $record->{is_ger}, 'true', 'created is_ger tag';
is $record->{has_encoding}, 'true', 'created has_encoding tag';
isnt $record->{is_bogus}, 'true', 'not created is_bogus tag';

done_testing;