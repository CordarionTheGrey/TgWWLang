module linguist.cmds.parsers.validate;

import linguist.cmds.parser;
import utils: singletonInstance;

private @safe:

final immutable class _Parser: ITextCmdParser {
    ParseResult parse(ref string[ ] args) {
        import linguist.cmds.concrete.validate;

        ValidateCmdParams p = { explicit: true };
        return ParseResult(_getopt(args,
            "v|verbose", "Produce more detailed output.", &p.verbose,
        ), p.createCmd());
    }
}

public alias validateParserInstance = singletonInstance!(ITextCmdParser, _Parser);
