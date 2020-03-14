module c_libxml.xmlreader;

import c_libxml.relaxng;
import c_libxml.tree;
import c_libxml.xmlIO;
import c_libxml.xmlschemas;
import c_libxml.xmlversion;

/*
 * Summary: the XMLReader implementation
 * Description: API of the XML streaming API based on C# interfaces.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C) nothrow @system:

/**
 * xmlParserSeverities:
 *
 * How severe an error callback is when the per-reader error callback API
 * is used.
 */
enum xmlParserSeverities
{
    validityWarning = 1,
    validityError = 2,
    warning = 3,
    error = 4
}

/**
 * xmlTextReaderMode:
 *
 * Internal state values for the reader.
 */

/**
 * xmlParserProperties:
 *
 * Some common options to use with xmlTextReaderSetParserProp, but it
 * is better to use xmlParserOption and the xmlReaderNewxxx and
 * xmlReaderForxxx APIs now.
 */

/**
 * xmlReaderTypes:
 *
 * Predefined constants for the different types of nodes.
 */

/**
 * xmlTextReader:
 *
 * Structure for an xmlReader context.
 */

/**
 * xmlTextReaderPtr:
 *
 * Pointer to an xmlReader context.
 */

/*
 * Constructors & Destructor
 */

/*
 * Iterators
 */

/*
 * Attributes of the node
 */

/*
 * use the Const version of the routine for
 * better performance and simpler code
 */

/*
 * Methods of the XmlTextReader
 */

/*
 * Extensions
 */

/* LIBXML_PATTERN_ENABLED */

/*
 * Index lookup
 */

/*
 * New more complete APIs for simpler creation and reuse of readers
 */

/*
 * Error handling extensions
 */

/**
 * xmlTextReaderErrorFunc:
 * @arg: the user argument
 * @msg: the message
 * @severity: the severity of the error
 * @locator: a locator indicating where the error occurred
 *
 * Signature of an error callback from a reader parser
 */

/* LIBXML_READER_ENABLED */

/* __XML_XMLREADER_H__ */
