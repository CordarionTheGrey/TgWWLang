module c_libxml.HTMLtree;

import c_libxml.HTMLparser;
import c_libxml.tree;
import c_libxml.xmlversion;

/*
 * Summary: specific APIs to process HTML tree, especially serialization
 * Description: this module implements a few function needed to process
 *              tree in an HTML specific way.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C) nothrow @system:

/**
 * HTML_TEXT_NODE:
 *
 * Macro. A text node in a HTML document is really implemented
 * the same way as a text node in an XML document.
 */

/**
 * HTML_ENTITY_REF_NODE:
 *
 * Macro. An entity reference in a HTML document is really implemented
 * the same way as an entity reference in an XML document.
 */

/**
 * HTML_COMMENT_NODE:
 *
 * Macro. A comment in a HTML document is really implemented
 * the same way as a comment in an XML document.
 */

/**
 * HTML_PRESERVE_NODE:
 *
 * Macro. A preserved node in a HTML document is really implemented
 * the same way as a CDATA section in an XML document.
 */

/**
 * HTML_PI_NODE:
 *
 * Macro. A processing instruction in a HTML document is really implemented
 * the same way as a processing instruction in an XML document.
 */

/* LIBXML_OUTPUT_ENABLED */

/* LIBXML_HTML_ENABLED */

/* __HTML_TREE_H__ */
