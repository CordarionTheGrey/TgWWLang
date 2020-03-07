module c_libxml.xlink;

import c_libxml.tree;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/*
 * Summary: unfinished XLink detection module
 * Description: unfinished XLink detection module
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C):

/**
 * Various defines for the various Link properties.
 *
 * NOTE: the link detection layer will try to resolve QName expansion
 *       of namespaces. If "foo" is the prefix for "http://foo.com/"
 *       then the link detection layer will expand role="foo:myrole"
 *       to "http://foo.com/:myrole".
 * NOTE: the link detection layer will expand URI-References found on
 *       href attributes by using the base mechanism if found.
 */
alias xlinkHRef = ubyte*;
alias xlinkRole = ubyte*;
alias xlinkTitle = ubyte*;

enum xlinkType
{
    none = 0,
    simple = 1,
    extended = 2,
    extendedSet = 3
}

enum xlinkShow
{
    none = 0,
    new_ = 1,
    embed = 2,
    replace = 3
}

enum xlinkActuate
{
    none = 0,
    auto_ = 1,
    onrequest = 2
}

/**
 * xlinkNodeDetectFunc:
 * @ctx:  user data pointer
 * @node:  the node to check
 *
 * This is the prototype for the link detection routine.
 * It calls the default link detection callbacks upon link detection.
 */
alias xlinkNodeDetectFunc = void function(void* ctx, xmlNodePtr node);

/*
 * The link detection module interact with the upper layers using
 * a set of callback registered at parsing time.
 */

/**
 * xlinkSimpleLinkFunk:
 * @ctx:  user data pointer
 * @node:  the node carrying the link
 * @href:  the target of the link
 * @role:  the role string
 * @title:  the link title
 *
 * This is the prototype for a simple link detection callback.
 */
alias xlinkSimpleLinkFunk = void function(
    void* ctx,
    xmlNodePtr node,
    const xlinkHRef href,
    const xlinkRole role,
    const xlinkTitle title);

/**
 * xlinkExtendedLinkFunk:
 * @ctx:  user data pointer
 * @node:  the node carrying the link
 * @nbLocators: the number of locators detected on the link
 * @hrefs:  pointer to the array of locator hrefs
 * @roles:  pointer to the array of locator roles
 * @nbArcs: the number of arcs detected on the link
 * @from:  pointer to the array of source roles found on the arcs
 * @to:  pointer to the array of target roles found on the arcs
 * @show:  array of values for the show attributes found on the arcs
 * @actuate:  array of values for the actuate attributes found on the arcs
 * @nbTitles: the number of titles detected on the link
 * @title:  array of titles detected on the link
 * @langs:  array of xml:lang values for the titles
 *
 * This is the prototype for a extended link detection callback.
 */
alias xlinkExtendedLinkFunk = void function(
    void* ctx,
    xmlNodePtr node,
    int nbLocators,
    const(xlinkHRef)* hrefs,
    const(xlinkRole)* roles,
    int nbArcs,
    const(xlinkRole)* from,
    const(xlinkRole)* to,
    xlinkShow* show,
    xlinkActuate* actuate,
    int nbTitles,
    const(xlinkTitle)* titles,
    const(xmlChar*)* langs);

/**
 * xlinkExtendedLinkSetFunk:
 * @ctx:  user data pointer
 * @node:  the node carrying the link
 * @nbLocators: the number of locators detected on the link
 * @hrefs:  pointer to the array of locator hrefs
 * @roles:  pointer to the array of locator roles
 * @nbTitles: the number of titles detected on the link
 * @title:  array of titles detected on the link
 * @langs:  array of xml:lang values for the titles
 *
 * This is the prototype for a extended link set detection callback.
 */
alias xlinkExtendedLinkSetFunk = void function(
    void* ctx,
    xmlNodePtr node,
    int nbLocators,
    const(xlinkHRef)* hrefs,
    const(xlinkRole)* roles,
    int nbTitles,
    const(xlinkTitle)* titles,
    const(xmlChar*)* langs);

/**
 * This is the structure containing a set of Links detection callbacks.
 *
 * There is no default xlink callbacks, if one want to get link
 * recognition activated, those call backs must be provided before parsing.
 */
alias xlinkHandler = _xlinkHandler;
alias xlinkHandlerPtr = _xlinkHandler*;

struct _xlinkHandler
{
    xlinkSimpleLinkFunk simple;
    xlinkExtendedLinkFunk extended;
    xlinkExtendedLinkSetFunk set;
}

/*
 * The default detection routine, can be overridden, they call the default
 * detection callbacks.
 */

xlinkNodeDetectFunc xlinkGetDefaultDetect();
void xlinkSetDefaultDetect(xlinkNodeDetectFunc func);

/*
 * Routines to set/get the default handlers.
 */
xlinkHandlerPtr xlinkGetDefaultHandler();
void xlinkSetDefaultHandler(xlinkHandlerPtr handler);

/*
 * Link detection module itself.
 */
xlinkType xlinkIsLink(xmlDocPtr doc, xmlNodePtr node);

/* LIBXML_XPTR_ENABLED */

/* __XML_XLINK_H__ */
