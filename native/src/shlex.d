module shlex;

import std.algorithm.comparison: among;
import std.array: Appender;
import std.range.primitives;
import std.utf: byCodeUnit;

pure @safe:

private bool _isSpace(char c) nothrow @nogc {
    return !!c.among!(' ', '\t');
}

private bool _isQuote(char c) nothrow @nogc {
    return !!c.among!('"', '\'');
}

// This parser does not treat backslash specially.
struct ShLexSplitter {
pure:
    private {
        Appender!(char[ ]) _app;
        typeof("".byCodeUnit()) _s;
        string _front;
    }

    invariant {
        assert(_app.data.empty, "Dirty buffer");
    }

    @property bool empty() const nothrow @trusted @nogc {
        return _front.ptr is null;
    }

    @property inout(ShLexSplitter) save() inout nothrow @nogc {
        return this; // The appender can be shared freely.
    }

    @property string front() const nothrow @nogc
    in {
        assert(!empty);
    }
    do {
        return _front;
    }

    private void _advance() {
        import std.algorithm.searching: find, skipOver;

        auto s = _s;
        s.skipOver!(c => _isSpace(c));
        if (s.empty) {
            _front = null;
            return;
        }
        auto delayed = s;
        auto app = _app;
        bool simple = true;
        do {
            const c = s.front;
            if (_isSpace(c))
                break;
            s.popFront();
            if (_isQuote(c)) {
                app ~= delayed[0 .. $ - s.length - 1];
                delayed = s.find(c);
                if (delayed.empty) {
                    app.clear();
                    throw new Exception("No closing quotation");
                }
                app ~= s[0 .. $ - delayed.length];
                delayed.popFront();
                s = delayed;
                simple = false;
            }
        } while (!s.empty);

        if (simple)
            _front = delayed[0 .. $ - s.length].source;
        else {
            app ~= delayed[0 .. $ - s.length];
            if (!app.data.empty) {
                _front = app.data.idup;
                app.clear();
            } else
                _front = ""; // Be careful not to assign `null` accidentally.
        }
        if (!s.empty)
            s.popFront();
        _s = s;
    }

    void popFront()
    in {
        assert(!empty);
    }
    do {
        _advance();
    }
}

static assert(isInputRange!ShLexSplitter);
static assert(isForwardRange!ShLexSplitter);

ShLexSplitter splitter(string s) {
    import std.array: appender;

    auto sp = ShLexSplitter(appender!(char[ ]), s.byCodeUnit());
    sp._advance();
    return sp;
}
