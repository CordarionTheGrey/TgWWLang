module linguist.cmds.concrete.validate;

import linguist.cmds.cmd;
import linguist.cmds.helpers: wraps;

private @safe:

public struct ValidateCmdParams {
    bool verbose;
    bool explicit;
}

final immutable class _Cmd: ICmd {
    mixin wraps!ValidateCmdParams;

    void execute() {
        // ...
    }
}

public immutable(ICmd) createCmd(immutable ValidateCmdParams p) nothrow pure {
    return new _Cmd(p);
}
