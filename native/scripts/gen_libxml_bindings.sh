#!/usr/bin/env bash

set -euo pipefail
IFS=$'\t\n'
[[ $# -eq 0 ]] || exit 2

readonly self=$(realpath -- "$0")
readonly root=${self%/*/*}
cd -- "$root/libxml/include/libxml2/libxml"
readonly dstep=${DSTEP:-dstep}

run() {
    echo "$@"
    "$@"
}

# libxml2's headers are hell of circular dependencies. While some of them are pretty innocent,
# others make it impossible to parse certain files. We have to patch them.

# Remove <parser.h>, add <tree.h>.
sed -Ei 's|^(\s*#\s*include\s*<libxml/)parser\.h>|\1tree.h>|' xmlerror.h
# Remove <xmlmemory.h>.
sed -Ei '\|^\s*#\s*include\s*<libxml/xmlmemory\.h>| d' tree.h
# Add <xmlstring.h>.
sed -Ei -f- dict.h <<'SED'
\|^\s*#\s*include\s*<libxml/xmlstring\.h>|,$ b
/^\s*#\s*ifdef\s+__cplusplus\>/,$ {
    0,/^/ i #include <libxml/xmlstring.h>
}
SED
# Add <encoding.h> and <xmlerror.h>.
sed -Ei -f- xmlschemas.h <<'SED'
/^\s*#\s*ifdef\s+__cplusplus\>/,$ {
    0,/^/ {
        x
        /e/ !i #include <libxml/encoding.h>
        /x/ !i #include <libxml/xmlerror.h>
        x
    }
    b
}
\:^\s*#\s*include\s*<libxml/(encoding|xmlerror)\.h>: {
    x
    G
    s|\n.*/(.).*|\1|
    x
}
SED

# Translate C headers to D.
readonly cmd=(
    "$dstep"
    --rename-enum-members --space-after-function-name=false --collision-action=abort
    # `LIBXML_DLL_IMPORT` is indirectly defined to be `extern` in <xmlexports.h>, but DStep isn't
    # clever enough to notice that: it emits `enum LIBXML_DLL_IMPORT = XMLPUBVAR;`.
    --skip=LIBXML_DLL_IMPORT
    # Compatibility macros from <tree.h>. We don't need those.
    --skip=xmlChildrenNode --skip=xmlRootNode
    # Typecasting macros from <hash.h> and <xmlstring.h>.
    --skip=XML_CAST_FPTR --skip=BAD_CAST
    -I.. -o"$root/src/c_libxml/"
    -- *.h
)
run "${cmd[@]}"

# Postprocess generated D files.
cd -- "$root/src/c_libxml"
run perl -pi -- "$root/scripts/postprocess_libxml_bindings.pl" *.d
