module linguist.cmds.cmd;

@safe:

immutable interface ICmd {
    // TODO: Add required arguments.
    void execute();
}
