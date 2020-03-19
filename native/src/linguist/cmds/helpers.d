module linguist.cmds.helpers;

template wraps(T) {
    private T _data;

    alias _data this;

    this(immutable T data) immutable nothrow pure @safe @nogc {
        _data = data;
    }
}
