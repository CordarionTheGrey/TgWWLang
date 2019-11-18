#!/usr/bin/env python3

"""
Usage:
    tgwwlang.py check
        [--model <langfile>]
        [--] <langfile>
    tgwwlang.py update
        [-i <indent>] [--move-comments]
        [--model <langfile>] [--assign-attributes]
        [(--base <langfile> [--reorder] [--copy-missing])]
        [--] <langfile>
    tgwwlang.py -h

Options:
    -h, --help           Show this message.
    --model <langfile>   The reference langfile (English.xml).
    --base <langfile>    A langfile where additional data is taken from.
    -i, --indent <size>  Size of indentation. Prepend `-` to not indent direct
                         children of the root. Append `t` to indent with tabs.
                         [default: 2]
    --move-comments      Move comments into corresponding `<string>` tags.
    --assign-attributes  Copy `<string>` attributes from the model langfile.
    --reorder            Reorder strings to match the base langfile.
    --copy-missing       Copy missing strings from the base langfile.
"""

import collections
import copy
import enum
from   pathlib import Path
import os.path
import re
import sys

import docopt
from   lxml import etree
import schema


SCHEMA_PATH = Path(__file__).with_name("TgWWLang.xsd")

Deprecated = enum.Enum("Deprecated", "FALSE  TRUE  BOTH")
LanguageSummary = collections.namedtuple("LanguageSummary", "name  base  variant  owner  default")
String = collections.namedtuple("String", "gif  values  dom")
Value = collections.namedtuple("Value", "placeholders  dom")
Language = collections.namedtuple("Language", "filename  summary  strings  deprecated_summary  dom")

g_xml_schema = None


def info(msg):
    print("\x1B[1;34mINFO\x1B[0m:", msg, file=sys.stderr)


def warn(msg):
    print("\x1B[1;33mWARNING\x1B[0m:", msg, file=sys.stderr)


def error(msg):
    print("\x1B[1;31mERROR\x1B[0m:", msg, file=sys.stderr)


def parse_indentation_spec(spec):
    m = re.fullmatch(r"-?((\d*)(t?))", spec, re.A)
    if m is None or not m.group(1):
        raise ValueError("Invalid indentation spec: `%s`" % spec)
    return spec[0] == '-', int(m.group(2) or 1) * ('\t' if m.group(3) else ' ')


def transform_args(args):
    return schema.Schema({
        "<langfile>": os.path.isfile,
        "--indent": schema.Use(parse_indentation_spec),
        "--model": schema.Or(None, os.path.isfile),
        "--base": schema.Or(None, os.path.isfile),
        str: schema.Or(bool, str),
    }).validate(args)


def load_xml_schema():
    global g_xml_schema
    g_xml_schema = etree.XMLSchema(etree.parse(str(SCHEMA_PATH)))


def load_language(filename):
    tree = etree.parse(filename)
    g_xml_schema.assertValid(tree)
    root = tree.getroot()

    lang = root.find("language")
    summary = LanguageSummary(
        name=lang.get("name"),
        base=lang.get("base"),
        variant=lang.get("variant"),
        owner=lang.get("owner") or "",
        default=bool(lang.get("isDefault")),
    )
    if not summary.name:
        warn("%s:%s: Language name is not set" % (filename, lang.sourceline or 0))
    if not summary.base:
        warn("%s:%s: Base language is not set" % (filename, lang.sourceline or 0))
    if not summary.variant:
        warn("%s:%s: Language variant is not set" % (filename, lang.sourceline or 0))

    strings = collections.OrderedDict()
    deprecated_summary = collections.OrderedDict()
    for string in root.iterchildren("string"):
        key = string.get("key")
        deprecated = bool(string.get("deprecated"))

        cur_status = Deprecated["TRUE" if deprecated else "FALSE"]
        prev_status = deprecated_summary.get(key)
        if prev_status is not None:
            # A non-deprecated string followed by a deprecated one is OK, but not vice versa.
            if cur_status.value <= prev_status.value:
                warn('%s:%s: Multiple definitions of "%s".' % (
                    filename, string.sourceline or 0, key,
                ))
            if cur_status != prev_status:
                cur_status = Deprecated.BOTH
        deprecated_summary[key] = cur_status

        # Check that `<value>`s are present and non-empty.
        values = [ ]
        for value in string.iterchildren("value"):
            if not value.text:
                warn('%s:%s: "%s" has an empty \'<value>\'.' % (
                    filename, value.sourceline or 0, key,
                ))
            values.append(Value(
                placeholders=frozenset(
                    m.group(1)
                    for m in re.finditer(r"(?<!\{)(?:\{\{)*(\{[^{}]*\})", value.text or "")
                ),
                dom=value,
            ))
        if not values:
            warn('%s:%s: "%s" should have at least one \'<value>\'.' % (
                filename, string.sourceline or 0, key,
            ))

        strings.setdefault((key, deprecated), String(
            gif=bool(string.get("isgif")),
            values=values,
            dom=string,
        ))

    return Language(
        filename=filename,
        summary=summary,
        strings=strings,
        deprecated_summary=deprecated_summary,
        dom=tree,
    )


def validate_placeholders(model):
    for (key, _), string in model.strings.items():
        if len({value.placeholders for value in string.values}) > 1:
            warn('%s:%s: Inconsistent placeholders in "%s".' % (
                model.filename, string.dom.sourceline or 0, key,
            ))


def load_model_language(filename):
    if filename is None and not Path("English.xml").is_file():
        warn("English.xml is not found. Some checks will be skipped.")
        return None
    filename = filename or "English.xml"
    lang = load_language(filename)
    if not lang.summary.default:
        warn("%s is NOT the default language." % filename)
    validate_placeholders(lang)
    return lang


def load_target_language(filename):
    lang = load_language(filename)
    if lang.summary.default:
        warn("%s is the default language." % filename)
    if lang.summary.owner:
        info("%s is a closed langfile. Its owner is https://t.me/%s." % (
            filename, lang.summary.owner,
        ))
    return lang


def check_summary(lang, base):
    a = lang.summary
    b = base.summary
    if a.name == b.name:
        warn('%s and %s have the same name: "%s".' % (lang.filename, base.filename, a.name))
    if (a.base, a.variant) == (b.base, b.variant):
        warn('%s and %s have the same base/variant: "%s"/"%s".' % (
            lang.filename, base.filename, a.base, a.variant,
        ))


def check_available_strings(lang, model):
    for (key, deprecated), string in lang.strings.items():
        model_deprecated = model.deprecated_summary.get(key)
        # Check if it exists at all.
        if model_deprecated is None:
            warn('%s:%s: "%s" is not declared in %s.' % (
                lang.filename, string.dom.sourceline or 0, key, model.filename,
            ))
            continue

        # Check if it is wrongly deprecated.
        if deprecated and model_deprecated == Deprecated.FALSE:
            warn('%s:%s: "%s" is not deprecated in %s.' % (
                lang.filename, string.dom.sourceline or 0, key, model.filename,
            ))

        model_string = model.strings.get((key, deprecated)) or model.strings[key, not deprecated]
        # Check if it has an unneded GIF.
        if string.gif and not model_string.gif:
            warn('%s:%s: "%s" does not have a GIF in %s.' % (
                lang.filename, string.dom.sourceline or 0, key, model.filename,
            ))

        # Check placeholders.
        if model_string.values:
            model_placeholders = model_string.values[0].placeholders
            for value in string.values:
                for missing in sorted(model_placeholders - value.placeholders):
                    warn('%s:%s: Missing \'%s\' in "%s".' % (
                        lang.filename, value.dom.sourceline or 0, missing, key,
                    ))
                for extra in sorted(value.placeholders - model_placeholders):
                    warn('%s:%s: Extra \'%s\' in "%s".' % (
                        lang.filename, value.dom.sourceline or 0, extra, key,
                    ))


def check_missing_strings(lang, model):
    total = 0
    for key, deprecated in model.deprecated_summary.items():
        if deprecated != Deprecated.TRUE and key not in lang.deprecated_summary:
            warn('%s: Missing "%s".' % (lang.filename, key))
            total += 1
    if total != 0:
        info("%s missing strings." % total if total != 1 else "1 missing string.")


def move_comments(root):
    comments = [ ]
    node = root[0]
    while True:
        # Find the first comment that is a direct child of the root.
        for comment in node.itersiblings(etree.Comment):
            break
        else: # No more comments left.
            return
        # Find the first `<string>` that follows it, collecting all comments between them.
        for node in comment.itersiblings(etree.Comment, "string"):
            if node.tag == "string":
                break
            comments.append(node)
        else: # No `<string>` found.
            return
        # Reattach comments to that `<string>`.
        node.insert(0, comment)
        for other in comments:
            comment.addnext(other)
            comment = other
        comments.clear()


def modify_strings(lang, base, model, *, reorder, copy_missing):
    if not reorder and not copy_missing:
        return
    root = lang.dom.getroot()
    for (key, deprecated), base_string in base.strings.items():
        model_deprecated = model.deprecated_summary.get(key, Deprecated.TRUE)
        string = lang.strings.get((key, deprecated))
        if string is None and model_deprecated != Deprecated.BOTH:
            string = lang.strings.get((key, not deprecated))
        if string is not None:
            if reorder:
                root.append(string.dom)
        elif copy_missing and not deprecated and model_deprecated != Deprecated.TRUE:
            info('%s: Adding "%s".' % (lang.filename, key))
            string = lang.strings[key, False] = copy.deepcopy(base_string)
            lang.deprecated_summary[key] = \
                Deprecated["BOTH" if key in lang.deprecated_summary else "FALSE"]
            root.append(string.dom)


def assign_attributes(lang, model):
    # HACK: We do not modify our data structures here except DOM.
    for (key, deprecated), string in lang.strings.items():
        model_deprecated = model.deprecated_summary.get(key)
        if model_deprecated is None:
            continue
        if not deprecated and model_deprecated == Deprecated.TRUE:
            string.dom.set("deprecated", "true")
            if lang.deprecated_summary[key] == Deprecated.BOTH:
                # Now both `<string>`s are deprecated, which is illegal.
                warn('%s:%s: Multiple definitions of "%s".' % (
                    lang.filename, string.sourceline or 0, key,
                ))
        if (model.strings.get((key, deprecated)) or model.strings[key, not deprecated]).gif:
            string.dom.set("isgif", "true")


def reformat(root, flat, indentation):
    cache = ['\n', '\n', '\n']

    def recurse(node, level):
        level += 1
        if len(node) > 0:
            if level == len(cache):
                cache.append(cache[-1] + indentation)
            text = node.text
            if not text or text.isspace():
                node.text = cache[level]
            for child in node:
                recurse(child, level)
        text = node.tail
        if not text or text.isspace():
            node.tail = cache[level - (2 if node.getnext() is None else 1)]

    recurse(root, 2 - flat)


def main():
    # Parse arguments.
    try:
        args = transform_args(docopt.docopt(__doc__))
    except docopt.DocoptExit as e:
        print(e, file=sys.stderr)
        sys.exit(2)
    except schema.SchemaError as e:
        error(e)
        sys.exit(2)

    # Load langfiles.
    try:
        load_xml_schema()
        model = load_model_language(args["--model"])
        if model is None and args["--assign-attributes"]:
            error("`--assign-attributes` requires a model langfile.")
            sys.exit(1)

        base = args["--base"] and load_language(args["--base"])
        lang = load_target_language(args["<langfile>"])
    except (etree.XMLSyntaxError, etree.DocumentInvalid) as e:
        for err in e.error_log.filter_from_errors():
            error(err)
        sys.exit(1)

    # Validate langfiles.
    if model is not None:
        check_summary(lang, model)
    if base is not None and (model is None or base.filename != model.filename):
        check_summary(lang, base)
        validate_placeholders(base)
    if model is not None:
        if base is not None and base.filename != model.filename:
            check_available_strings(base, model)
        check_available_strings(lang, model)
        check_missing_strings(base if args["--copy-missing"] else lang, model)

    # Mutate the langfile.
    if args["update"]:
        if args["--move-comments"]:
            move_comments(lang.dom.getroot())
        if base is not None:
            modify_strings(
                lang, base, model,
                reorder=args["--reorder"],
                copy_missing=args["--copy-missing"],
            )
        if args["--assign-attributes"]:
            assign_attributes(lang, model)
        reformat(lang.dom.getroot(), *args["--indent"])
        Path(args["<langfile>"]).write_bytes(
            b'<?xml version="1.0" encoding="utf-8"?>\n' + etree.tostring(lang.dom, encoding="utf-8")
        )


if __name__ == "__main__":
    main()
