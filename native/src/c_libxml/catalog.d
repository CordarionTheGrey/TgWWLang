module c_libxml.catalog;

import c_libxml.tree;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/**
 * Summary: interfaces to the Catalog handling system
 * Description: the catalog module implements the support for
 * XML Catalogs and SGML catalogs
 *
 * SGML Open Technical Resolution TR9401:1997.
 * http://www.jclark.com/sp/catalog.htm
 *
 * XML Catalogs Working Draft 06 August 2001
 * http://www.oasis-open.org/committees/entity/spec-2001-08-06.html
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C):

/**
 * XML_CATALOGS_NAMESPACE:
 *
 * The namespace for the XML Catalogs elements.
 */
enum XML_CATALOGS_NAMESPACE = cast(const(xmlChar)*) "urn:oasis:names:tc:entity:xmlns:xml:catalog";
/**
 * XML_CATALOG_PI:
 *
 * The specific XML Catalog Processing Instruction name.
 */
enum XML_CATALOG_PI = cast(const(xmlChar)*) "oasis-xml-catalog";

/*
 * The API is voluntarily limited to general cataloging.
 */
enum xmlCatalogPrefer
{
    none = 0,
    public_ = 1,
    system = 2
}

enum xmlCatalogAllow
{
    none = 0,
    global = 1,
    document = 2,
    all = 3
}

struct _xmlCatalog;
alias xmlCatalog = _xmlCatalog;
alias xmlCatalogPtr = _xmlCatalog*;

/*
 * Operations on a given catalog.
 */
xmlCatalogPtr xmlNewCatalog(int sgml);
xmlCatalogPtr xmlLoadACatalog(const(char)* filename);
xmlCatalogPtr xmlLoadSGMLSuperCatalog(const(char)* filename);
int xmlConvertSGMLCatalog(xmlCatalogPtr catal);
int xmlACatalogAdd(
    xmlCatalogPtr catal,
    const(xmlChar)* type,
    const(xmlChar)* orig,
    const(xmlChar)* replace);
int xmlACatalogRemove(xmlCatalogPtr catal, const(xmlChar)* value);
xmlChar* xmlACatalogResolve(
    xmlCatalogPtr catal,
    const(xmlChar)* pubID,
    const(xmlChar)* sysID);
xmlChar* xmlACatalogResolveSystem(xmlCatalogPtr catal, const(xmlChar)* sysID);
xmlChar* xmlACatalogResolvePublic(xmlCatalogPtr catal, const(xmlChar)* pubID);
xmlChar* xmlACatalogResolveURI(xmlCatalogPtr catal, const(xmlChar)* URI);

/* LIBXML_OUTPUT_ENABLED */
void xmlFreeCatalog(xmlCatalogPtr catal);
int xmlCatalogIsEmpty(xmlCatalogPtr catal);

/*
 * Global operations.
 */
void xmlInitializeCatalog();
int xmlLoadCatalog(const(char)* filename);
void xmlLoadCatalogs(const(char)* paths);
void xmlCatalogCleanup();

/* LIBXML_OUTPUT_ENABLED */
xmlChar* xmlCatalogResolve(const(xmlChar)* pubID, const(xmlChar)* sysID);
xmlChar* xmlCatalogResolveSystem(const(xmlChar)* sysID);
xmlChar* xmlCatalogResolvePublic(const(xmlChar)* pubID);
xmlChar* xmlCatalogResolveURI(const(xmlChar)* URI);
int xmlCatalogAdd(
    const(xmlChar)* type,
    const(xmlChar)* orig,
    const(xmlChar)* replace);
int xmlCatalogRemove(const(xmlChar)* value);
xmlDocPtr xmlParseCatalogFile(const(char)* filename);
int xmlCatalogConvert();

/*
 * Strictly minimal interfaces for per-document catalogs used
 * by the parser.
 */
void xmlCatalogFreeLocal(void* catalogs);
void* xmlCatalogAddLocal(void* catalogs, const(xmlChar)* URL);
xmlChar* xmlCatalogLocalResolve(
    void* catalogs,
    const(xmlChar)* pubID,
    const(xmlChar)* sysID);
xmlChar* xmlCatalogLocalResolveURI(void* catalogs, const(xmlChar)* URI);
/*
 * Preference settings.
 */
int xmlCatalogSetDebug(int level);
xmlCatalogPrefer xmlCatalogSetDefaultPrefer(xmlCatalogPrefer prefer);
void xmlCatalogSetDefaults(xmlCatalogAllow allow);
xmlCatalogAllow xmlCatalogGetDefaults();

/* DEPRECATED interfaces */
const(xmlChar)* xmlCatalogGetSystem(const(xmlChar)* sysID);
const(xmlChar)* xmlCatalogGetPublic(const(xmlChar)* pubID);

/* LIBXML_CATALOG_ENABLED */
/* __XML_CATALOG_H__ */
