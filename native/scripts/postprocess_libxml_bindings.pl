# This script is run as part of `gen_libxml_bindings.sh`. You won't need to execute it directly.

use v5.10;
use strict;
use warnings;
use autodie;
use Text::Tabs "expand";

# Translate tabs at BOL to 4 spaces.
s/\G *+\K\t/    /g;
# Translate other tabs to 8 spaces.
$_ = expand $_;
# DStep sometimes imports stdlib and sometimes stddef, with no changes to the code.
s/^\s*import\s+core\s*\.\s*stdc\s*\.\s*std\Klib\b/def/;
if ($ARGV eq "encoding.d") {
    # DStep incorrectly renames `xmlCharEncoding` enum members.
    s/^\s*\K(?=[0-9])/iso/ if /^\s*enum\s+xmlCharEncoding\b/ ... /^\s*\}/;
} elsif ($ARGV eq "tree.d" && /^\s*struct\s+(\w+)\s*;/) {
    # Forward declarations are used here instead of file inclusion.
    if ($1 =~ /^_xml(?:ParserInputBuffer|ParserInput|ParserCtxt|SAXLocator|SAXHandler|Entity)$/) {
        # D handles circular dependencies better than C, so we don't need these
        # forward declarations.
        $_ = "";
    } elsif ($1 eq "_xmlOutputBuffer") {
        # libxml may be compiled without support for output. `_xmlOutputBuffer` will not be present
        # at all in that case.
        $_  = "static if (!__traits(compiles, _xmlOutputBuffer))\n"
            . "    struct _xmlOutputBuffer;\n";
    }
} elsif ($ARGV eq "xmlstring.d") {
    # UTF-8 is the de-facto standard in D, so we don't need to prevent mixing XML strings with
    # "other strings" in the program, since there are (or, at least, should be) no other strings
    # (aside from UTF-16 and UTF-32, but the type system takes care about them for us).
    s/^\s*alias\s+xmlChar\s*=\s*\Kubyte\b/char/;
}

# Run at the beginning of each file.
state $file = "";
next if $file eq $ARGV;
$file = $ARGV;

local $_;
my $module = $file =~ s/\.[^.]*$//r;
my %deps;
# libxml relies on transitive inclusion heavily, but D is not C.
$deps{dict} = 1 if $module =~ /^(?:tree|xpath)$/;
$deps{encoding} = 1 if $module =~ /^(?:globals|parserInternals)$/;
$deps{entities} = 1 if $module eq "tree";
$deps{parser} = 1 if $module eq "tree";
$deps{tree} = 1 if $module =~ /^ (?:
    globals|parserInternals|relaxng|SAX2|schemasInternals|xmlschemastypes|xpathInternals
) $/x;
$deps{xmlerror} = 1 if $module eq "relaxng";
$deps{xmlIO} = 1 if $module =~ /^(?:globals|tree)$/;
$deps{xmlstring} = 1 if $module =~ /^ (?:
    entities|hash|parserInternals|pattern|SAX2|schemasInternals|uri|valid|xlink|xmlautomata|xmlIO|
    xmlregexp|xmlschemastypes|xpath|xpathInternals|xpointer
) $/x;
# Collect files included into the corresponding C header.
open my $f, '<', "../../libxml/include/libxml2/libxml/$module.h";
while (<$f>) {
    $deps{$1} = 1 if m|^\s*#\s*include\s*<libxml/(.*?)\.h>|;
}
close $f;

# Write `module` and `import` declarations since DStep doesn't translate them yet.
print "module c_libxml.$module;\n\n";
if (%deps) {
    say "import c_libxml.$_;" for sort { lc($a) cmp lc($b) } keys %deps;
    print "\n";
}
if ($module eq "globals") {
    # `_xmlOutputBuffer` may be compiled out. A stub must be defined in the module in that case.
    print "static if (!__traits(compiles, _xmlOutputBuffer))\n"
        . "    struct _xmlOutputBuffer;\n"
        . "\n";
}
