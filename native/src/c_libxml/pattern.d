module c_libxml.pattern;

import c_libxml.dict;
import c_libxml.tree;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/*
 * Summary: pattern expression handling
 * Description: allows to compile and test pattern expressions for nodes
 *              either in a tree or based on a parser state.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C):

/**
 * xmlPattern:
 *
 * A compiled (XPath based) pattern to select nodes
 */
struct _xmlPattern;
alias xmlPattern = _xmlPattern;
alias xmlPatternPtr = _xmlPattern*;

/**
 * xmlPatternFlags:
 *
 * This is the set of options affecting the behaviour of pattern
 * matching with this module
 *
 */
enum xmlPatternFlags
{
    default_ = 0, /* simple pattern match */
    xpath = 1 << 0, /* standard XPath pattern */
    xssel = 1 << 1, /* XPath subset for schema selector */
    xsfield = 1 << 2 /* XPath subset for schema field */
}

void xmlFreePattern(xmlPatternPtr comp);

void xmlFreePatternList(xmlPatternPtr comp);

xmlPatternPtr xmlPatterncompile(
    const(xmlChar)* pattern,
    xmlDict* dict,
    int flags,
    const(xmlChar*)* namespaces);
int xmlPatternMatch(xmlPatternPtr comp, xmlNodePtr node);

/* streaming interfaces */
struct _xmlStreamCtxt;
alias xmlStreamCtxt = _xmlStreamCtxt;
alias xmlStreamCtxtPtr = _xmlStreamCtxt*;

int xmlPatternStreamable(xmlPatternPtr comp);
int xmlPatternMaxDepth(xmlPatternPtr comp);
int xmlPatternMinDepth(xmlPatternPtr comp);
int xmlPatternFromRoot(xmlPatternPtr comp);
xmlStreamCtxtPtr xmlPatternGetStreamCtxt(xmlPatternPtr comp);
void xmlFreeStreamCtxt(xmlStreamCtxtPtr stream);
int xmlStreamPushNode(
    xmlStreamCtxtPtr stream,
    const(xmlChar)* name,
    const(xmlChar)* ns,
    int nodeType);
int xmlStreamPush(
    xmlStreamCtxtPtr stream,
    const(xmlChar)* name,
    const(xmlChar)* ns);
int xmlStreamPushAttr(
    xmlStreamCtxtPtr stream,
    const(xmlChar)* name,
    const(xmlChar)* ns);
int xmlStreamPop(xmlStreamCtxtPtr stream);
int xmlStreamWantsAnyNode(xmlStreamCtxtPtr stream);

/* LIBXML_PATTERN_ENABLED */

/* __XML_PATTERN_H__ */
