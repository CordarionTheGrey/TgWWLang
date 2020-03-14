module c_libxml.relaxng;

import c_libxml.hash;
import c_libxml.tree;
import c_libxml.xmlerror;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/*
 * Summary: implementation of the Relax-NG validation
 * Description: implementation of the Relax-NG validation
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C) nothrow @system:

struct _xmlRelaxNG;
alias xmlRelaxNG = _xmlRelaxNG;
alias xmlRelaxNGPtr = _xmlRelaxNG*;

/**
 * xmlRelaxNGValidityErrorFunc:
 * @ctx: the validation context
 * @msg: the message
 * @...: extra arguments
 *
 * Signature of an error callback from a Relax-NG validation
 */
alias xmlRelaxNGValidityErrorFunc = void function(
    void* ctx,
    const(char)* msg,
    ...);

/**
 * xmlRelaxNGValidityWarningFunc:
 * @ctx: the validation context
 * @msg: the message
 * @...: extra arguments
 *
 * Signature of a warning callback from a Relax-NG validation
 */
alias xmlRelaxNGValidityWarningFunc = void function(
    void* ctx,
    const(char)* msg,
    ...);

/**
 * A schemas validation context
 */
struct _xmlRelaxNGParserCtxt;
alias xmlRelaxNGParserCtxt = _xmlRelaxNGParserCtxt;
alias xmlRelaxNGParserCtxtPtr = _xmlRelaxNGParserCtxt*;

struct _xmlRelaxNGValidCtxt;
alias xmlRelaxNGValidCtxt = _xmlRelaxNGValidCtxt;
alias xmlRelaxNGValidCtxtPtr = _xmlRelaxNGValidCtxt*;

/*
 * xmlRelaxNGValidErr:
 *
 * List of possible Relax NG validation errors
 */
enum xmlRelaxNGValidErr
{
    ok = 0,
    errMemory = 1,
    errType = 2,
    errTypeval = 3,
    errDupid = 4,
    errTypecmp = 5,
    errNostate = 6,
    errNodefine = 7,
    errListextra = 8,
    errListempty = 9,
    errInternodata = 10,
    errInterseq = 11,
    errInterextra = 12,
    errElemname = 13,
    errAttrname = 14,
    errElemnons = 15,
    errAttrnons = 16,
    errElemwrongns = 17,
    errAttrwrongns = 18,
    errElemextrans = 19,
    errAttrextrans = 20,
    errElemnotempty = 21,
    errNoelem = 22,
    errNotelem = 23,
    errAttrvalid = 24,
    errContentvalid = 25,
    errExtracontent = 26,
    errInvalidattr = 27,
    errDataelem = 28,
    errValelem = 29,
    errListelem = 30,
    errDatatype = 31,
    errValue = 32,
    errList = 33,
    errNogrammar = 34,
    errExtradata = 35,
    errLackdata = 36,
    errInternal = 37,
    errElemwrong = 38,
    errTextwrong = 39
}

/*
 * xmlRelaxNGParserFlags:
 *
 * List of possible Relax NG Parser flags
 */
enum xmlRelaxNGParserFlag
{
    none = 0,
    freeDoc = 1,
    crng = 2
}

int xmlRelaxNGInitTypes();
void xmlRelaxNGCleanupTypes();

/*
 * Interfaces for parsing.
 */
xmlRelaxNGParserCtxtPtr xmlRelaxNGNewParserCtxt(const(char)* URL);
xmlRelaxNGParserCtxtPtr xmlRelaxNGNewMemParserCtxt(
    const(char)* buffer,
    int size);
xmlRelaxNGParserCtxtPtr xmlRelaxNGNewDocParserCtxt(xmlDocPtr doc);

int xmlRelaxParserSetFlag(xmlRelaxNGParserCtxtPtr ctxt, int flag);

void xmlRelaxNGFreeParserCtxt(xmlRelaxNGParserCtxtPtr ctxt);
void xmlRelaxNGSetParserErrors(
    xmlRelaxNGParserCtxtPtr ctxt,
    xmlRelaxNGValidityErrorFunc err,
    xmlRelaxNGValidityWarningFunc warn,
    void* ctx);
int xmlRelaxNGGetParserErrors(
    xmlRelaxNGParserCtxtPtr ctxt,
    xmlRelaxNGValidityErrorFunc* err,
    xmlRelaxNGValidityWarningFunc* warn,
    void** ctx);
void xmlRelaxNGSetParserStructuredErrors(
    xmlRelaxNGParserCtxtPtr ctxt,
    xmlStructuredErrorFunc serror,
    void* ctx);
xmlRelaxNGPtr xmlRelaxNGParse(xmlRelaxNGParserCtxtPtr ctxt);
void xmlRelaxNGFree(xmlRelaxNGPtr schema);

/* LIBXML_OUTPUT_ENABLED */
/*
 * Interfaces for validating
 */
void xmlRelaxNGSetValidErrors(
    xmlRelaxNGValidCtxtPtr ctxt,
    xmlRelaxNGValidityErrorFunc err,
    xmlRelaxNGValidityWarningFunc warn,
    void* ctx);
int xmlRelaxNGGetValidErrors(
    xmlRelaxNGValidCtxtPtr ctxt,
    xmlRelaxNGValidityErrorFunc* err,
    xmlRelaxNGValidityWarningFunc* warn,
    void** ctx);
void xmlRelaxNGSetValidStructuredErrors(
    xmlRelaxNGValidCtxtPtr ctxt,
    xmlStructuredErrorFunc serror,
    void* ctx);
xmlRelaxNGValidCtxtPtr xmlRelaxNGNewValidCtxt(xmlRelaxNGPtr schema);
void xmlRelaxNGFreeValidCtxt(xmlRelaxNGValidCtxtPtr ctxt);
int xmlRelaxNGValidateDoc(xmlRelaxNGValidCtxtPtr ctxt, xmlDocPtr doc);
/*
 * Interfaces for progressive validation when possible
 */
int xmlRelaxNGValidatePushElement(
    xmlRelaxNGValidCtxtPtr ctxt,
    xmlDocPtr doc,
    xmlNodePtr elem);
int xmlRelaxNGValidatePushCData(
    xmlRelaxNGValidCtxtPtr ctxt,
    const(xmlChar)* data,
    int len);
int xmlRelaxNGValidatePopElement(
    xmlRelaxNGValidCtxtPtr ctxt,
    xmlDocPtr doc,
    xmlNodePtr elem);
int xmlRelaxNGValidateFullElement(
    xmlRelaxNGValidCtxtPtr ctxt,
    xmlDocPtr doc,
    xmlNodePtr elem);

/* LIBXML_SCHEMAS_ENABLED */

/* __XML_RELAX_NG__ */
