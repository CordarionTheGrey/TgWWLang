module c_libxml.schematron;

import c_libxml.tree;
import c_libxml.xmlversion;

/*
 * Summary: XML Schemastron implementation
 * Description: interface to the XML Schematron validity checking.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C) nothrow:

/* quiet no report */
/* build a textual report */
/* output SVRL */
/* output via xmlStructuredErrorFunc */
/* output to a file descriptor */
/* output to a buffer */
/* output to I/O mechanism */

/**
 * The schemas related types are kept internal
 */

/**
 * xmlSchematronValidityErrorFunc:
 * @ctx: the validation context
 * @msg: the message
 * @...: extra arguments
 *
 * Signature of an error callback from a Schematron validation
 */

/**
 * xmlSchematronValidityWarningFunc:
 * @ctx: the validation context
 * @msg: the message
 * @...: extra arguments
 *
 * Signature of a warning callback from a Schematron validation
 */

/**
 * A schemas validation context
 */

/*
 * Interfaces for parsing.
 */

/*****
XMLPUBFUN void XMLCALL
        xmlSchematronSetParserErrors(xmlSchematronParserCtxtPtr ctxt,
                     xmlSchematronValidityErrorFunc err,
                     xmlSchematronValidityWarningFunc warn,
                     void *ctx);
XMLPUBFUN int XMLCALL
        xmlSchematronGetParserErrors(xmlSchematronParserCtxtPtr ctxt,
                    xmlSchematronValidityErrorFunc * err,
                    xmlSchematronValidityWarningFunc * warn,
                    void **ctx);
XMLPUBFUN int XMLCALL
        xmlSchematronIsValid    (xmlSchematronValidCtxtPtr ctxt);
 *****/

/*
 * Interfaces for validating
 */

/******
XMLPUBFUN void XMLCALL
        xmlSchematronSetValidErrors     (xmlSchematronValidCtxtPtr ctxt,
                     xmlSchematronValidityErrorFunc err,
                     xmlSchematronValidityWarningFunc warn,
                     void *ctx);
XMLPUBFUN int XMLCALL
        xmlSchematronGetValidErrors     (xmlSchematronValidCtxtPtr ctxt,
                     xmlSchematronValidityErrorFunc *err,
                     xmlSchematronValidityWarningFunc *warn,
                     void **ctx);
XMLPUBFUN int XMLCALL
        xmlSchematronSetValidOptions(xmlSchematronValidCtxtPtr ctxt,
                     int options);
XMLPUBFUN int XMLCALL
        xmlSchematronValidCtxtGetOptions(xmlSchematronValidCtxtPtr ctxt);
XMLPUBFUN int XMLCALL
            xmlSchematronValidateOneElement (xmlSchematronValidCtxtPtr ctxt,
                             xmlNodePtr elem);
 *******/

/* LIBXML_SCHEMATRON_ENABLED */
/* __XML_SCHEMATRON_H__ */
