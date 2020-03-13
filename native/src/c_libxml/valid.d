module c_libxml.valid;

import c_libxml.list;
import c_libxml.tree;
import c_libxml.xmlautomata;
import c_libxml.xmlerror;
import c_libxml.xmlregexp;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/*
 * Summary: The DTD validation
 * Description: API for the DTD handling and the validity checking
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C) nothrow:

/*
 * Validation state added for non-determinist content model.
 */
struct _xmlValidState;
alias xmlValidState = _xmlValidState;
alias xmlValidStatePtr = _xmlValidState*;

/**
 * xmlValidityErrorFunc:
 * @ctx:  usually an xmlValidCtxtPtr to a validity error context,
 *        but comes from ctxt->userData (which normally contains such
 *        a pointer); ctxt->userData can be changed by the user.
 * @msg:  the string to format *printf like vararg
 * @...:  remaining arguments to the format
 *
 * Callback called when a validity error is found. This is a message
 * oriented function similar to an *printf function.
 */
alias xmlValidityErrorFunc = void function(void* ctx, const(char)* msg, ...);

/**
 * xmlValidityWarningFunc:
 * @ctx:  usually an xmlValidCtxtPtr to a validity error context,
 *        but comes from ctxt->userData (which normally contains such
 *        a pointer); ctxt->userData can be changed by the user.
 * @msg:  the string to format *printf like vararg
 * @...:  remaining arguments to the format
 *
 * Callback called when a validity warning is found. This is a message
 * oriented function similar to an *printf function.
 */
alias xmlValidityWarningFunc = void function(void* ctx, const(char)* msg, ...);

/**
 * XML_CTXT_FINISH_DTD_0:
 *
 * Special value for finishDtd field when embedded in an xmlParserCtxt
 */

/**
 * XML_CTXT_FINISH_DTD_1:
 *
 * Special value for finishDtd field when embedded in an xmlParserCtxt
 */

/*
 * xmlValidCtxt:
 * An xmlValidCtxt is used for error reporting when validating.
 */
alias xmlValidCtxt = _xmlValidCtxt;
alias xmlValidCtxtPtr = _xmlValidCtxt*;

struct _xmlValidCtxt
{
    void* userData; /* user specific data block */
    xmlValidityErrorFunc error; /* the callback in case of errors */
    xmlValidityWarningFunc warning; /* the callback in case of warning */

    /* Node analysis stack used when validating within entities */
    xmlNodePtr node; /* Current parsed Node */
    int nodeNr; /* Depth of the parsing stack */
    int nodeMax; /* Max depth of the parsing stack */
    xmlNodePtr* nodeTab; /* array of nodes */

    uint finishDtd; /* finished validating the Dtd ? */
    xmlDocPtr doc; /* the document */
    int valid; /* temporary validity check result */

    /* state state used for non-determinist content validation */
    xmlValidState* vstate; /* current state */
    int vstateNr; /* Depth of the validation stack */
    int vstateMax; /* Max depth of the validation stack */
    xmlValidState* vstateTab; /* array of validation states */

    xmlAutomataPtr am; /* the automata */
    xmlAutomataStatePtr state; /* used to build the automata */
}

/*
 * ALL notation declarations are stored in a table.
 * There is one table per DTD.
 */

struct _xmlHashTable;
alias xmlNotationTable = _xmlHashTable;
alias xmlNotationTablePtr = _xmlHashTable*;

/*
 * ALL element declarations are stored in a table.
 * There is one table per DTD.
 */

alias xmlElementTable = _xmlHashTable;
alias xmlElementTablePtr = _xmlHashTable*;

/*
 * ALL attribute declarations are stored in a table.
 * There is one table per DTD.
 */

alias xmlAttributeTable = _xmlHashTable;
alias xmlAttributeTablePtr = _xmlHashTable*;

/*
 * ALL IDs attributes are stored in a table.
 * There is one table per document.
 */

alias xmlIDTable = _xmlHashTable;
alias xmlIDTablePtr = _xmlHashTable*;

/*
 * ALL Refs attributes are stored in a table.
 * There is one table per document.
 */

alias xmlRefTable = _xmlHashTable;
alias xmlRefTablePtr = _xmlHashTable*;

/* Notation */
xmlNotationPtr xmlAddNotationDecl(
    xmlValidCtxtPtr ctxt,
    xmlDtdPtr dtd,
    const(xmlChar)* name,
    const(xmlChar)* PublicID,
    const(xmlChar)* SystemID);
xmlNotationTablePtr xmlCopyNotationTable(xmlNotationTablePtr table);
/* LIBXML_TREE_ENABLED */
void xmlFreeNotationTable(xmlNotationTablePtr table);

/* LIBXML_OUTPUT_ENABLED */

/* Element Content */
/* the non Doc version are being deprecated */
xmlElementContentPtr xmlNewElementContent(
    const(xmlChar)* name,
    xmlElementContentType type);
xmlElementContentPtr xmlCopyElementContent(xmlElementContentPtr content);
void xmlFreeElementContent(xmlElementContentPtr cur);
/* the new versions with doc argument */
xmlElementContentPtr xmlNewDocElementContent(
    xmlDocPtr doc,
    const(xmlChar)* name,
    xmlElementContentType type);
xmlElementContentPtr xmlCopyDocElementContent(
    xmlDocPtr doc,
    xmlElementContentPtr content);
void xmlFreeDocElementContent(xmlDocPtr doc, xmlElementContentPtr cur);
void xmlSnprintfElementContent(
    char* buf,
    int size,
    xmlElementContentPtr content,
    int englob);

/* DEPRECATED */

/* LIBXML_OUTPUT_ENABLED */
/* DEPRECATED */

/* Element */
xmlElementPtr xmlAddElementDecl(
    xmlValidCtxtPtr ctxt,
    xmlDtdPtr dtd,
    const(xmlChar)* name,
    xmlElementTypeVal type,
    xmlElementContentPtr content);
xmlElementTablePtr xmlCopyElementTable(xmlElementTablePtr table);
/* LIBXML_TREE_ENABLED */
void xmlFreeElementTable(xmlElementTablePtr table);

/* LIBXML_OUTPUT_ENABLED */

/* Enumeration */
xmlEnumerationPtr xmlCreateEnumeration(const(xmlChar)* name);
void xmlFreeEnumeration(xmlEnumerationPtr cur);
xmlEnumerationPtr xmlCopyEnumeration(xmlEnumerationPtr cur);
/* LIBXML_TREE_ENABLED */

/* Attribute */
xmlAttributePtr xmlAddAttributeDecl(
    xmlValidCtxtPtr ctxt,
    xmlDtdPtr dtd,
    const(xmlChar)* elem,
    const(xmlChar)* name,
    const(xmlChar)* ns,
    xmlAttributeType type,
    xmlAttributeDefault def,
    const(xmlChar)* defaultValue,
    xmlEnumerationPtr tree);
xmlAttributeTablePtr xmlCopyAttributeTable(xmlAttributeTablePtr table);
/* LIBXML_TREE_ENABLED */
void xmlFreeAttributeTable(xmlAttributeTablePtr table);

/* LIBXML_OUTPUT_ENABLED */

/* IDs */
xmlIDPtr xmlAddID(
    xmlValidCtxtPtr ctxt,
    xmlDocPtr doc,
    const(xmlChar)* value,
    xmlAttrPtr attr);
void xmlFreeIDTable(xmlIDTablePtr table);
xmlAttrPtr xmlGetID(xmlDocPtr doc, const(xmlChar)* ID);
int xmlIsID(xmlDocPtr doc, xmlNodePtr elem, xmlAttrPtr attr);
int xmlRemoveID(xmlDocPtr doc, xmlAttrPtr attr);

/* IDREFs */
xmlRefPtr xmlAddRef(
    xmlValidCtxtPtr ctxt,
    xmlDocPtr doc,
    const(xmlChar)* value,
    xmlAttrPtr attr);
void xmlFreeRefTable(xmlRefTablePtr table);
int xmlIsRef(xmlDocPtr doc, xmlNodePtr elem, xmlAttrPtr attr);
int xmlRemoveRef(xmlDocPtr doc, xmlAttrPtr attr);
xmlListPtr xmlGetRefs(xmlDocPtr doc, const(xmlChar)* ID);

/**
 * The public function calls related to validity checking.
 */

/* Allocate/Release Validation Contexts */

/* LIBXML_VALID_ENABLED */

int xmlValidateNotationUse(
    xmlValidCtxtPtr ctxt,
    xmlDocPtr doc,
    const(xmlChar)* notationName);
/* LIBXML_VALID_ENABLED or LIBXML_SCHEMAS_ENABLED */

int xmlIsMixedElement(xmlDocPtr doc, const(xmlChar)* name);
xmlAttributePtr xmlGetDtdAttrDesc(
    xmlDtdPtr dtd,
    const(xmlChar)* elem,
    const(xmlChar)* name);
xmlAttributePtr xmlGetDtdQAttrDesc(
    xmlDtdPtr dtd,
    const(xmlChar)* elem,
    const(xmlChar)* name,
    const(xmlChar)* prefix);
xmlNotationPtr xmlGetDtdNotationDesc(xmlDtdPtr dtd, const(xmlChar)* name);
xmlElementPtr xmlGetDtdQElementDesc(
    xmlDtdPtr dtd,
    const(xmlChar)* name,
    const(xmlChar)* prefix);
xmlElementPtr xmlGetDtdElementDesc(xmlDtdPtr dtd, const(xmlChar)* name);

/*
 * Validation based on the regexp support
 */

/* LIBXML_REGEXP_ENABLED */
/* LIBXML_VALID_ENABLED */

/* __XML_VALID_H__ */
