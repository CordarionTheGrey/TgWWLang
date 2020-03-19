module linguist.cmds.cmd;

import linguist.user_request;

@safe:

immutable interface ICmd {
    void execute(ref const UserRequest);
}
