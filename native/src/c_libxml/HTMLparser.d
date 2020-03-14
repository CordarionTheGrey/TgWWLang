module c_libxml.HTMLparser;

import c_libxml.parser;
import c_libxml.xmlversion;

/*
 * Summary: interface for an HTML 4.0 non-verifying parser
 * Description: this module implements an HTML 4.0 non-verifying parser
 *              with API compatible with the XML parser ones. It should
 *              be able to parse "real world" HTML, even if severely
 *              broken from a specification point of view.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C) nothrow @system:

/*
 * Most of the back-end structures from XML and HTML are shared.
 */

/*
 * Internal description of an HTML element, representing HTML 4.01
 * and XHTML 1.0 (which share the same structure).
 */

/* The tag name */
/* Whether the start tag can be implied */
/* Whether the end tag can be implied */
/* Whether the end tag should be saved */
/* Is this an empty element ? */
/* Is this a deprecated element ? */
/* 1: only in Loose DTD, 2: only Frameset one */
/* is this a block 0 or inline 1 element */
/* the description */

/* NRK Jan.2003
 * New fields encapsulating HTML structure
 *
 * Bugs:
 *      This is a very limited representation.  It fails to tell us when
 *      an element *requires* subelements (we only have whether they're
 *      allowed or not), and it doesn't tell us where CDATA and PCDATA
 *      are allowed.  Some element relationships are not fully represented:
 *      these are flagged with the word MODIFIER
 */
/* allowed sub-elements of this element */
/* subelement for suggested auto-repair
                       if necessary or NULL */
/* Optional Attributes */
/* Additional deprecated attributes */
/* Required attributes */

/*
 * Internal description of an HTML entity.
 */

/* the UNICODE value for the character */
/* The entity name */
/* the description */

/*
 * There is only few public functions.
 */

/**
 * Interfaces for the Push mode.
 */

/* LIBXML_PUSH_ENABLED */

/*
 * New set of simpler/more flexible APIs
 */
/**
 * xmlParserOption:
 *
 * This is the set of XML parser options that can be passed down
 * to the xmlReadDoc() and similar calls.
 */

/* Relaxed parsing */
/* do not default a doctype if not found */
/* suppress error reports */
/* suppress warning reports */
/* pedantic error reporting */
/* remove blank nodes */
/* Forbid network access */
/* Do not add implied html/body... elements */
/* compact small text nodes */
/* ignore internal document encoding hint */

/* NRK/Jan2003: further knowledge of HTML structure
 */

/* something we don't check at all */

/* VALID bit set so ( & HTML_VALID ) is TRUE */

/* Using htmlElemDesc rather than name here, to emphasise the fact
   that otherwise there's a lookup overhead
*/

/**
 * htmlDefaultSubelement:
 * @elt: HTML element
 *
 * Returns the default subelement for this element
 */

/**
 * htmlElementAllowedHereDesc:
 * @parent: HTML parent element
 * @elt: HTML element
 *
 * Checks whether an HTML element description may be a
 * direct child of the specified element.
 *
 * Returns 1 if allowed; 0 otherwise.
 */

/**
 * htmlRequiredAttrs:
 * @elt: HTML element
 *
 * Returns the attributes required for the specified element.
 */

/* LIBXML_HTML_ENABLED */
/* __HTML_PARSER_H__ */
