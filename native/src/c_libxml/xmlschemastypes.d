module c_libxml.xmlschemastypes;

import c_libxml.schemasInternals;
import c_libxml.tree;
import c_libxml.xmlschemas;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/*
 * Summary: implementation of XML Schema Datatypes
 * Description: module providing the XML Schema Datatypes implementation
 *              both definition and validity checking
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

import core.stdc.config;

extern (C) nothrow @system:

enum xmlSchemaWhitespaceValueType
{
    unknown = 0,
    preserve = 1,
    replace = 2,
    collapse = 3
}

void xmlSchemaInitTypes();
void xmlSchemaCleanupTypes();
xmlSchemaTypePtr xmlSchemaGetPredefinedType(
    const(xmlChar)* name,
    const(xmlChar)* ns);
int xmlSchemaValidatePredefinedType(
    xmlSchemaTypePtr type,
    const(xmlChar)* value,
    xmlSchemaValPtr* val);
int xmlSchemaValPredefTypeNode(
    xmlSchemaTypePtr type,
    const(xmlChar)* value,
    xmlSchemaValPtr* val,
    xmlNodePtr node);
int xmlSchemaValidateFacet(
    xmlSchemaTypePtr base,
    xmlSchemaFacetPtr facet,
    const(xmlChar)* value,
    xmlSchemaValPtr val);
int xmlSchemaValidateFacetWhtsp(
    xmlSchemaFacetPtr facet,
    xmlSchemaWhitespaceValueType fws,
    xmlSchemaValType valType,
    const(xmlChar)* value,
    xmlSchemaValPtr val,
    xmlSchemaWhitespaceValueType ws);
void xmlSchemaFreeValue(xmlSchemaValPtr val);
xmlSchemaFacetPtr xmlSchemaNewFacet();
int xmlSchemaCheckFacet(
    xmlSchemaFacetPtr facet,
    xmlSchemaTypePtr typeDecl,
    xmlSchemaParserCtxtPtr ctxt,
    const(xmlChar)* name);
void xmlSchemaFreeFacet(xmlSchemaFacetPtr facet);
int xmlSchemaCompareValues(xmlSchemaValPtr x, xmlSchemaValPtr y);
xmlSchemaTypePtr xmlSchemaGetBuiltInListSimpleTypeItemType(
    xmlSchemaTypePtr type);
int xmlSchemaValidateListSimpleTypeFacet(
    xmlSchemaFacetPtr facet,
    const(xmlChar)* value,
    c_ulong actualLen,
    c_ulong* expectedLen);
xmlSchemaTypePtr xmlSchemaGetBuiltInType(xmlSchemaValType type);
int xmlSchemaIsBuiltInTypeFacet(xmlSchemaTypePtr type, int facetType);
xmlChar* xmlSchemaCollapseString(const(xmlChar)* value);
xmlChar* xmlSchemaWhiteSpaceReplace(const(xmlChar)* value);
c_ulong xmlSchemaGetFacetValueAsULong(xmlSchemaFacetPtr facet);
int xmlSchemaValidateLengthFacet(
    xmlSchemaTypePtr type,
    xmlSchemaFacetPtr facet,
    const(xmlChar)* value,
    xmlSchemaValPtr val,
    c_ulong* length);
int xmlSchemaValidateLengthFacetWhtsp(
    xmlSchemaFacetPtr facet,
    xmlSchemaValType valType,
    const(xmlChar)* value,
    xmlSchemaValPtr val,
    c_ulong* length,
    xmlSchemaWhitespaceValueType ws);
int xmlSchemaValPredefTypeNodeNoNorm(
    xmlSchemaTypePtr type,
    const(xmlChar)* value,
    xmlSchemaValPtr* val,
    xmlNodePtr node);
int xmlSchemaGetCanonValue(xmlSchemaValPtr val, const(xmlChar*)* retValue);
int xmlSchemaGetCanonValueWhtsp(
    xmlSchemaValPtr val,
    const(xmlChar*)* retValue,
    xmlSchemaWhitespaceValueType ws);
int xmlSchemaValueAppend(xmlSchemaValPtr prev, xmlSchemaValPtr cur);
xmlSchemaValPtr xmlSchemaValueGetNext(xmlSchemaValPtr cur);
const(xmlChar)* xmlSchemaValueGetAsString(xmlSchemaValPtr val);
int xmlSchemaValueGetAsBoolean(xmlSchemaValPtr val);
xmlSchemaValPtr xmlSchemaNewStringValue(
    xmlSchemaValType type,
    const(xmlChar)* value);
xmlSchemaValPtr xmlSchemaNewNOTATIONValue(
    const(xmlChar)* name,
    const(xmlChar)* ns);
xmlSchemaValPtr xmlSchemaNewQNameValue(
    const(xmlChar)* namespaceName,
    const(xmlChar)* localName);
int xmlSchemaCompareValuesWhtsp(
    xmlSchemaValPtr x,
    xmlSchemaWhitespaceValueType xws,
    xmlSchemaValPtr y,
    xmlSchemaWhitespaceValueType yws);
xmlSchemaValPtr xmlSchemaCopyValue(xmlSchemaValPtr val);
xmlSchemaValType xmlSchemaGetValType(xmlSchemaValPtr val);

/* LIBXML_SCHEMAS_ENABLED */
/* __XML_SCHEMA_TYPES_H__ */
