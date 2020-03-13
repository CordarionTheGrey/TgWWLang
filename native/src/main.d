import std.stdio;
import std.string: fromStringz;

import xmlwrap;

void traverse(const(XMLNode)* node) {
    for (; node !is null; node = node.next) {
        if (node.type == XMLElementType.elementNode)
            writef!"<%s>:%s\n"(node.name.fromStringz(), node.line);
        traverse(node.children);
    }
}

int run(string schemaFilename, string docFilename) {
    schemaFilename ~= '\0';
    docFilename ~= '\0';
    auto loader = createLoader();
    try {
        loader.loadSchema(schemaFilename.ptr);
        auto doc = loader.loadDoc(docFilename.ptr); // Leaks.
        // traverse(doc.children);
    } catch (XMLException exc) {
        foreach (e; exc.errors)
            writef!"%s: %s [%s:%s]\n"(e.line, e.msg, e.domain, e.code);
        return 1;
    }
    return 0;
}

int main(string[ ] args) {
    version (DigitalMars) {
        import etc.linux.memoryerror;

        static if (__traits(compiles, &registerMemoryErrorHandler))
            registerMemoryErrorHandler();
    }

    testLibxmlVersion();
    if (args.length != 3) {
        stderr.writef!"Usage:\n  %s <schema> <filename>\n"(args[0]);
        return 2;
    }
    return run(args[1], args[2]);
}
