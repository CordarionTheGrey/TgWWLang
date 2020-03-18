module optlex;

import std.algorithm.comparison: among;
import std.array: Appender;
import std.exception: basicExceptionCtors;
import std.range.primitives;
import std.utf: byCodeUnit;

pure @safe:

bool isSpace(char c) nothrow @nogc {
    return !!c.among!(' ', '\t');
}

bool isQuote(char c) nothrow @nogc {
    return !!c.among!('"', '\'');
}

class OptLexException: Exception {
    mixin basicExceptionCtors;
}

// This lexer generally follows quoting rules of Unix shells (except there is no backslash
// escaping). However, it enters "literate mode" as soon as it sees the first positional argument:
// that argument together with the part of the string after it becomes a single token.
// Therefore, the lexer always yields exactly one positional argument, which may be empty.
struct OptLexSplitter {
pure:
    private {
        enum _State: ubyte {
            options,
            doubleDash,
            literateArg,
            eof,
        }

        Appender!(char[ ]) _app;
        typeof("".byCodeUnit()) _s;
        string _front;
        _State _state;
    }

    invariant {
        assert(_app.data.empty, "Dirty buffer");
    }

    @disable this();

    this(string s)
    out { assert(!empty); } // Even `OptLexSplitter("")` yields `[""]`.
    do {
        import std.algorithm.mutation: strip;
        import std.array: appender;

        _app = appender!(char[ ]);
        _s = s.byCodeUnit().strip!isSpace();
        popFront();
    }

    @property bool empty() const nothrow @nogc {
        return _state == _State.eof;
    }

    @property inout(OptLexSplitter) save() inout nothrow @nogc {
        return this; // The appender can be shared freely.
    }

    @property string front() const nothrow @nogc
    in { assert(!empty, "Called `front` on an empty `OptLexSplitter`"); }
    do {
        return _front;
    }

    private void _setLiterate() nothrow @nogc {
        _state = _State.literateArg;
        _front = _s.source;
    }

    void popFront() {
        import std.algorithm.searching: find, skipOver;

        final switch (_state) with (_State) {
            case options: break;
            case doubleDash: return _setLiterate();
            case literateArg: _state = eof; return;
            case eof: assert(false, "Called `popFront` on an empty `OptLexSplitter`");
        }

        auto s = _s;
        if (s.empty) {
            // Always emit literate argument, even if it empty.
            _state = _State.literateArg;
            _front = null;
            return;
        }

        auto token = s;
        auto app = _app;
        bool needsEscapingDash = true;
        char c;
        // Look at the first character of the next argument.
        while (true) {
            c = s.front;
            if (c == '-') {
                s.popFront();
                break; // Option.
            }
            if (!isQuote(c)) {
                assert(!isSpace(c));
                return _setLiterate(); // Non-option argument.
            }
            if (s.length == 1)
                return _setLiterate(); // Unpaired quotation at EOF.
            needsEscapingDash = false;
            const c1 = s[1];
            if (c1 == '-')
                goto parseQuotedPart; // Quoted option.
            if (c != c1)
                return _setLiterate(); // Quoted non-option argument.
            // Empty quotes at the start of an argument; do not collect them.
            token = s = s[2 .. $];
            if (s.empty)
                return _setLiterate(); // Paired empty quotation at EOF.
        }

        // Now we have an option ahead with its `-` stripped.
        while (!s.empty) {
            c = s.front;
            if (isSpace(c))
                break; // End of option.
            if (!isQuote(c)) {
                s.popFront();
                continue;
            }
        parseQuotedPart:
            app ~= token[0 .. $ - s.length]; // Append postponed chunk before the quotation.
            token = s[1 .. $].find(c);
            if (token.empty) {
                // Unpaired quotation during option parsing.
                app.clear();
                throw new OptLexException("No closing quotation");
            }
            app ~= s[1 .. $ - token.length]; // Append text inside the quotation.
            token.popFront();
            s = token;
        }

        // Collect the option we've just parsed.
        string option;
        if (app.data.empty)
            option = token[0 .. $ - s.length].source;
        else {
            app ~= token[0 .. $ - s.length]; // Append the final postponed chunk.
            option = app.data.idup;
            app.clear();
        }
        assert(option[0] == '-'); // It's an option, after all.

        if (option.length > 1) {
            // Skip spaces between this option and the next argument.
            if (!s.empty) {
                s.popFront();
                s.skipOver!isSpace();
            }
            _s = s;
            _front = option;
            if (option.length == 2 && option[1] == '-') {
                // Special case: `--`.
                _state = _State.doubleDash;
            }
        } else if (needsEscapingDash && _s.length > 1) {
            // Special case: `-`.
            // Insert double dash before this literate argument.
            _state = _State.doubleDash;
            _front = "--";
        } else {
            // Special case: `-`.
            _setLiterate();
        }
    }
}

static assert(isInputRange!OptLexSplitter);
static assert(isForwardRange!OptLexSplitter);

OptLexSplitter splitter(string s) {
    return OptLexSplitter(s);
}

unittest {
    import std.algorithm.comparison: equal;
    import std.algorithm.iteration: each;
    import std.exception: assertThrown;

    assert(
        splitter(`--key=value --phrase="Two words"   Three   spaces.   `)
        .equal([`--key=value`, `--phrase=Two words`, `Three   spaces.`])
    );
    assert(
        splitter(`-kvalue  -p'Two words'`)
        .equal([`-kvalue`, `-pTwo words`, ``])
    );
    assert(
        splitter(`  -k value -p 'Two words'  `)
        .equal([`-k`, `value -p 'Two words'`])
    );
    assert(
        splitter(`--no="backslash\" escaping"`)
        .equal([`--no=backslash\`, `escaping"`])
    );
    assert(
        splitter(`--no=backslash\ escaping`)
        .equal([`--no=backslash\`, `escaping`])
    );
    assert(
        splitter(` `)
        .equal([``])
    );
    assert(
        splitter(`"--double=quotes" -'-single= quo'tes --'mixed="quotes' "More quotes"`)
        .equal([`--double=quotes`, `--single= quotes`, `--mixed="quotes`, `"More quotes"`])
    );
    assert(
        splitter(`--foo=bar -- --not-foo=not-bar --nope it's plain text`)
        .equal([`--foo=bar`, `--`, `--not-foo=not-bar --nope it's plain text`])
    );
    assert(
        splitter(`--quotes='a' "-"'-' -"-"q`)
        .equal([`--quotes=a`, `--`, `-"-"q`])
    );
    assert(
        splitter(`-abc - -def`)
        .equal([`-abc`, `--`, `- -def`])
    );
    assert(
        splitter(`-abc "-" -def`)
        .equal([`-abc`, `"-" -def`])
    );
    assert(
        splitter(`-abc ""- -def`)
        .equal([`-abc`, `""- -def`])
    );
    assert(
        splitter(`-abc -"" -def`)
        .equal([`-abc`, `--`, `-"" -def`])
    );
    assert(
        splitter(`-abc -"" `)
        .equal([`-abc`, `--`, `-""`])
    );
    assert(
        splitter(`-abc - `)
        .equal([`-abc`, `-`])
    );
    assertThrown!OptLexException(
        splitter(`--unclosed="quote`).each()
    );
    assertThrown!OptLexException(
        splitter(`"--unclosed=quote`).each()
    );
    assertThrown!OptLexException(
        splitter(`-"-unclosed=quote`).each()
    );
    assert(
        splitter(`--unclosed "quote`)
        .equal([`--unclosed`, `"quote`])
    );
    assertThrown!OptLexException(
        splitter(`--unclosed "-quote`).each()
    );
    assert(
        splitter(`--unclosed -- "-quote`)
        .equal([`--unclosed`, `--`, `"-quote`])
    );
    assert(
        splitter(`''"`)
        .equal([`''"`])
    );
}
