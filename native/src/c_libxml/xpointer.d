module c_libxml.xpointer;

import c_libxml.tree;
import c_libxml.xmlstring;
import c_libxml.xmlversion;
import c_libxml.xpath;

/*
 * Summary: API to handle XML Pointers
 * Description: API to handle XML Pointers
 * Base implementation was made accordingly to
 * W3C Candidate Recommendation 7 June 2000
 * http://www.w3.org/TR/2000/CR-xptr-20000607
 *
 * Added support for the element() scheme described in:
 * W3C Proposed Recommendation 13 November 2002
 * http://www.w3.org/TR/2002/PR-xptr-element-20021113/
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C) nothrow:

/*
 * A Location Set
 */
alias xmlLocationSet = _xmlLocationSet;
alias xmlLocationSetPtr = _xmlLocationSet*;

struct _xmlLocationSet
{
    int locNr; /* number of locations in the set */
    int locMax; /* size of the array as allocated */
    xmlXPathObjectPtr* locTab; /* array of locations */
}

/*
 * Handling of location sets.
 */

xmlLocationSetPtr xmlXPtrLocationSetCreate(xmlXPathObjectPtr val);
void xmlXPtrFreeLocationSet(xmlLocationSetPtr obj);
xmlLocationSetPtr xmlXPtrLocationSetMerge(
    xmlLocationSetPtr val1,
    xmlLocationSetPtr val2);
xmlXPathObjectPtr xmlXPtrNewRange(
    xmlNodePtr start,
    int startindex,
    xmlNodePtr end,
    int endindex);
xmlXPathObjectPtr xmlXPtrNewRangePoints(
    xmlXPathObjectPtr start,
    xmlXPathObjectPtr end);
xmlXPathObjectPtr xmlXPtrNewRangeNodePoint(
    xmlNodePtr start,
    xmlXPathObjectPtr end);
xmlXPathObjectPtr xmlXPtrNewRangePointNode(
    xmlXPathObjectPtr start,
    xmlNodePtr end);
xmlXPathObjectPtr xmlXPtrNewRangeNodes(xmlNodePtr start, xmlNodePtr end);
xmlXPathObjectPtr xmlXPtrNewLocationSetNodes(xmlNodePtr start, xmlNodePtr end);
xmlXPathObjectPtr xmlXPtrNewLocationSetNodeSet(xmlNodeSetPtr set);
xmlXPathObjectPtr xmlXPtrNewRangeNodeObject(
    xmlNodePtr start,
    xmlXPathObjectPtr end);
xmlXPathObjectPtr xmlXPtrNewCollapsedRange(xmlNodePtr start);
void xmlXPtrLocationSetAdd(xmlLocationSetPtr cur, xmlXPathObjectPtr val);
xmlXPathObjectPtr xmlXPtrWrapLocationSet(xmlLocationSetPtr val);
void xmlXPtrLocationSetDel(xmlLocationSetPtr cur, xmlXPathObjectPtr val);
void xmlXPtrLocationSetRemove(xmlLocationSetPtr cur, int val);

/*
 * Functions.
 */
xmlXPathContextPtr xmlXPtrNewContext(
    xmlDocPtr doc,
    xmlNodePtr here,
    xmlNodePtr origin);
xmlXPathObjectPtr xmlXPtrEval(const(xmlChar)* str, xmlXPathContextPtr ctx);
void xmlXPtrRangeToFunction(xmlXPathParserContextPtr ctxt, int nargs);
xmlNodePtr xmlXPtrBuildNodeList(xmlXPathObjectPtr obj);
void xmlXPtrEvalRangePredicate(xmlXPathParserContextPtr ctxt);

/* LIBXML_XPTR_ENABLED */
/* __XML_XPTR_H__ */
