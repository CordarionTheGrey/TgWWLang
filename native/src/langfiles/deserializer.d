module langfiles.deserializer;

import core.stdc.string: strcmp;
import std.array: Appender;
import std.range.primitives;
import std.string: fromStringz;

import langfiles.data;
import langfiles.diagnostics;
import utils;
import xmlwrap;

private nothrow pure @safe:

bool _isTrue(const(char)* s) @system @nogc {
    return !strcmp(s, "true");
}

Unit[string] _findPlaceholders(const(char)[ ] value, immutable(char)*[string] symTable) {
    import std.algorithm;
    import std.utf: byCodeUnit;

    auto s = value.byCodeUnit();
    ptrdiff_t pos;
    Unit[string] result;
    while (true) {
        s = s.find('{');
        if (s.length <= 1)
            return result;
        if (s[1] == '{') {
            s = s[2 .. $];
            continue;
        }
        while (true) {
            pos = s[1 .. $].countUntil('{', '}') + 1;
            if (!pos)
                return result;
            if (s[pos] == '}')
                break;
            s = s[pos .. $];
        }
        () @trusted {
            const placeholderValue = s[0 .. pos + 1].source;
            if (const p = placeholderValue in symTable)
                result[(*p)[0 .. pos + 1]] = Unit._;
            else {
                const interned = placeholderValue.idup;
                symTable[interned] = interned.ptr;
                result[interned] = Unit._;
            }
        }();
        s = s[pos + 1 .. $];
    }
}

struct _DeserializationContext {
nothrow pure @safe:
    Deserializer ds;
    FileID fid;
    DiagnosticsCollector* dc;

    alias ds this;

    void addMessage(string code)(int line, immutable(string)[ ] details) {
        dc.addMessage!code(fid, line, details);
    }

    void deserializeLanguage(XMLNode* node, ref TLanguage model) @system {
        import std.algorithm.comparison: among;
        import std.range.primitives;

        model.node = node;
    loop:
        foreach (attr; node.properties.iter()) {
            const name = attr.name;
            const value = attr.children.content;
            static foreach (prop; ["name", "base", "variant", "owner"])
                if (!strcmp(name, prop)) {
                    mixin(`model.` ~ prop ~ ` = value.fromStringz();`);
                    static if (prop.among("name", "base", "variant")) {
                        // Strange. DMD does not allow to define multiple static variables
                        // with the same name.
                        mixin(`static immutable string[1] details` ~ prop ~ ` = [prop];`);
                        if (mixin(`model.` ~ prop).empty)
                            addMessage!q{emptyLanguageAttribute}(
                                node.line, mixin(`details` ~ prop),
                            );
                    }
                    continue loop;
                }
            if (!strcmp(name, "isDefault"))
                model.default_ = _isTrue(value);
        }
    }

    void updateDeprecation(ref const TString str, ref Deprecated[string] deprecatedSummary) {
        const curStatus = str.deprecated_ ? Deprecated.true_ : Deprecated.false_;
        if (auto p = str.key in deprecatedSummary) {
            const prevStatus = *p;
            // A non-deprecated string followed by a deprecated one is OK, but not vice versa.
            if (curStatus <= prevStatus)
                addMessage!q{multipleDefinitions}(str.node.line, [str.key]);
            if (curStatus != prevStatus)
                *p = Deprecated.both;
        } else
            deprecatedSummary[str.key] = curStatus;
    }

    void deserializeValue(XMLNode* node, string key) @system {
        if (const text = node.children)
            _values ~= TValue(_findPlaceholders(text.content.fromStringz(), _symTable), node);
        else {
            addMessage!q{emptyValue}(node.line, [key]);
            _values ~= TValue(null, node);
        }
    }

    void deserializeString(XMLNode* node, ref TStrings model) @system {
        import std.algorithm.iteration: filter;
        import std.typecons: tuple;

        string key;
        auto str = new TString;
        str.node = node;
        foreach (attr; node.properties.iter()) {
            const name = attr.name;
            const value = attr.children.content;
            if (!strcmp(name, "key"))
                str.key = key = value.fromStringz().idup;
            else if (!strcmp(name, "deprecated"))
                str.deprecated_ = _isTrue(value);
            else if (!strcmp(name, "isgif"))
                str.gif = _isTrue(value);
        }
        updateDeprecation(*str, model.deprecatedSummary);
        _values.clear();
        foreach (child; node.children.iter().filter!(a => a.type == XMLElementType.elementNode)) {
            assert(!strcmp(child.name, "value"));
            deserializeValue(child, key);
        }
        if (_values.data.empty)
            addMessage!q{noValues}(node.line, [key]);
        str.values = _values.data.dup;
        _strings ~= str;
        const aaKey = tuple(key, str.deprecated_);
        if (aaKey !in model.stringsAA)
            model.stringsAA[aaKey] = str;
    }

    void deserialize(XMLDoc* doc, ref TStrings model) @system
    in { assert(doc !is null); }
    do {
        import std.algorithm;

        model.doc = doc;
        alias isElementNode = a => a.type == XMLElementType.elementNode;
        auto lang = doc.children;
        assert(!strcmp(lang.name, "strings"));
        lang = lang.children.iter().find!isElementNode().front;
        assert(!strcmp(lang.name, "language"));
        deserializeLanguage(lang, model.parameters);

        _strings.clear();
        foreach (node; lang.next.iter().filter!isElementNode()) {
            assert(!strcmp(node.name, "string"));
            deserializeString(node, model);
        }
        model.strings = _strings.data.dup;
        model.stringsAA.rehash();
        model.deprecatedSummary.rehash();
    }
}

public struct Deserializer {
private nothrow pure @system:
    // Buffers that can be reused across invocations.
    Appender!(TString*[ ]) _strings;
    Appender!(TValue[ ]) _values;
    immutable(char)*[string] _symTable;

    public void deserialize(
        FileID fid, XMLDoc* doc, out TStrings model, ref DiagnosticsCollector dc,
    ) {
        _DeserializationContext(this, fid, &dc).deserialize(doc, model);
    }
}

public Deserializer createDeserializer() {
    import std.array: appender;

    Deserializer ds = {
        _strings: appender!(TString*[ ]),
        _values: appender!(TValue[ ]),
        // Allocate memory for the symbol table, so that it can be passed "by value".
        _symTable: [
            "{0}": &"{0}"[0],
            "{1}": &"{1}"[0],
            "{2}": &"{2}"[0],
            "{3}": &"{3}"[0],
        ],
    };
    ds._strings.reserve(640);
    ds._values.reserve(7);
    return ds;
}
