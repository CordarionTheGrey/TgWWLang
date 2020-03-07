#!/usr/bin/env python3
# coding: utf-8
#
# MIT License
#
# Copyright © 2019-2020 Cordarion the Grey
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

"""
Usage:
    tgwwlang.py check
        [--model <langfile>] [--json]
        [--] <langfile>
    tgwwlang.py update
        [-i <indent>] [--move-comments] [--json] [--no-backup]
        [--model <langfile>] [--assign-attributes]
        [(--base <langfile> [(--add-missing [--only <keys>])] [--reorder])]
        [--] <langfile>
    tgwwlang.py -h
    tgwwlang.py -V

Options:
    -h, --help           Show this message.
    -V, --version        Show version number.
    --model <langfile>   The reference langfile (English.xml).
    --base <langfile>    A langfile where additional data is taken from.
    -i, --indent <size>  Size of indentation. Prepend `-` to not indent direct
                         children of the root. Append `t` to indent with tabs.
                         [default: 2]
    --move-comments      Move external comments into `<string>` tags.
    --json               Produce machine-readable output.
    --no-backup          Do not create `.bak` file.
    --assign-attributes  Copy `<string>` attributes from the model langfile.
    --add-missing        Copy missing strings from the base langfile.
    --only <keys>        Copy only specified strings (comma-separated).
    --reorder            Reorder strings to match the base langfile.
"""

from __future__ import print_function

import collections
import copy
import os.path
import re
import sys

try:
    from future_builtins import map, zip
except ImportError:
    pass

import docopt
from   lxml import etree
import schema


__version__ = "0.4.0"

MODEL_LANGFILE = "English.xml"
SCHEMA_PATH = "%s/tgwwlang.xsd" % os.path.dirname(os.path.realpath(__file__))

g_xml_schema = None


class FileID:
    NONE   = 0
    MODEL  = 1
    BASE   = 2
    TARGET = 3


class MessageCode:
    # We can add, remove, and rename constants here, but must not change assigned numbers.
    # 1-digit codes (frequently used):
    MISSING_STRING      = 0
    UNKNOWN_KEY         = 1
    MISSING_PLACEHOLDER = 2
    EXTRA_PLACEHOLDER   = 3
    ADDED_STRING        = 4
    # 2-digit codes (rarely used):
    NOT_FOUND                  = 10
    NOT_DEFAULT                = 11
    CLOSED                     = 12
    EMPTY_LANGUAGE_ATTRIBUTE   = 13
    MULTIPLE_DEFINITIONS       = 14
    EMPTY_VALUE                = 15
    NO_VALUES                  = 16
    SAME_LANGUAGE_NAME         = 17
    SAME_LANGUAGE_BASE_VARIANT = 18
    INCONSISTENT_PLACEHOLDERS  = 19
    INVALID_ATTRIBUTE          = 20


class Deprecated:
    FALSE = 1
    TRUE  = 2
    BOTH  = 3


LanguageSummary = \
    collections.namedtuple("LanguageSummary", "name  base  variant  owner  default  dom")
String = collections.namedtuple("String", "gif  values  dom")
Value = collections.namedtuple("Value", "placeholders  dom")
Language = collections.namedtuple("Language", "filename  summary  strings  deprecated_summary  dom")


class AnnotationCollector:
    def __init__(self):
        self.success = True
        self.messages = [[ ], [ ], [ ], [ ]]
        self.errors = [[ ], [ ], [ ], [ ]]

    def add_error(self, fid, line, text):
        self.success = False
        self.errors[fid].append((line or 0, text))

    def add_message(self, code, fid, line, *details):
        self.messages[fid].append((code, line or 0, details))


g_collector = AnnotationCollector()
add_error = g_collector.add_error
add_message = g_collector.add_message


if sys.version_info.major >= 3:
    stringify = str
else:
    def stringify(obj):
        return obj if isinstance(obj, str) else unicode(obj).encode("utf-8")


def parse_indentation_spec(spec):
    m = re.match(r"-?(?!\Z)([0-9]*)(t?)\Z", spec)
    if m is None:
        raise ValueError("Invalid indentation spec: `%s`" % spec)
    return spec[0] == '-', int(m.group(1) or 1) * ('\t' if m.group(2) else ' ')


def parse_csv(s):
    if not s:
        return [ ]
    values = s.split(',')
    if len(values) != len(set(values)):
        raise ValueError("Duplicates in the list: `%s`" % s)
    return values


def transform_args(args):
    return schema.Schema({
        "<langfile>": os.path.isfile,
        "--indent": schema.Use(parse_indentation_spec),
        "--model": schema.Or(None, os.path.isfile),
        "--base": schema.Or(None, os.path.isfile),
        "--only": schema.Or(None, schema.Use(parse_csv)),
        str: schema.Or(bool, str),
    }).validate(args)


def select_backup(path):
    prefix, name = os.path.split(path)
    return os.path.join(prefix, ".%s.bak" % name)


try:
    replace_file = os.replace
except AttributeError:
    def replace_file(src, dst):
        if not sys.platform.startswith("win"):
            try:
                os.rename(src, dst)
                return
            except OSError as e:
                import errno

                if e.errno != errno.EEXIST:
                    raise
        os.remove(dst)
        os.rename(src, dst)


def load_xml_schema():
    global g_xml_schema
    g_xml_schema = etree.XMLSchema(etree.parse(SCHEMA_PATH))


def is_true(value):
    return value == "true"


def load_language(fid, filename):
    tree = etree.parse(filename)
    g_xml_schema.assertValid(tree)
    root = tree.getroot()

    lang = root.find("language")
    summary = LanguageSummary(
        name=lang.get("name"),
        base=lang.get("base"),
        variant=lang.get("variant"),
        owner=lang.get("owner") or "",
        default=is_true(lang.get("isDefault")),
        dom=lang,
    )
    if not summary.name:
        add_message(MessageCode.EMPTY_LANGUAGE_ATTRIBUTE, fid, lang.sourceline, "name")
    if not summary.base:
        add_message(MessageCode.EMPTY_LANGUAGE_ATTRIBUTE, fid, lang.sourceline, "base")
    if not summary.variant:
        add_message(MessageCode.EMPTY_LANGUAGE_ATTRIBUTE, fid, lang.sourceline, "variant")

    strings = collections.OrderedDict()
    deprecated_summary = collections.OrderedDict()
    for string in root.iterchildren("string"):
        key = string.get("key")
        deprecated = is_true(string.get("deprecated"))

        cur_status = Deprecated.TRUE if deprecated else Deprecated.FALSE
        prev_status = deprecated_summary.get(key)
        if prev_status is not None:
            # A non-deprecated string followed by a deprecated one is OK, but not vice versa.
            if cur_status <= prev_status:
                add_message(MessageCode.MULTIPLE_DEFINITIONS, fid, string.sourceline, key)
            if cur_status != prev_status:
                cur_status = Deprecated.BOTH
        deprecated_summary[key] = cur_status

        # Check that `<value>`s are present and non-empty.
        values = [ ]
        for value in string.iterchildren("value"):
            if not value.text:
                add_message(MessageCode.EMPTY_VALUE, fid, value.sourceline, key)
            values.append(Value(
                placeholders=frozenset(
                    m.group(1)
                    for m in re.finditer(r"(?<!\{)(?:\{\{)*(\{[^{}]*\})", value.text or "")
                ),
                dom=value,
            ))
        if not values:
            add_message(MessageCode.NO_VALUES, fid, string.sourceline, key)

        strings.setdefault((key, deprecated), String(
            gif=is_true(string.get("isgif")),
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


def check_placeholders_sanity(fid, model):
    for (key, _), string in model.strings.items():
        if len({value.placeholders for value in string.values}) > 1:
            add_message(MessageCode.INCONSISTENT_PLACEHOLDERS, fid, string.dom.sourceline, key)


def load_model_language(filename):
    if filename is None and not os.path.isfile(MODEL_LANGFILE):
        add_message(MessageCode.NOT_FOUND, FileID.MODEL, 0)
        return None
    filename = filename or MODEL_LANGFILE
    lang = load_language(FileID.MODEL, filename)
    if not lang.summary.default:
        add_message(MessageCode.NOT_DEFAULT, FileID.MODEL, lang.summary.dom.sourceline)
    check_placeholders_sanity(FileID.MODEL, lang)
    return lang


def load_target_language(filename):
    lang = load_language(FileID.TARGET, filename)
    if lang.summary.owner:
        add_message(MessageCode.CLOSED, FileID.TARGET, lang.summary.dom.sourceline,
            lang.summary.owner,
        )
    return lang


def check_summary(lang, base):
    a = lang.summary
    b = base.summary
    if a.name == b.name:
        add_message(MessageCode.SAME_LANGUAGE_NAME, FileID.TARGET, a.dom.sourceline, a.name)
    if (a.base, a.variant) == (b.base, b.variant):
        add_message(MessageCode.SAME_LANGUAGE_BASE_VARIANT, FileID.TARGET, a.dom.sourceline,
            a.name, a.variant,
        )


def check_available_strings(fid, lang, model):
    for (key, deprecated), string in lang.strings.items():
        model_deprecated = model.deprecated_summary.get(key)
        # Check if it exists at all.
        if model_deprecated is None:
            add_message(MessageCode.UNKNOWN_KEY, fid, string.dom.sourceline, key)
            continue

        # Check if it is wrongly deprecated.
        if deprecated and model_deprecated == Deprecated.FALSE:
            add_message(MessageCode.INVALID_ATTRIBUTE, fid, string.dom.sourceline,
                key, "deprecated",
            )

        model_string = model.strings.get((key, deprecated)) or model.strings[key, not deprecated]
        # Check if it has an unneded GIF.
        if string.gif and not model_string.gif:
            add_message(MessageCode.INVALID_ATTRIBUTE, fid, string.dom.sourceline, key, "isgif")

        # Check placeholders.
        if model_string.values:
            model_placeholders = model_string.values[0].placeholders
            for value in string.values:
                for missing in sorted(model_placeholders - value.placeholders):
                    add_message(MessageCode.MISSING_PLACEHOLDER, fid, value.dom.sourceline,
                        key, missing,
                    )
                for extra in sorted(value.placeholders - model_placeholders):
                    add_message(MessageCode.EXTRA_PLACEHOLDER, fid, value.dom.sourceline,
                        key, extra,
                    )


def check_missing_strings(fid, lang, model):
    for key, deprecated in model.deprecated_summary.items():
        if deprecated != Deprecated.TRUE and key not in lang.deprecated_summary:
            add_message(MessageCode.MISSING_STRING, fid, 0, key)


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
        for node in comment.itersiblings():
            if node.tag is not etree.Comment:
                break
            comments.append(node)
        else: # No `<string>` found.
            return
        if node.tag == "string":
            # Reattach comments to that `<string>`.
            node.insert(0, comment)
            for other in comments:
                comment.addnext(other)
                comment = other
        del comments[:]


def modify_strings(lang, base, model, reorder, add_missing, only):
    if not reorder and not add_missing:
        return
    root = lang.dom.getroot()
    if not reorder and only is not None:
        for key in only:
            try:
                base_deprecated = base.deprecated_summary[key]
            except KeyError:
                add_message(MessageCode.MISSING_STRING, FileID.BASE, 0, key)
                continue
            model_deprecated = model.deprecated_summary.get(key, Deprecated.TRUE)
            found = 0x0
            for deprecated in (False, True):
                try:
                    base_string = base.strings[key, deprecated]
                except KeyError:
                    continue
                string = lang.strings.get((key, deprecated))
                if string is None and model_deprecated != Deprecated.BOTH:
                    string = lang.strings.get((key, not deprecated))
                if string is None:
                    add_message(MessageCode.ADDED_STRING, FileID.TARGET, 0, key)
                    string = lang.strings[key, deprecated] = copy.deepcopy(base_string)
                    root.append(string.dom)
                found |= 1 << deprecated
            assert found != 0x0
            lang.deprecated_summary[key] = found
        return

    if only is None:
        def should_add(key, deprecated, model_deprecated):
            return not deprecated and model_deprecated != Deprecated.TRUE
    else:
        only = set(only)

        def should_add(key, deprecated, model_deprecated):
            return key in only

    for (key, deprecated), base_string in base.strings.items():
        model_deprecated = model.deprecated_summary.get(key, Deprecated.TRUE)
        string = lang.strings.get((key, deprecated))
        if string is None and model_deprecated != Deprecated.BOTH:
            string = lang.strings.get((key, not deprecated))
        if string is not None:
            if reorder:
                root.append(string.dom)
        elif add_missing and should_add(key, deprecated, model_deprecated):
            add_message(MessageCode.ADDED_STRING, FileID.TARGET, 0, key)
            string = lang.strings[key, deprecated] = copy.deepcopy(base_string)
            lang.deprecated_summary[key] = (
                Deprecated.BOTH if key in lang.deprecated_summary else
                Deprecated.TRUE if deprecated else
                Deprecated.FALSE
            )
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
                add_message(MessageCode.MULTIPLE_DEFINITIONS, FileID.TARGET, string.sourceline, key)
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


def run(args):
    # Load langfiles.
    fid = FileID.NONE
    try:
        load_xml_schema()
        fid = FileID.MODEL
        model = load_model_language(args["--model"])
        if model is None and args["--assign-attributes"]:
            add_error(FileID.MODEL, 0, "`--assign-attributes` requires a model langfile.")
            return False

        fid = FileID.BASE
        base = args["--base"] and load_language(FileID.BASE, args["--base"])
        fid = FileID.TARGET
        lang = load_target_language(args["<langfile>"])
    except (etree.XMLSyntaxError, etree.DocumentInvalid) as e:
        for s in map(stringify, e.error_log.filter_from_errors()):
            m = re.match(r'[^\x00-\x1F"*:<>?|]*:([0-9]+):[0-9]*:\w*:', s)
            if m is not None:
                add_error(fid, int(m.group(1)), s[m.end():])
            else:
                add_error(fid, 0, s)
        return False

    # Validate langfiles.
    if model is not None:
        check_summary(lang, model)
    if base is not None and (model is None or base.filename != model.filename):
        check_summary(lang, base)
    if model is None:
        if base is not None:
            check_placeholders_sanity(FileID.BASE, base)
        check_placeholders_sanity(FileID.TARGET, lang)
    else:
        if base is not None and base.filename != model.filename:
            check_available_strings(FileID.BASE, base, model)
        check_available_strings(FileID.TARGET, lang, model)
        if args["--add-missing"]:
            check_missing_strings(FileID.BASE, base, model)
        else:
            check_missing_strings(FileID.TARGET, lang, model)

    if args["update"]:
        # Mutate the langfile.
        if args["--move-comments"]:
            move_comments(lang.dom.getroot())
        if base is not None:
            modify_strings(
                lang, base, model or base,
                reorder=args["--reorder"],
                add_missing=args["--add-missing"],
                only=args["--only"],
            )
        if args["--assign-attributes"]:
            assign_attributes(lang, model)
        reformat(lang.dom.getroot(), *args["--indent"])

        # Write it back to the disk.
        serialized = \
            b'<?xml version="1.0" encoding="utf-8"?>\n' + etree.tostring(lang.dom, encoding="utf-8")
        if not args["--no-backup"]:
            replace_file(args["<langfile>"], select_backup(args["<langfile>"]))
        with open(args["<langfile>"], "wb") as f:
            f.write(serialized)

    return True


MESSAGE_TEMPLATES = {
    MessageCode.MISSING_STRING: 'Missing "{0}".',
    MessageCode.UNKNOWN_KEY: '"{0}" is not declared in {model}.',
    MessageCode.MISSING_PLACEHOLDER: 'Missing `{1}` in "{0}".',
    MessageCode.EXTRA_PLACEHOLDER: 'Extra `{1}` in "{0}".',
    MessageCode.ADDED_STRING: 'Adding "{0}".',
    MessageCode.NOT_FOUND: 'Model langfile is not found. Some checks will be skipped.',
    MessageCode.NOT_DEFAULT: 'This is not a default language, yet it is selected as a model.',
    MessageCode.CLOSED: 'This is a closed langfile. Its owner is https://t.me/{0}',
    MessageCode.EMPTY_LANGUAGE_ATTRIBUTE: "Language's `{0}` is empty.",
    MessageCode.MULTIPLE_DEFINITIONS: 'Multiple definitions of "{0}".',
    MessageCode.EMPTY_VALUE: '"{0}" has an empty `<value>`.',
    MessageCode.NO_VALUES: '"{0}" should have at least one `<value>`.',
    MessageCode.SAME_LANGUAGE_NAME: 'The language has the same `name` as its base or model: "{0}".',
    MessageCode.SAME_LANGUAGE_BASE_VARIANT:
        'The language has the same `base`/`variant` as its base or model: "{0}"/"{1}".',
    MessageCode.INCONSISTENT_PLACEHOLDERS: 'Inconsistent placeholders in "{0}".',
    MessageCode.INVALID_ATTRIBUTE: '"{0}" does not have `{1}="true"` in {model}.',
}

INFO_MESSAGES = {MessageCode.ADDED_STRING, MessageCode.CLOSED}


def compose_prefix(prefix, line):
    return prefix if line == 0 else "%s:%s" % (prefix, line)


def print_log_entry(prefix, text):
    print(prefix, text, sep=": ")


def print_pretty_log(collector, lang, base, model):
    should_add_blank_line = False
    info_prefix = "\x1B[1;34mINFO\x1B[0m"
    warning_prefix = "\x1B[1;33mWARNING\x1B[0m"
    error_prefix = "\x1B[1;31mERROR\x1B[0m"
    model = model or MODEL_LANGFILE
    files = ("<none>", model, base, lang)
    for filename, errors, messages in zip(files, collector.errors, collector.messages):
        if not errors and not messages:
            continue

        if should_add_blank_line:
            print()
        else:
            should_add_blank_line = True
        print("%s:" % filename)
        missing = 0
        for code, line, details in messages:
            print_log_entry(
                compose_prefix(info_prefix if code in INFO_MESSAGES else warning_prefix, line),
                MESSAGE_TEMPLATES[code].format(
                    *details, file=filename, target=lang, base=base, model=model,
                ),
            )
            missing += code == MessageCode.MISSING_STRING
        if missing != 0:
            print_log_entry(
                info_prefix,
                "%s missing strings." % missing if missing != 1 else "1 missing string.",
            )
        for line, text in errors:
            print_log_entry(compose_prefix(error_prefix, line), text)


def prepare_json_log(collector):
    return {
        "success": collector.success,
        "annotations": [
            {"file": fid, "errors": errors, "messages": messages}
            for fid, (errors, messages) in enumerate(zip(collector.errors, collector.messages))
            if errors or messages
        ],
    }


def main():
    # Parse arguments.
    try:
        args = transform_args(docopt.docopt(__doc__, version="tgwwlang.py v%s" % __version__))
    except (docopt.DocoptExit, schema.SchemaError) as e:
        print(stringify(e), file=sys.stderr)
        sys.exit(2)

    ok = run(args)
    if not args["--json"]:
        print_pretty_log(g_collector, args["<langfile>"], args["--base"], args["--model"])
    else:
        import json

        json.dump(
            prepare_json_log(g_collector),
            sys.stdout,
            ensure_ascii=False,
            separators=(',', ':'),
            sort_keys=True,
        )
        print()

    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
