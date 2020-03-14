module c_libxml.xmlstring;

import c_libxml.xmlversion;

/*
 * Summary: set of routines to process strings
 * Description: type and interfaces needed for the internal string handling
 *              of the library, especially UTF8 processing.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

import core.stdc.stdarg;

extern (C) nothrow @system:

/**
 * xmlChar:
 *
 * This is a basic byte in an UTF-8 encoded string.
 * It's unsigned allowing to pinpoint case where char * are assigned
 * to xmlChar * (possibly making serialization back impossible).
 */
alias xmlChar = char;

/**
 * BAD_CAST:
 *
 * Macro to cast a string to an xmlChar * when one know its safe.
 */

/*
 * xmlChar handling
 */
xmlChar* xmlStrdup(const(xmlChar)* cur);
xmlChar* xmlStrndup(const(xmlChar)* cur, int len);
xmlChar* xmlCharStrndup(const(char)* cur, int len);
xmlChar* xmlCharStrdup(const(char)* cur);
xmlChar* xmlStrsub(const(xmlChar)* str, int start, int len);
const(xmlChar)* xmlStrchr(const(xmlChar)* str, xmlChar val);
const(xmlChar)* xmlStrstr(const(xmlChar)* str, const(xmlChar)* val);
const(xmlChar)* xmlStrcasestr(const(xmlChar)* str, const(xmlChar)* val);
int xmlStrcmp(const(xmlChar)* str1, const(xmlChar)* str2);
int xmlStrncmp(const(xmlChar)* str1, const(xmlChar)* str2, int len);
int xmlStrcasecmp(const(xmlChar)* str1, const(xmlChar)* str2);
int xmlStrncasecmp(const(xmlChar)* str1, const(xmlChar)* str2, int len);
int xmlStrEqual(const(xmlChar)* str1, const(xmlChar)* str2);
int xmlStrQEqual(
    const(xmlChar)* pref,
    const(xmlChar)* name,
    const(xmlChar)* str);
int xmlStrlen(const(xmlChar)* str);
xmlChar* xmlStrcat(xmlChar* cur, const(xmlChar)* add);
xmlChar* xmlStrncat(xmlChar* cur, const(xmlChar)* add, int len);
xmlChar* xmlStrncatNew(const(xmlChar)* str1, const(xmlChar)* str2, int len);
int xmlStrPrintf(xmlChar* buf, int len, const(char)* msg, ...);
int xmlStrVPrintf(xmlChar* buf, int len, const(char)* msg, va_list ap);

int xmlGetUTF8Char(const(ubyte)* utf, int* len);
int xmlCheckUTF8(const(ubyte)* utf);
int xmlUTF8Strsize(const(xmlChar)* utf, int len);
xmlChar* xmlUTF8Strndup(const(xmlChar)* utf, int len);
const(xmlChar)* xmlUTF8Strpos(const(xmlChar)* utf, int pos);
int xmlUTF8Strloc(const(xmlChar)* utf, const(xmlChar)* utfchar);
xmlChar* xmlUTF8Strsub(const(xmlChar)* utf, int start, int len);
int xmlUTF8Strlen(const(xmlChar)* utf);
int xmlUTF8Size(const(xmlChar)* utf);
int xmlUTF8Charcmp(const(xmlChar)* utf1, const(xmlChar)* utf2);

/* __XML_STRING_H__ */
