module c_libxml.xmlschemas;

import c_libxml.encoding;
import c_libxml.tree;
import c_libxml.xmlerror;
import c_libxml.xmlversion;

/*
 * Summary: incomplete XML Schemas structure implementation
 * Description: interface to the XML Schemas handling and schema validity
 *              checking, it is incomplete right now.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

import core.stdc.config;

extern (C) nothrow @system:

/**
 * This error codes are obsolete; not used any more.
 */
enum xmlSchemaValidError
{
    ok = 0,
    noroot = 1,
    undeclaredelem = 2,
    nottoplevel = 3,
    missing = 4,
    wrongelem = 5,
    notype = 6,
    norollback = 7,
    isabstract = 8,
    notempty = 9,
    elemcont = 10,
    havedefault = 11,
    notnillable = 12,
    extracontent = 13,
    invalidattr = 14,
    invalidelem = 15,
    notdeterminist = 16,
    construct = 17,
    internal = 18,
    notsimple = 19,
    attrunknown = 20,
    attrinvalid = 21,
    value = 22,
    facet = 23,
    xxx = 25
}

/*
* ATTENTION: Change xmlSchemaSetValidOptions's check
* for invalid values, if adding to the validation
* options below.
*/
/**
 * xmlSchemaValidOption:
 *
 * This is the set of XML Schema validation options.
 */
enum xmlSchemaValidOption
{
    vcICreate = 1 << 0
    /* Default/fixed: create an attribute node
        * or an element's text node on the instance.
        */
}

/*
    XML_SCHEMA_VAL_XSI_ASSEMBLE                 = 1<<1,
    * assemble schemata using
    * xsi:schemaLocation and
    * xsi:noNamespaceSchemaLocation
*/

/**
 * The schemas related types are kept internal
 */
struct _xmlSchema;
alias xmlSchema = _xmlSchema;
alias xmlSchemaPtr = _xmlSchema*;

/**
 * xmlSchemaValidityErrorFunc:
 * @ctx: the validation context
 * @msg: the message
 * @...: extra arguments
 *
 * Signature of an error callback from an XSD validation
 */
alias xmlSchemaValidityErrorFunc = void function(
    void* ctx,
    const(char)* msg,
    ...);

/**
 * xmlSchemaValidityWarningFunc:
 * @ctx: the validation context
 * @msg: the message
 * @...: extra arguments
 *
 * Signature of a warning callback from an XSD validation
 */
alias xmlSchemaValidityWarningFunc = void function(
    void* ctx,
    const(char)* msg,
    ...);

/**
 * A schemas validation context
 */
struct _xmlSchemaParserCtxt;
alias xmlSchemaParserCtxt = _xmlSchemaParserCtxt;
alias xmlSchemaParserCtxtPtr = _xmlSchemaParserCtxt*;

struct _xmlSchemaValidCtxt;
alias xmlSchemaValidCtxt = _xmlSchemaValidCtxt;
alias xmlSchemaValidCtxtPtr = _xmlSchemaValidCtxt*;

/**
 * xmlSchemaValidityLocatorFunc:
 * @ctx: user provided context
 * @file: returned file information
 * @line: returned line information
 *
 * A schemas validation locator, a callback called by the validator.
 * This is used when file or node informations are not available
 * to find out what file and line number are affected
 *
 * Returns: 0 in case of success and -1 in case of error
 */

alias xmlSchemaValidityLocatorFunc = int function(
    void* ctx,
    const(char*)* file,
    c_ulong* line);

/*
 * Interfaces for parsing.
 */
xmlSchemaParserCtxtPtr xmlSchemaNewParserCtxt(const(char)* URL);
xmlSchemaParserCtxtPtr xmlSchemaNewMemParserCtxt(const(char)* buffer, int size);
xmlSchemaParserCtxtPtr xmlSchemaNewDocParserCtxt(xmlDocPtr doc);
void xmlSchemaFreeParserCtxt(xmlSchemaParserCtxtPtr ctxt);
void xmlSchemaSetParserErrors(
    xmlSchemaParserCtxtPtr ctxt,
    xmlSchemaValidityErrorFunc err,
    xmlSchemaValidityWarningFunc warn,
    void* ctx);
void xmlSchemaSetParserStructuredErrors(
    xmlSchemaParserCtxtPtr ctxt,
    xmlStructuredErrorFunc serror,
    void* ctx);
int xmlSchemaGetParserErrors(
    xmlSchemaParserCtxtPtr ctxt,
    xmlSchemaValidityErrorFunc* err,
    xmlSchemaValidityWarningFunc* warn,
    void** ctx);
int xmlSchemaIsValid(xmlSchemaValidCtxtPtr ctxt);

xmlSchemaPtr xmlSchemaParse(xmlSchemaParserCtxtPtr ctxt);
void xmlSchemaFree(xmlSchemaPtr schema);

/* LIBXML_OUTPUT_ENABLED */
/*
 * Interfaces for validating
 */
void xmlSchemaSetValidErrors(
    xmlSchemaValidCtxtPtr ctxt,
    xmlSchemaValidityErrorFunc err,
    xmlSchemaValidityWarningFunc warn,
    void* ctx);
void xmlSchemaSetValidStructuredErrors(
    xmlSchemaValidCtxtPtr ctxt,
    xmlStructuredErrorFunc serror,
    void* ctx);
int xmlSchemaGetValidErrors(
    xmlSchemaValidCtxtPtr ctxt,
    xmlSchemaValidityErrorFunc* err,
    xmlSchemaValidityWarningFunc* warn,
    void** ctx);
int xmlSchemaSetValidOptions(xmlSchemaValidCtxtPtr ctxt, int options);
void xmlSchemaValidateSetFilename(
    xmlSchemaValidCtxtPtr vctxt,
    const(char)* filename);
int xmlSchemaValidCtxtGetOptions(xmlSchemaValidCtxtPtr ctxt);

xmlSchemaValidCtxtPtr xmlSchemaNewValidCtxt(xmlSchemaPtr schema);
void xmlSchemaFreeValidCtxt(xmlSchemaValidCtxtPtr ctxt);
int xmlSchemaValidateDoc(xmlSchemaValidCtxtPtr ctxt, xmlDocPtr instance);
int xmlSchemaValidateOneElement(xmlSchemaValidCtxtPtr ctxt, xmlNodePtr elem);
int xmlSchemaValidateStream(
    xmlSchemaValidCtxtPtr ctxt,
    xmlParserInputBufferPtr input,
    xmlCharEncoding enc,
    xmlSAXHandlerPtr sax,
    void* user_data);
int xmlSchemaValidateFile(
    xmlSchemaValidCtxtPtr ctxt,
    const(char)* filename,
    int options);

xmlParserCtxtPtr xmlSchemaValidCtxtGetParserCtxt(xmlSchemaValidCtxtPtr ctxt);

/*
 * Interface to insert Schemas SAX validation in a SAX stream
 */
struct _xmlSchemaSAXPlug;
alias xmlSchemaSAXPlugStruct = _xmlSchemaSAXPlug;
alias xmlSchemaSAXPlugPtr = _xmlSchemaSAXPlug*;

xmlSchemaSAXPlugPtr xmlSchemaSAXPlug(
    xmlSchemaValidCtxtPtr ctxt,
    xmlSAXHandlerPtr* sax,
    void** user_data);
int xmlSchemaSAXUnplug(xmlSchemaSAXPlugPtr plug);

void xmlSchemaValidateSetLocator(
    xmlSchemaValidCtxtPtr vctxt,
    xmlSchemaValidityLocatorFunc f,
    void* ctxt);

/* LIBXML_SCHEMAS_ENABLED */
/* __XML_SCHEMA_H__ */
