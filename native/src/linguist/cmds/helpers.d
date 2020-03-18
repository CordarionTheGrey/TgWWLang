module linguist.cmds.helpers;

template wraps(T) {
    private T _data;

    alias _data this;

    this(inout T data) inout nothrow pure @safe @nogc {
        _data = data;
    }
}
