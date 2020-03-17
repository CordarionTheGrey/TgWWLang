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
    import std.algorithm.mutation: stripRight;
    import std.process: environment;
    import std.utf: byCodeUnit;

    import vibe.core.args: readOption;
    import vibe.core.core;
    import vibe.core.stream: IOMode;
    import vibe.http.client;

    version (DigitalMars) {
        import etc.linux.memoryerror;

        static if (__traits(compiles, &registerMemoryErrorHandler))
            registerMemoryErrorHandler();
    }

    testLibxmlVersion();
    string telegramURL = "https://api.telegram.org";
    if (readOption("telegram-url", &telegramURL, "URL to use instead of https://api.telegram.org."))
        telegramURL = telegramURL.byCodeUnit().stripRight('/').source;

    telegramURL ~= "/bot";
    telegramURL ~= environment["TG_WW_LINGUIST_BOT_TOKEN"];
    runTask({
        try {
            requestHTTP(telegramURL ~ "/getMe", (scope req) { }, (scope res) {
                ubyte[8192] buffer;
                while (res.bodyReader.dataAvailableForRead) {
                    write(cast(const(char)[ ])buffer[0 .. res.bodyReader.read(
                        buffer[0 .. res.bodyReader.leastSize],
                        IOMode.all,
                    )]);
                }
                writeln();
            });
            writeln("Task finished");
        } catch (Exception e)
            stderr.writeln(e);
    });
    return runApplication();
}
