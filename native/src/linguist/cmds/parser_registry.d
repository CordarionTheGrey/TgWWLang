module linguist.cmds.parser_registry;

import linguist.cmds.parser;

private @safe:

immutable ITextCmdParser[string] _registry;

shared static this() nothrow {
    import std.array: assocArray;
    import std.meta: AliasSeq, Stride;

    import linguist.cmds.parsers.validate;
    import utils: staticArray;

    alias registry = AliasSeq!(
        "validate", validateParserInstance,
    );
    auto names = [Stride!(2, registry)].staticArray();
    auto parsers = [Stride!(2, registry[1 .. $])].staticArray();
    _registry = (() @trusted => cast(immutable)assocArray(names[ ], parsers[ ]).rehash())();
}

public immutable(ITextCmdParser) getParser(const(char)[ ] cmdName) nothrow pure @nogc
out (parser) {
    assert(parser !is null);
}
do {
    import linguist.cmds.parsers.unknown;

    if (const p = cmdName in _registry)
        return *p;
    return unknownParserInstance;
}
