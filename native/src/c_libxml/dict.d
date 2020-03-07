module c_libxml.dict;

import c_libxml.xmlstring;
import c_libxml.xmlversion;

/*
 * Summary: string dictionary
 * Description: dictionary of reusable strings, just used to avoid allocation
 *         and freeing operations.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C):

/*
 * The dictionary.
 */
struct _xmlDict;
alias xmlDict = _xmlDict;
alias xmlDictPtr = _xmlDict*;

/*
 * Initializer
 */
int xmlInitializeDict();

/*
 * Constructor and destructor.
 */
xmlDictPtr xmlDictCreate();
size_t xmlDictSetLimit(xmlDictPtr dict, size_t limit);
size_t xmlDictGetUsage(xmlDictPtr dict);
xmlDictPtr xmlDictCreateSub(xmlDictPtr sub);
int xmlDictReference(xmlDictPtr dict);
void xmlDictFree(xmlDictPtr dict);

/*
 * Lookup of entry in the dictionary.
 */
const(xmlChar)* xmlDictLookup(xmlDictPtr dict, const(xmlChar)* name, int len);
const(xmlChar)* xmlDictExists(xmlDictPtr dict, const(xmlChar)* name, int len);
const(xmlChar)* xmlDictQLookup(
    xmlDictPtr dict,
    const(xmlChar)* prefix,
    const(xmlChar)* name);
int xmlDictOwns(xmlDictPtr dict, const(xmlChar)* str);
int xmlDictSize(xmlDictPtr dict);

/*
 * Cleanup function
 */
void xmlDictCleanup();

/* ! __XML_DICT_H__ */
