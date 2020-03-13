#!/usr/bin/env bash

set -euo pipefail
IFS=$'\t\n'
[[ $# -le 1 ]] || exit 2
readonly demanded_version=${1-}

readonly self=$(realpath -- "$0")
readonly root=${self%/*/*}
cd -- "$root/libxml"
readonly make=${MAKE:-make}
readonly installation_prefix=$PWD
if [[ -z "$demanded_version" ]]; then
    shopt -s nullglob
    readonly versions=(libxml2-*)
    shopt -u nullglob
    case ${#versions[@]} in
        0)  echo 'Unable to find `libxml/libxml2-*`.' >&2
            exit 1
            ;;
        1)  cd -- "$versions"
            ;;
        *)  {
                echo "Found multiple versions of libxml2: ${versions[*]#libxml2-}"
                echo 'Please, select which one to use.'
            } >&2
            exit 1
            ;;
    esac
elif [[ -e "libxml2-$demanded_version" ]]; then
    cd "libxml2-$demanded_version"
else
    echo 'Unable to find `libxml/libxml2-'"$demanded_version"'`.' >&2
    exit 1
fi

./configure --prefix="$installation_prefix" \
    --without-debug --without-docbook --without-ftp --without-html --without-http --without-iconv \
    --without-iso8859x --without-legacy --without-output --without-push --without-python \
    --without-reader --without-regexps --without-sax1 --without-schematron --without-valid \
    --without-writer --without-xinclude --without-modules --without-zlib
"$make" -j"$(nproc)"
rm -rf -- "${installation_prefix:?}"/{bin,include,lib,share}
"$make" install

mkdir -p -- "$root/bin"
if [[ $OSTYPE =~ ^msys ]]; then
    echo "I don't know how to soft-link files on Windows and which libraries to link." >&2
    exit 1
else
    cd -- "$root/bin"
    ln -sf ../libxml/lib/libxml2.so* .
fi
