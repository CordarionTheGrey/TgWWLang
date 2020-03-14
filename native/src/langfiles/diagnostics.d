module langfiles.diagnostics;

import std.array: Appender;

nothrow pure @safe:

enum FileID: ubyte {
    none = 0,
    model = 1,
    base = 2,
    target = 3,
}

enum DiagnosticCode: ubyte {
    // We can add, remove, and rename constants here, but must not change assigned numbers.
    // 1-digit codes (frequently used):
    missingString = 0,
    unknownKey = 1,
    missingPlaceholder = 2,
    extraPlaceholder = 3,
    addedString = 4,
    // 2-digit codes (rarely used):
    notFound = 10,
    notDefault = 11,
    closed = 12,
    emptyLanguageAttribute = 13,
    multipleDefinitions = 14,
    emptyValue = 15,
    noValues = 16,
    sameLanguageName = 17,
    sameLanguageBaseVariant = 18,
    inconsistentPlaceholders = 19,
    invalidAttribute = 20,
}

struct DiagnosticMessage {
    DiagnosticCode code;
    int line;
    immutable(string)[ ] details;
}

struct DiagnosticsCollector {
    Appender!(DiagnosticMessage[ ])[4] messages;
}

DiagnosticsCollector createDiagnosticsCollector() {
    import std.array: appender;

    DiagnosticsCollector dc;
    static foreach (i; 0 .. 4)
        dc.messages[i] = appender!(DiagnosticMessage[ ]);
    return dc;
}
