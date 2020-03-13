module xmlwrap;

import std.array: Appender, appender;
import std.range.primitives;
import std.typecons: Tuple;

import std.exception: assumeWontThrow;
import std.stdio;

import c_libxml.parser;
import c_libxml.tree;
import c_libxml.xmlerror;
import c_libxml.xmlschemas;

nothrow:

alias XMLParserCtxt = xmlParserCtxt;
alias XMLErrorDomain = xmlErrorDomain;
alias XMLErrorCode = xmlParserErrors;
alias XMLDoc = xmlDoc;
alias XMLElementType = xmlElementType;
alias XMLNode = xmlNode;
alias XMLSchemaValidCtxt = xmlSchemaValidCtxt;

struct XMLError {
    XMLErrorDomain domain;
    XMLErrorCode code;
    int line;
    string msg;
}

void testLibxmlVersion() {
    import c_libxml.xmlversion;

    xmlCheckVersion(LIBXML_VERSION);
}

private void _appendError(Appender!(XMLError[ ]) app, xmlError* e) {
    import std.string: chomp, fromStringz;

    XMLError our = {
        domain: cast(XMLErrorDomain)e.domain,
        code: cast(XMLErrorCode)e.code,
        line: e.line,
        msg: e.message.fromStringz().chomp().idup,
    };
    app ~= our;
}

XMLParserCtxt* createParser() {
    extern (C)
    void dupError(void* ctxt, xmlError* e) {
        auto app = (cast(XMLParserCtxt*)ctxt)._private;
        assert(app !is null, "ctxt._private is null");
        _appendError(*cast(Appender!(XMLError[ ])*)app, e);
    }

    auto ctxt = xmlNewParserCtxt();
    xmlSetStructuredErrorFunc(ctxt, &dupError);
    return ctxt;
}

alias destroyParser = xmlFreeParserCtxt;

Tuple!(XMLDoc*, q{doc}, XMLError[ ], q{errors}) parseFile(
    XMLParserCtxt* ctxt, const(char)* filename,
) {
    auto errors = appender!(XMLError[ ]);
    ctxt._private = &errors;
    auto doc = xmlCtxtReadFile(ctxt, filename, null, 0x0);
    ctxt._private = null; // Allow it to be garbage-collected.
    return typeof(return)(doc, errors.data);
}

alias destroyDoc = xmlFreeDoc;

XMLSchemaValidCtxt* createValidator(XMLDoc* doc) {
    auto parserCtxt = xmlSchemaNewDocParserCtxt(doc);
    auto schema = xmlSchemaParse(parserCtxt); // Leaks.
    xmlSchemaFreeParserCtxt(parserCtxt);
    return xmlSchemaNewValidCtxt(schema);
}

// DMD hangs if you make this struct a tuple.
struct XMLValidationResult {
    XMLErrorCode code;
    XMLError[ ] errors;
}

XMLValidationResult validateDoc(XMLSchemaValidCtxt* ctxt, XMLDoc* doc) {
    extern (C)
    void dupError(void* ctxt, xmlError* e)
    in {
        assert(ctxt !is null, "ctxt is null");
    }
    do {
        _appendError(*cast(Appender!(XMLError[ ])*)ctxt, e);
    }

    auto errors = appender!(XMLError[ ]);
    xmlSchemaSetValidStructuredErrors(ctxt, &dupError, &errors);
    const code = xmlSchemaValidateDoc(ctxt, doc);
    xmlSchemaSetValidStructuredErrors(ctxt, &dupError, null); // Allow it to be garbage-collected.
    return XMLValidationResult(cast(XMLErrorCode)code, errors.data);
}

class XMLException: Exception {
    XMLError[ ] errors;

    this(string msg, inout(XMLError)[ ] errors) inout nothrow pure @safe @nogc {
        super(msg);
        this.errors = errors;
    }
}

struct XMLLoader {
private:
    XMLParserCtxt* _parser;
    XMLSchemaValidCtxt* _validator;

    XMLDoc* _loadDoc(const(char)* filename) {
        auto result = parseFile(_parser, filename);
        if (!result.errors.empty)
            throw new XMLException("Syntax error", result.errors);
        return result.doc;
    }

    public void loadSchema(const(char)* filename) {
        _validator = createValidator(_loadDoc(filename)); // Both leak.
    }

    public XMLDoc* loadDoc(const(char)* filename) {
        auto doc = _loadDoc(filename);
        // Validate after parsing so that syntax errors do not get mixed with validation errors.
        // TODO: Is that really important?
        auto errors = validateDoc(_validator, doc).errors;
        if (!errors.empty)
            throw new XMLException("Validation error", errors);
        return doc;
    }
}

XMLLoader createLoader() {
    return XMLLoader(createParser()); // Leaks.
}