module c_libxml.xmlsave;

import c_libxml.encoding;
import c_libxml.tree;
import c_libxml.xmlIO;
import c_libxml.xmlversion;

/*
 * Summary: the XML document serializer
 * Description: API to save document or subtree of document
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C):

/**
 * xmlSaveOption:
 *
 * This is the set of XML save options that can be passed down
 * to the xmlSaveToFd() and similar calls.
 */

/* format save output */
/* drop the xml declaration */
/* no empty tags */
/* disable XHTML1 specific rules */
/* force XHTML1 specific rules */
/* force XML serialization on HTML doc */
/* force HTML serialization on XML doc */
/* format with non-significant whitespace */

/* LIBXML_OUTPUT_ENABLED */
/* __XML_XMLSAVE_H__ */
