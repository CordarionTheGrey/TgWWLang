module c_libxml.uri;

import c_libxml.tree;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/**
 * Summary: library of generic URI related routines
 * Description: library of generic URI related routines
 *              Implements RFC 2396
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

import core.stdc.stdio;

extern (C):

/**
 * xmlURI:
 *
 * A parsed URI reference. This is a struct containing the various fields
 * as described in RFC 2396 but separated for further processing.
 *
 * Note: query is a deprecated field which is incorrectly unescaped.
 * query_raw takes precedence over query if the former is set.
 * See: http://mail.gnome.org/archives/xml/2007-April/thread.html#00127
 */
alias xmlURI = _xmlURI;
alias xmlURIPtr = _xmlURI*;

struct _xmlURI
{
    char* scheme; /* the URI scheme */
    char* opaque; /* opaque part */
    char* authority; /* the authority part */
    char* server; /* the server part */
    char* user; /* the user part */
    int port; /* the port number */
    char* path; /* the path string */
    char* query; /* the query string (deprecated - use with caution) */
    char* fragment; /* the fragment identifier */
    int cleanup; /* parsing potentially unclean URI */
    char* query_raw; /* the query string (as it appears in the URI) */
}

/*
 * This function is in tree.h:
 * xmlChar *    xmlNodeGetBase  (xmlDocPtr doc,
 *                               xmlNodePtr cur);
 */
xmlURIPtr xmlCreateURI();
xmlChar* xmlBuildURI(const(xmlChar)* URI, const(xmlChar)* base);
xmlChar* xmlBuildRelativeURI(const(xmlChar)* URI, const(xmlChar)* base);
xmlURIPtr xmlParseURI(const(char)* str);
xmlURIPtr xmlParseURIRaw(const(char)* str, int raw);
int xmlParseURIReference(xmlURIPtr uri, const(char)* str);
xmlChar* xmlSaveUri(xmlURIPtr uri);
void xmlPrintURI(FILE* stream, xmlURIPtr uri);
xmlChar* xmlURIEscapeStr(const(xmlChar)* str, const(xmlChar)* list);
char* xmlURIUnescapeString(const(char)* str, int len, char* target);
int xmlNormalizeURIPath(char* path);
xmlChar* xmlURIEscape(const(xmlChar)* str);
void xmlFreeURI(xmlURIPtr uri);
xmlChar* xmlCanonicPath(const(xmlChar)* path);
xmlChar* xmlPathToURI(const(xmlChar)* path);

/* __XML_URI_H__ */
