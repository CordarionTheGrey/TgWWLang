module langfiles.data;

import std.typecons: Tuple;

import utils;
import xmlwrap;

// One of the greatest troubles is that langfiles can contain two strings with the same key -
// one that is marked as deprecated and another that is not. And it's perfectly legal.
enum Deprecated: ubyte {
    false_ = 1, // To prevent unclear conversion to `bool` (what should `if (deprecated)` mean?).
    true_,
    both,
}

struct TLanguage {
    const(char)[ ] name, base, variant, owner;
    bool default_;
    XMLNode* node;
}

struct TValue {
    Unit[string] placeholders;
    XMLNode* node;
}

struct TString {
    string key;
    bool deprecated_;
    bool gif;
    TValue[ ] values;
    XMLNode* node;
}

struct TStrings {
    TLanguage parameters;
    TString*[ ] strings;
    TString*[Tuple!(string, bool)] stringsAA; // [(key, deprecated)]
    Deprecated[string] deprecatedSummary; // [key]
    XMLDoc* doc;
}
