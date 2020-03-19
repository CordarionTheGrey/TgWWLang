module linguist.cmds.concrete.nop;

import linguist.cmds.cmd;
import linguist.user_request.data;
import utils: singletonInstance;

private @safe:

final immutable class _Cmd: ICmd {
    void execute(ref const UserRequest req) { }
}

public alias nopCmdInstance = singletonInstance!(ICmd, _Cmd);
