import std.stdio;

import langfiles.deserializer;
import xmlwrap;

private @system:

void _process(ref Deserializer ds, XMLDoc* doc) {
    import langfiles.data;
    import langfiles.diagnostics;

    auto dc = createDiagnosticsCollector();
    TStrings root;
    ds.deserialize(FileID.target, doc, root, dc);
    writeln(root.parameters);
    foreach (str; root.strings)
        writeln(*str);
    writeln(dc);
}

int _run(string schemaFilename, string docFilename) {
    schemaFilename ~= '\0';
    docFilename ~= '\0';
    auto loader = createLoader();
    XMLDoc* doc;
    try {
        loader.loadSchema(schemaFilename.ptr);
        doc = loader.loadDoc(docFilename.ptr);
    } catch (XMLException exc) {
        foreach (e; exc.errors)
            writef!"%s: %s [%s:%s]\n"(e.line, e.msg, e.domain, e.code);
        return 1;
    }
    auto ds = createDeserializer();
    _process(ds, doc);
    destroyDoc(doc);
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
    return _run(args[1], args[2]);
}
