module linguist.cmds.parsers.unknown;

import linguist.cmds.parser;
import utils: singletonInstance;

private @safe:

final immutable class _Parser: ITextCmdParser {
    ParseResult parse(ref string[ ] args) nothrow pure @nogc {
        import std.getopt: GetoptResult;
        import linguist.cmds.concrete.unknown;

        args[1] = args[$ - 1];
        args = args[0 .. 2];
        return ParseResult(GetoptResult.init, unknownCmdInstance);
    }
}

public alias unknownParserInstance = singletonInstance!(ITextCmdParser, _Parser);
