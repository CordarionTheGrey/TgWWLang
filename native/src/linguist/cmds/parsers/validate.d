module linguist.cmds.parsers.validate;

import linguist.cmds.concrete.validate;
import linguist.cmds.parser;
import utils: singleton;

@safe:

final immutable class ValidateParser: ITextCmdParser {
    mixin singleton;

    ParseResult parse(string[ ] args) {
        ValidateCmdParams p = { explicit: true };
        return ParseResult(_getopt(args,
            "v|verbose", "Produce more detailed output.", &p.verbose,
        ), p.createCmd());
    }
}
