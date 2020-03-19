module linguist.cmds.parser;

import std.getopt: GetoptResult;
import std.typecons: Tuple;

import linguist.cmds.cmd;

@safe:

immutable interface ITextCmdParser {
    alias ParseResult = Tuple!(GetoptResult, immutable ICmd);

    protected static GetoptResult _getopt(Opts...)(ref string[ ] args, Opts opts) {
        import std.getopt;

        return getopt(args, config.caseSensitive, config.bundling, opts);
    }

    // The first element of the passed array is meaningless and should not be examined nor modified.
    // It exists merely for easier interaction with `getopt`.
    // The rest of the elements are zero or more options and exactly one positional argument. An
    // implementation must remove all options and leave the positional argument at index 1.
    ParseResult parse(ref string[ ] args)
    in  { assert(args.length >= 2); }
    out { assert(args.length == 2); }
    out (pair) {
        assert(pair[1] !is null);
    }
}

GetoptResult getHelp(immutable ITextCmdParser p)
in { assert(p !is null); }
do {
    string[3] data = ["", "-h", ""];
    auto args = data[ ];
    return p.parse(args)[0];
}
