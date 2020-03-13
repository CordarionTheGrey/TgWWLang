module c_libxml.debugXML;

import c_libxml.tree;
import c_libxml.xmlversion;
import c_libxml.xpath;

/*
 * Summary: Tree debugging APIs
 * Description: Interfaces to a set of routines used for debugging the tree
 *              produced by the XML parser.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C) nothrow:

/*
 * The standard Dump routines.
 */

/****************************************************************
 *                                                              *
 *                      Checking routines                       *
 *                                                              *
 ****************************************************************/

/****************************************************************
 *                                                              *
 *                      XML shell helpers                       *
 *                                                              *
 ****************************************************************/

/****************************************************************
 *                                                              *
 *       The XML shell related structures and functions         *
 *                                                              *
 ****************************************************************/

/**
 * xmlShellReadlineFunc:
 * @prompt:  a string prompt
 *
 * This is a generic signature for the XML shell input function.
 *
 * Returns a string which will be freed by the Shell.
 */

/**
 * xmlShellCtxt:
 *
 * A debugging shell context.
 * TODO: add the defined function tables.
 */

/**
 * xmlShellCmd:
 * @ctxt:  a shell context
 * @arg:  a string argument
 * @node:  a first node
 * @node2:  a second node
 *
 * This is a generic signature for the XML shell functions.
 *
 * Returns an int, negative returns indicating errors.
 */

/* LIBXML_OUTPUT_ENABLED */

/* LIBXML_VALID_ENABLED */

/*
 * The Shell interface.
 */

/* LIBXML_XPATH_ENABLED */

/* LIBXML_DEBUG_ENABLED */
/* __DEBUG_XML__ */
