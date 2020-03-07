module c_libxml.entities;

import c_libxml.tree;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/*
 * Summary: interface for the XML entities handling
 * Description: this module provides some of the entity API needed
 *              for the parser and applications.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C):

/*
 * The different valid entity types.
 */
enum xmlEntityType
{
    internalGeneralEntity = 1,
    externalGeneralParsedEntity = 2,
    externalGeneralUnparsedEntity = 3,
    internalParameterEntity = 4,
    externalParameterEntity = 5,
    internalPredefinedEntity = 6
}

/*
 * An unit of storage for an entity, contains the string, the value
 * and the linkind data needed for the linking in the hash table.
 */

struct _xmlEntity
{
    void* _private; /* application data */
    xmlElementType type; /* XML_ENTITY_DECL, must be second ! */
    const(xmlChar)* name; /* Entity name */
    _xmlNode* children; /* First child link */
    _xmlNode* last; /* Last child link */
    _xmlDtd* parent; /* -> DTD */
    _xmlNode* next; /* next sibling link  */
    _xmlNode* prev; /* previous sibling link  */
    _xmlDoc* doc; /* the containing document */

    xmlChar* orig; /* content without ref substitution */
    xmlChar* content; /* content or ndata if unparsed */
    int length; /* the content length */
    xmlEntityType etype; /* The entity type */
    const(xmlChar)* ExternalID; /* External identifier for PUBLIC */
    const(xmlChar)* SystemID; /* URI for a SYSTEM or PUBLIC Entity */

    _xmlEntity* nexte; /* unused */
    const(xmlChar)* URI; /* the full URI as computed */
    int owner; /* does the entity own the childrens */
    int checked; /* was the entity content checked */
    /* this is also used to count entities
                         * references done from that entity
                         * and if it contains '<' */
}

/*
 * All entities are stored in an hash table.
 * There is 2 separate hash tables for global and parameter entities.
 */

struct _xmlHashTable;
alias xmlEntitiesTable = _xmlHashTable;
alias xmlEntitiesTablePtr = _xmlHashTable*;

/*
 * External functions:
 */

/* LIBXML_LEGACY_ENABLED */

xmlEntityPtr xmlNewEntity(
    xmlDocPtr doc,
    const(xmlChar)* name,
    int type,
    const(xmlChar)* ExternalID,
    const(xmlChar)* SystemID,
    const(xmlChar)* content);
xmlEntityPtr xmlAddDocEntity(
    xmlDocPtr doc,
    const(xmlChar)* name,
    int type,
    const(xmlChar)* ExternalID,
    const(xmlChar)* SystemID,
    const(xmlChar)* content);
xmlEntityPtr xmlAddDtdEntity(
    xmlDocPtr doc,
    const(xmlChar)* name,
    int type,
    const(xmlChar)* ExternalID,
    const(xmlChar)* SystemID,
    const(xmlChar)* content);
xmlEntityPtr xmlGetPredefinedEntity(const(xmlChar)* name);
xmlEntityPtr xmlGetDocEntity(const(xmlDoc)* doc, const(xmlChar)* name);
xmlEntityPtr xmlGetDtdEntity(xmlDocPtr doc, const(xmlChar)* name);
xmlEntityPtr xmlGetParameterEntity(xmlDocPtr doc, const(xmlChar)* name);

/* LIBXML_LEGACY_ENABLED */
xmlChar* xmlEncodeEntitiesReentrant(xmlDocPtr doc, const(xmlChar)* input);
xmlChar* xmlEncodeSpecialChars(const(xmlDoc)* doc, const(xmlChar)* input);
xmlEntitiesTablePtr xmlCreateEntitiesTable();
xmlEntitiesTablePtr xmlCopyEntitiesTable(xmlEntitiesTablePtr table);
/* LIBXML_TREE_ENABLED */
void xmlFreeEntitiesTable(xmlEntitiesTablePtr table);

/* LIBXML_OUTPUT_ENABLED */

/* LIBXML_LEGACY_ENABLED */

/* __XML_ENTITIES_H__ */
