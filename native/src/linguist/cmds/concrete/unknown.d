module linguist.cmds.concrete.unknown;

import linguist.cmds.cmd;
import utils: singletonInstance;

private @safe:

final immutable class _Cmd: ICmd {
    void execute() {
        // ...
    }
}

public alias unknownCmdInstance = singletonInstance!(ICmd, _Cmd);
