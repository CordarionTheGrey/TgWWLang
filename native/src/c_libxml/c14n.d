module c_libxml.c14n;

import c_libxml.tree;
import c_libxml.xmlversion;
import c_libxml.xpath;

/*
 * Summary: Provide Canonical XML and Exclusive XML Canonicalization
 * Description: the c14n modules provides a
 *
 * "Canonical XML" implementation
 * http://www.w3.org/TR/xml-c14n
 *
 * and an
 *
 * "Exclusive XML Canonicalization" implementation
 * http://www.w3.org/TR/xml-exc-c14n

 * Copy: See Copyright for the status of this software.
 *
 * Author: Aleksey Sanin <aleksey@aleksey.com>
 */

extern (C) nothrow:

/* __cplusplus */

/*
 * XML Canonicalization
 * http://www.w3.org/TR/xml-c14n
 *
 * Exclusive XML Canonicalization
 * http://www.w3.org/TR/xml-exc-c14n
 *
 * Canonical form of an XML document could be created if and only if
 *  a) default attributes (if any) are added to all nodes
 *  b) all character and parsed entity references are resolved
 * In order to achieve this in libxml2 the document MUST be loaded with
 * following global settings:
 *
 *    xmlLoadExtDtdDefaultValue = XML_DETECT_IDS | XML_COMPLETE_ATTRS;
 *    xmlSubstituteEntitiesDefault(1);
 *
 * or corresponding parser context setting:
 *    xmlParserCtxtPtr ctxt;
 *
 *    ...
 *    ctxt->loadsubset = XML_DETECT_IDS | XML_COMPLETE_ATTRS;
 *    ctxt->replaceEntities = 1;
 *    ...
 */

/*
 * xmlC14NMode:
 *
 * Predefined values for C14N modes
 *
 */

/* Original C14N 1.0 spec */
/* Exclusive C14N 1.0 spec */
/* C14N 1.1 spec */

/* a xmlC14NMode */

/* a xmlC14NMode */

/* a xmlC14NMode */

/**
 * This is the core C14N function
 */
/**
 * xmlC14NIsVisibleCallback:
 * @user_data: user data
 * @node: the current node
 * @parent: the parent node
 *
 * Signature for a C14N callback on visible nodes
 *
 * Returns 1 if the node should be included
 */

/* a xmlC14NMode */

/* __cplusplus */

/* LIBXML_OUTPUT_ENABLED */
/* LIBXML_C14N_ENABLED */
/* __XML_C14N_H__ */
