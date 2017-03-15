#!/usr/bin/perl

use XML::XSLT;

#print "Content-type: text/html\n\n";

my $xmlfile = "programming.xml";
my $xslfile = "glossary.xsl";

my $parser = XML::XSLT->new ($xslfile, "FILE");

$parser->transform_document ($xmlfile, "FILE");
$parser->print_result();

