module linguist.user_request.dispatcher;

import std.getopt: GetoptResult;

import linguist.cmds.cmd;
import linguist.cmds.parser;
import linguist.user_request.data;

private nothrow @safe:

immutable(ICmd) _createManCmd(
    immutable ITextCmdParser parser, immutable GetoptResult info, string error,
) pure {
    import std.typecons: rebindable;
    import linguist.cmds.concrete.man;

    return (immutable ManCmdParams(rebindable(parser), info, error)).createCmd();
}

public immutable(ICmd) dispatch(ref UserRequest req)
out (cmd) {
    assert(cmd !is null);
}
do {
    import std.range.primitives;

    import linguist.cmds.concrete.nop;
    import linguist.cmds.parser_registry;

    if (!req.textMessage.cmd.empty) {
        const parser = getParser(req.textMessage.cmd[0]);
        try {
            const parseResult = parser.parse(req.textMessage.cmd);
            return parseResult[0].helpWanted ? (
                _createManCmd(parser, (() @trusted => cast(immutable)parseResult[0])(), null)
            ) : parseResult[1];
        } catch (Exception e)
            return _createManCmd(parser, (() @trusted => cast(immutable)parser.getHelp())(), e.msg);
    }
    // TODO: Validate `.xml` documents automatically.
    return nopCmdInstance;
}
