module linguist.cmds.concrete.unknown;

import linguist.cmds.cmd;
import linguist.user_request.data;
import utils: singletonInstance;

private @safe:

final immutable class _Cmd: ICmd {
    void execute(ref const UserRequest req) {
        // TODO: Implement `unknown` command.
    }
}

public alias unknownCmdInstance = singletonInstance!(ICmd, _Cmd);
