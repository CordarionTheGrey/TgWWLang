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

    // The first element of the passed array is meaningless and should not be examined. It exists
    // merely for easier interaction with `getopt`.
    // The rest of the elements are zero or more options and exactly one positional argument.
    // An implementation is allowed to modify the passed array in any way it wants. The caller
    // should not expect it to be left in any particular state.
    ParseResult parse(string[ ] args)
    in { assert(args.length >= 2); }
}

GetoptResult getHelp(immutable ITextCmdParser p) {
    string[3] args = ["", "-h", ""];
    return p.parse(args)[0];
}
