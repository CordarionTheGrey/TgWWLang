module linguist.cmds.concrete.man;

import std.getopt: GetoptResult;
import std.typecons: Rebindable;

import linguist.cmds.cmd;
import linguist.cmds.helpers: wraps;
import linguist.cmds.parser;
import linguist.user_request.data;

private @safe:

public struct ManCmdParams {
    Rebindable!(immutable ITextCmdParser) parser;
    GetoptResult info;
    string error;
}

final immutable class _Cmd: ICmd {
    mixin wraps!ManCmdParams;

    void execute(ref const UserRequest req) {
        // TODO: Implement `man` command.
    }
}

public immutable(ICmd) createCmd(immutable ManCmdParams p) nothrow pure {
    return new immutable _Cmd(p);
}
