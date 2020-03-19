module utils;

// A type with the single possible value.
enum Unit: ubyte { _ }

static if (__traits(compiles, { import std.array: staticArray; }))
    public import std.array: staticArray;
else {
    pragma(inline, true)
    T[n] staticArray(T, size_t n)(auto ref T[n] a) {
        return a;
    }
}

private template _singletonInstance(C, args...) {
    static immutable Object _singletonInstance;

    shared static this() @system {
        import std.conv: emplace;

        __gshared void[__traits(classInstanceSize, C)] buffer = void;
        _singletonInstance = emplace!C(buffer, args);
    }
}

pragma(inline, true)
@property I singletonInstance(I, C, args...)() nothrow pure @trusted @nogc
if (is(C == class) && is(C: I)) {
    return cast(I)_singletonInstance!(C, args);
}
