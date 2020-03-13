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

XMLDoc* parseFileAndReport(XMLParserCtxt* ctxt, const(char)* filename) {
    auto result = parseFile(ctxt, filename);
    foreach (e; result.errors)
        writef!"%s: %s [%s:%s]\n"(e.line, e.msg, e.domain, e.code);
    return result.doc;
}

int run(string schemaFilename, string docFilename) {
    schemaFilename ~= '\0';
    auto parser = createParser(); // Leaks.
    auto schema = parseFileAndReport(parser, schemaFilename.ptr); // Leaks.
    if (schema is null)
        return 1;
    auto validator = createValidator(schema); // Leaks.

    docFilename ~= '\0';
    auto doc = parseFileAndReport(parser, docFilename.ptr); // Leaks.
    if (doc is null)
        return 1;

    auto result = validateDoc(validator, doc);
    writef!"Validation: %s [%(\n  %s%)\n]\n"(result.code, result.errors);
    // traverse(schema.children);
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
