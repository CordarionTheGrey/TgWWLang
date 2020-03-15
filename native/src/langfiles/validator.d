module langfiles.validator;

import std.range.primitives;

import langfiles.data;
import langfiles.diagnostics;

struct Validator {
nothrow pure @safe:
    private {
        const(TStrings)* _model;
        DiagnosticsCollector* _dc;
    }

    this(const(TStrings)* model, DiagnosticsCollector* dc) @nogc
    in {
        assert(model !is null);
        assert(dc !is null);
    }
    do {
        _model = model;
        _dc = dc;
    }

    void checkPlaceholdersSanity(FileID fid, ref const TStrings lfile) {
        import std.algorithm.searching: canFind;

        foreach (str; lfile.strings)
            if (str.values.length >= 2 && str.values[1 .. $].canFind!q{a != b}(str.values[0]))
                _dc.addMessage!q{inconsistentPlaceholders}(fid, str.node.line, [str.key]);
    }

    void checkModelLangfile() {
        if (!_model.parameters.default_)
            _dc.addMessage!q{notDefault}(FileID.model, _model.parameters.node.line);
        checkPlaceholdersSanity(FileID.model, *_model);
    }

    void checkTargetLangfile(ref const TStrings target) {
        if (!target.parameters.owner.empty)
            _dc.addMessage!q{closed}(
                FileID.target, target.parameters.node.line, [target.parameters.owner.idup],
            );
    }

    void checkParameters(ref const TStrings target) {
        const a = &target.parameters;
        const b = &_model.parameters;
        if (a.name == b.name)
            _dc.addMessage!q{sameLanguageName}(FileID.target, a.node.line, [a.name.idup]);
        if (a.base == b.base && a.variant == b.variant)
            _dc.addMessage!q{sameLanguageBaseVariant}(
                FileID.target, a.node.line, [a.base.idup, a.variant.idup],
            );
    }

    void checkAvailableStrings(FileID fid, ref const TStrings target) {
        import std.algorithm;
        import std.array: appender;
        import std.typecons: tuple;

        auto arr = appender!(string[ ]);
        foreach (tstr; target.strings) {
            const key = tstr.key;
            {
                const modelDeprecated = key in _model.deprecatedSummary;
                // Check if it exists at all.
                if (modelDeprecated is null) {
                    _dc.addMessage!q{unknownKey}(fid, tstr.node.line, [key]);
                    continue;
                }
                // Check if it is wrongly deprecated.
                if (tstr.deprecated_ && *modelDeprecated == Deprecated.false_)
                    _dc.addMessage!q{invalidAttribute}(fid, tstr.node.line, [key, "deprecated"]);
            }

            const(TString)* mstr;
            if (const p = tuple(key, bool(tstr.deprecated_)) in _model.stringsAA)
                mstr = *p;
            else
                mstr = _model.stringsAA[tuple(key, !tstr.deprecated_)];
            // Check if it has an unneeded GIF.
            if (tstr.gif && !mstr.gif)
                _dc.addMessage!q{invalidAttribute}(fid, tstr.node.line, [key, "isgif"]);

            // Check placeholders.
            if (!mstr.values.empty) {
                const mplaceholders = mstr.values[0].placeholders;
                foreach (value; tstr.values) {
                    arr.clear();
                    arr ~= mplaceholders.byKey().filter!(k => k !in value.placeholders);
                    foreach (missing; arr.data.sort())
                        _dc.addMessage!q{missingPlaceholder}(fid, value.node.line, [key, missing]);

                    arr.clear();
                    arr ~= value.placeholders.byKey().filter!(k => k !in mplaceholders);
                    foreach (extra; arr.data.sort())
                        _dc.addMessage!q{extraPlaceholder}(fid, value.node.line, [key, extra]);
                }
            }
        }
    }

    void checkMissingStrings(FileID fid, ref const TStrings target) {
        foreach (mstr; _model.strings)
            if (!mstr.deprecated_ && mstr.key !in target.deprecatedSummary)
                _dc.addMessage!q{missingString}(fid, 0, [mstr.key]);
    }
}
