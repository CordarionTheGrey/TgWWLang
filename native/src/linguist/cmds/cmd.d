module linguist.cmds.cmd;

import linguist.user_request.data;

@safe:

immutable interface ICmd {
    void execute(ref const UserRequest);
}
