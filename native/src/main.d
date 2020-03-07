import std.stdio;
import std.string: fromStringz;

import c_libxml.tree: xmlNode;

void traverse(const(xmlNode)* node) {
    import c_libxml.tree: xmlElementType;

    for (; node !is null; node = node.next) {
        if (node.type == xmlElementType.elementNode)
            writef!"<%s>:%s\n"(node.name.fromStringz(), node.line);
        traverse(node.children);
    }
}

int main(string[ ] args) {
    import c_libxml.parser: xmlReadFile;
    import c_libxml.tree: xmlFreeDoc;
    import c_libxml.xmlversion;

    xmlCheckVersion(LIBXML_VERSION);
    if (args.length != 2) {
        stderr.writef!"Usage:\n  %s <filename>\n"(args[0]);
        return 2;
    }
    args[1] ~= '\0';
    auto doc = xmlReadFile(args[1].ptr, null, 0);
    if (doc is null)
        return 1;
    scope(exit) xmlFreeDoc(doc);
    traverse(doc.children);
    return 0;
}
