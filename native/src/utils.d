module utils;

// A type with the single possible value.
enum Unit: ubyte { _ }

template singleton() {
    private this() immutable nothrow pure @safe @nogc { }

    shared static immutable typeof(this) instance;

    shared static this() nothrow @system @nogc {
        import std.conv: emplace;

        __gshared void[__traits(classInstanceSize, typeof(this))] buffer;
        instance = emplace!(typeof(this))(buffer);
    }
}
