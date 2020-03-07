module c_libxml.xpathInternals;

import c_libxml.tree;
import c_libxml.xmlstring;
import c_libxml.xmlversion;
import c_libxml.xpath;

/*
 * Summary: internal interfaces for XML Path Language implementation
 * Description: internal interfaces for XML Path Language implementation
 *              used to build new modules on top of XPath like XPointer and
 *              XSLT
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

import core.stdc.stddef;

extern (C):

/************************************************************************
 *                                                                      *
 *                      Helpers                                         *
 *                                                                      *
 ************************************************************************/

/*
 * Many of these macros may later turn into functions. They
 * shouldn't be used in #ifdef's preprocessor instructions.
 */
/**
 * xmlXPathSetError:
 * @ctxt:  an XPath parser context
 * @err:  an xmlXPathError code
 *
 * Raises an error.
 */

/**
 * xmlXPathSetArityError:
 * @ctxt:  an XPath parser context
 *
 * Raises an XPATH_INVALID_ARITY error.
 */
extern (D) auto xmlXPathSetArityError(T)(auto ref T ctxt)
{
    return xmlXPathSetError(ctxt, .XPATH_INVALID_ARITY);
}

/**
 * xmlXPathSetTypeError:
 * @ctxt:  an XPath parser context
 *
 * Raises an XPATH_INVALID_TYPE error.
 */
extern (D) auto xmlXPathSetTypeError(T)(auto ref T ctxt)
{
    return xmlXPathSetError(ctxt, .XPATH_INVALID_TYPE);
}

/**
 * xmlXPathGetError:
 * @ctxt:  an XPath parser context
 *
 * Get the error code of an XPath context.
 *
 * Returns the context error.
 */
extern (D) auto xmlXPathGetError(T)(auto ref T ctxt)
{
    return ctxt.error;
}

/**
 * xmlXPathCheckError:
 * @ctxt:  an XPath parser context
 *
 * Check if an XPath error was raised.
 *
 * Returns true if an error has been raised, false otherwise.
 */
extern (D) auto xmlXPathCheckError(T)(auto ref T ctxt)
{
    return ctxt.error != .XPATH_EXPRESSION_OK;
}

/**
 * xmlXPathGetDocument:
 * @ctxt:  an XPath parser context
 *
 * Get the document of an XPath context.
 *
 * Returns the context document.
 */
extern (D) auto xmlXPathGetDocument(T)(auto ref T ctxt)
{
    return ctxt.context.doc;
}

/**
 * xmlXPathGetContextNode:
 * @ctxt: an XPath parser context
 *
 * Get the context node of an XPath context.
 *
 * Returns the context node.
 */
extern (D) auto xmlXPathGetContextNode(T)(auto ref T ctxt)
{
    return ctxt.context.node;
}

int xmlXPathPopBoolean(xmlXPathParserContextPtr ctxt);
double xmlXPathPopNumber(xmlXPathParserContextPtr ctxt);
xmlChar* xmlXPathPopString(xmlXPathParserContextPtr ctxt);
xmlNodeSetPtr xmlXPathPopNodeSet(xmlXPathParserContextPtr ctxt);
void* xmlXPathPopExternal(xmlXPathParserContextPtr ctxt);

/**
 * xmlXPathReturnBoolean:
 * @ctxt:  an XPath parser context
 * @val:  a boolean
 *
 * Pushes the boolean @val on the context stack.
 */
extern (D) auto xmlXPathReturnBoolean(T0, T1)(auto ref T0 ctxt, auto ref T1 val)
{
    return valuePush(ctxt, xmlXPathNewBoolean(val));
}

/**
 * xmlXPathReturnTrue:
 * @ctxt:  an XPath parser context
 *
 * Pushes true on the context stack.
 */
extern (D) auto xmlXPathReturnTrue(T)(auto ref T ctxt)
{
    return xmlXPathReturnBoolean(ctxt, 1);
}

/**
 * xmlXPathReturnFalse:
 * @ctxt:  an XPath parser context
 *
 * Pushes false on the context stack.
 */
extern (D) auto xmlXPathReturnFalse(T)(auto ref T ctxt)
{
    return xmlXPathReturnBoolean(ctxt, 0);
}

/**
 * xmlXPathReturnNumber:
 * @ctxt:  an XPath parser context
 * @val:  a double
 *
 * Pushes the double @val on the context stack.
 */
extern (D) auto xmlXPathReturnNumber(T0, T1)(auto ref T0 ctxt, auto ref T1 val)
{
    return valuePush(ctxt, xmlXPathNewFloat(val));
}

/**
 * xmlXPathReturnString:
 * @ctxt:  an XPath parser context
 * @str:  a string
 *
 * Pushes the string @str on the context stack.
 */
extern (D) auto xmlXPathReturnString(T0, T1)(auto ref T0 ctxt, auto ref T1 str)
{
    return valuePush(ctxt, xmlXPathWrapString(str));
}

/**
 * xmlXPathReturnEmptyString:
 * @ctxt:  an XPath parser context
 *
 * Pushes an empty string on the stack.
 */
extern (D) auto xmlXPathReturnEmptyString(T)(auto ref T ctxt)
{
    return valuePush(ctxt, xmlXPathNewCString(""));
}

/**
 * xmlXPathReturnNodeSet:
 * @ctxt:  an XPath parser context
 * @ns:  a node-set
 *
 * Pushes the node-set @ns on the context stack.
 */
extern (D) auto xmlXPathReturnNodeSet(T0, T1)(auto ref T0 ctxt, auto ref T1 ns)
{
    return valuePush(ctxt, xmlXPathWrapNodeSet(ns));
}

/**
 * xmlXPathReturnEmptyNodeSet:
 * @ctxt:  an XPath parser context
 *
 * Pushes an empty node-set on the context stack.
 */
extern (D) auto xmlXPathReturnEmptyNodeSet(T)(auto ref T ctxt)
{
    return valuePush(ctxt, xmlXPathNewNodeSet(NULL));
}

/**
 * xmlXPathReturnExternal:
 * @ctxt:  an XPath parser context
 * @val:  user data
 *
 * Pushes user data on the context stack.
 */
extern (D) auto xmlXPathReturnExternal(T0, T1)(auto ref T0 ctxt, auto ref T1 val)
{
    return valuePush(ctxt, xmlXPathWrapExternal(val));
}

/**
 * xmlXPathStackIsNodeSet:
 * @ctxt: an XPath parser context
 *
 * Check if the current value on the XPath stack is a node set or
 * an XSLT value tree.
 *
 * Returns true if the current object on the stack is a node-set.
 */
extern (D) auto xmlXPathStackIsNodeSet(T)(auto ref T ctxt)
{
    return (ctxt.value != NULL) && ((ctxt.value.type == .XPATH_NODESET) || (ctxt.value.type == .XPATH_XSLT_TREE));
}

/**
 * xmlXPathStackIsExternal:
 * @ctxt: an XPath parser context
 *
 * Checks if the current value on the XPath stack is an external
 * object.
 *
 * Returns true if the current object on the stack is an external
 * object.
 */
extern (D) auto xmlXPathStackIsExternal(T)(auto ref T ctxt)
{
    return (ctxt.value != NULL) && (ctxt.value.type == .XPATH_USERS);
}

/**
 * xmlXPathEmptyNodeSet:
 * @ns:  a node-set
 *
 * Empties a node-set.
 */

/**
 * CHECK_ERROR:
 *
 * Macro to return from the function if an XPath error was detected.
 */

/**
 * CHECK_ERROR0:
 *
 * Macro to return 0 from the function if an XPath error was detected.
 */

/**
 * XP_ERROR:
 * @X:  the error code
 *
 * Macro to raise an XPath error and return.
 */

/**
 * XP_ERROR0:
 * @X:  the error code
 *
 * Macro to raise an XPath error and return 0.
 */

/**
 * CHECK_TYPE:
 * @typeval:  the XPath type
 *
 * Macro to check that the value on top of the XPath stack is of a given
 * type.
 */

/**
 * CHECK_TYPE0:
 * @typeval:  the XPath type
 *
 * Macro to check that the value on top of the XPath stack is of a given
 * type. Return(0) in case of failure
 */

/**
 * CHECK_ARITY:
 * @x:  the number of expected args
 *
 * Macro to check that the number of args passed to an XPath function matches.
 */

/**
 * CAST_TO_STRING:
 *
 * Macro to try to cast the value on the top of the XPath stack to a string.
 */

/**
 * CAST_TO_NUMBER:
 *
 * Macro to try to cast the value on the top of the XPath stack to a number.
 */

/**
 * CAST_TO_BOOLEAN:
 *
 * Macro to try to cast the value on the top of the XPath stack to a boolean.
 */

/*
 * Variable Lookup forwarding.
 */

void xmlXPathRegisterVariableLookup(
    xmlXPathContextPtr ctxt,
    xmlXPathVariableLookupFunc f,
    void* data);

/*
 * Function Lookup forwarding.
 */

void xmlXPathRegisterFuncLookup(
    xmlXPathContextPtr ctxt,
    xmlXPathFuncLookupFunc f,
    void* funcCtxt);

/*
 * Error reporting.
 */
void xmlXPatherror(
    xmlXPathParserContextPtr ctxt,
    const(char)* file,
    int line,
    int no);

void xmlXPathErr(xmlXPathParserContextPtr ctxt, int error);

/**
 * NodeSet handling.
 */
int xmlXPathNodeSetContains(xmlNodeSetPtr cur, xmlNodePtr val);
xmlNodeSetPtr xmlXPathDifference(xmlNodeSetPtr nodes1, xmlNodeSetPtr nodes2);
xmlNodeSetPtr xmlXPathIntersection(xmlNodeSetPtr nodes1, xmlNodeSetPtr nodes2);

xmlNodeSetPtr xmlXPathDistinctSorted(xmlNodeSetPtr nodes);
xmlNodeSetPtr xmlXPathDistinct(xmlNodeSetPtr nodes);

int xmlXPathHasSameNodes(xmlNodeSetPtr nodes1, xmlNodeSetPtr nodes2);

xmlNodeSetPtr xmlXPathNodeLeadingSorted(xmlNodeSetPtr nodes, xmlNodePtr node);
xmlNodeSetPtr xmlXPathLeadingSorted(xmlNodeSetPtr nodes1, xmlNodeSetPtr nodes2);
xmlNodeSetPtr xmlXPathNodeLeading(xmlNodeSetPtr nodes, xmlNodePtr node);
xmlNodeSetPtr xmlXPathLeading(xmlNodeSetPtr nodes1, xmlNodeSetPtr nodes2);

xmlNodeSetPtr xmlXPathNodeTrailingSorted(xmlNodeSetPtr nodes, xmlNodePtr node);
xmlNodeSetPtr xmlXPathTrailingSorted(
    xmlNodeSetPtr nodes1,
    xmlNodeSetPtr nodes2);
xmlNodeSetPtr xmlXPathNodeTrailing(xmlNodeSetPtr nodes, xmlNodePtr node);
xmlNodeSetPtr xmlXPathTrailing(xmlNodeSetPtr nodes1, xmlNodeSetPtr nodes2);

/**
 * Extending a context.
 */

int xmlXPathRegisterNs(
    xmlXPathContextPtr ctxt,
    const(xmlChar)* prefix,
    const(xmlChar)* ns_uri);
const(xmlChar)* xmlXPathNsLookup(
    xmlXPathContextPtr ctxt,
    const(xmlChar)* prefix);
void xmlXPathRegisteredNsCleanup(xmlXPathContextPtr ctxt);

int xmlXPathRegisterFunc(
    xmlXPathContextPtr ctxt,
    const(xmlChar)* name,
    xmlXPathFunction f);
int xmlXPathRegisterFuncNS(
    xmlXPathContextPtr ctxt,
    const(xmlChar)* name,
    const(xmlChar)* ns_uri,
    xmlXPathFunction f);
int xmlXPathRegisterVariable(
    xmlXPathContextPtr ctxt,
    const(xmlChar)* name,
    xmlXPathObjectPtr value);
int xmlXPathRegisterVariableNS(
    xmlXPathContextPtr ctxt,
    const(xmlChar)* name,
    const(xmlChar)* ns_uri,
    xmlXPathObjectPtr value);
xmlXPathFunction xmlXPathFunctionLookup(
    xmlXPathContextPtr ctxt,
    const(xmlChar)* name);
xmlXPathFunction xmlXPathFunctionLookupNS(
    xmlXPathContextPtr ctxt,
    const(xmlChar)* name,
    const(xmlChar)* ns_uri);
void xmlXPathRegisteredFuncsCleanup(xmlXPathContextPtr ctxt);
xmlXPathObjectPtr xmlXPathVariableLookup(
    xmlXPathContextPtr ctxt,
    const(xmlChar)* name);
xmlXPathObjectPtr xmlXPathVariableLookupNS(
    xmlXPathContextPtr ctxt,
    const(xmlChar)* name,
    const(xmlChar)* ns_uri);
void xmlXPathRegisteredVariablesCleanup(xmlXPathContextPtr ctxt);

/**
 * Utilities to extend XPath.
 */
xmlXPathParserContextPtr xmlXPathNewParserContext(
    const(xmlChar)* str,
    xmlXPathContextPtr ctxt);
void xmlXPathFreeParserContext(xmlXPathParserContextPtr ctxt);

/* TODO: remap to xmlXPathValuePop and Push. */
xmlXPathObjectPtr valuePop(xmlXPathParserContextPtr ctxt);
int valuePush(xmlXPathParserContextPtr ctxt, xmlXPathObjectPtr value);

xmlXPathObjectPtr xmlXPathNewString(const(xmlChar)* val);
xmlXPathObjectPtr xmlXPathNewCString(const(char)* val);
xmlXPathObjectPtr xmlXPathWrapString(xmlChar* val);
xmlXPathObjectPtr xmlXPathWrapCString(char* val);
xmlXPathObjectPtr xmlXPathNewFloat(double val);
xmlXPathObjectPtr xmlXPathNewBoolean(int val);
xmlXPathObjectPtr xmlXPathNewNodeSet(xmlNodePtr val);
xmlXPathObjectPtr xmlXPathNewValueTree(xmlNodePtr val);
int xmlXPathNodeSetAdd(xmlNodeSetPtr cur, xmlNodePtr val);
int xmlXPathNodeSetAddUnique(xmlNodeSetPtr cur, xmlNodePtr val);
int xmlXPathNodeSetAddNs(xmlNodeSetPtr cur, xmlNodePtr node, xmlNsPtr ns);
void xmlXPathNodeSetSort(xmlNodeSetPtr set);

void xmlXPathRoot(xmlXPathParserContextPtr ctxt);
void xmlXPathEvalExpr(xmlXPathParserContextPtr ctxt);
xmlChar* xmlXPathParseName(xmlXPathParserContextPtr ctxt);
xmlChar* xmlXPathParseNCName(xmlXPathParserContextPtr ctxt);

/*
 * Existing functions.
 */
double xmlXPathStringEvalNumber(const(xmlChar)* str);
int xmlXPathEvaluatePredicateResult(
    xmlXPathParserContextPtr ctxt,
    xmlXPathObjectPtr res);
void xmlXPathRegisterAllFunctions(xmlXPathContextPtr ctxt);
xmlNodeSetPtr xmlXPathNodeSetMerge(xmlNodeSetPtr val1, xmlNodeSetPtr val2);
void xmlXPathNodeSetDel(xmlNodeSetPtr cur, xmlNodePtr val);
void xmlXPathNodeSetRemove(xmlNodeSetPtr cur, int val);
xmlXPathObjectPtr xmlXPathNewNodeSetList(xmlNodeSetPtr val);
xmlXPathObjectPtr xmlXPathWrapNodeSet(xmlNodeSetPtr val);
xmlXPathObjectPtr xmlXPathWrapExternal(void* val);

int xmlXPathEqualValues(xmlXPathParserContextPtr ctxt);
int xmlXPathNotEqualValues(xmlXPathParserContextPtr ctxt);
int xmlXPathCompareValues(xmlXPathParserContextPtr ctxt, int inf, int strict);
void xmlXPathValueFlipSign(xmlXPathParserContextPtr ctxt);
void xmlXPathAddValues(xmlXPathParserContextPtr ctxt);
void xmlXPathSubValues(xmlXPathParserContextPtr ctxt);
void xmlXPathMultValues(xmlXPathParserContextPtr ctxt);
void xmlXPathDivValues(xmlXPathParserContextPtr ctxt);
void xmlXPathModValues(xmlXPathParserContextPtr ctxt);

int xmlXPathIsNodeType(const(xmlChar)* name);

/*
 * Some of the axis navigation routines.
 */
xmlNodePtr xmlXPathNextSelf(xmlXPathParserContextPtr ctxt, xmlNodePtr cur);
xmlNodePtr xmlXPathNextChild(xmlXPathParserContextPtr ctxt, xmlNodePtr cur);
xmlNodePtr xmlXPathNextDescendant(
    xmlXPathParserContextPtr ctxt,
    xmlNodePtr cur);
xmlNodePtr xmlXPathNextDescendantOrSelf(
    xmlXPathParserContextPtr ctxt,
    xmlNodePtr cur);
xmlNodePtr xmlXPathNextParent(xmlXPathParserContextPtr ctxt, xmlNodePtr cur);
xmlNodePtr xmlXPathNextAncestorOrSelf(
    xmlXPathParserContextPtr ctxt,
    xmlNodePtr cur);
xmlNodePtr xmlXPathNextFollowingSibling(
    xmlXPathParserContextPtr ctxt,
    xmlNodePtr cur);
xmlNodePtr xmlXPathNextFollowing(xmlXPathParserContextPtr ctxt, xmlNodePtr cur);
xmlNodePtr xmlXPathNextNamespace(xmlXPathParserContextPtr ctxt, xmlNodePtr cur);
xmlNodePtr xmlXPathNextAttribute(xmlXPathParserContextPtr ctxt, xmlNodePtr cur);
xmlNodePtr xmlXPathNextPreceding(xmlXPathParserContextPtr ctxt, xmlNodePtr cur);
xmlNodePtr xmlXPathNextAncestor(xmlXPathParserContextPtr ctxt, xmlNodePtr cur);
xmlNodePtr xmlXPathNextPrecedingSibling(
    xmlXPathParserContextPtr ctxt,
    xmlNodePtr cur);
/*
 * The official core of XPath functions.
 */
void xmlXPathLastFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathPositionFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathCountFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathIdFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathLocalNameFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathNamespaceURIFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathStringFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathStringLengthFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathConcatFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathContainsFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathStartsWithFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathSubstringFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathSubstringBeforeFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathSubstringAfterFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathNormalizeFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathTranslateFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathNotFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathTrueFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathFalseFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathLangFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathNumberFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathSumFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathFloorFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathCeilingFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathRoundFunction(xmlXPathParserContextPtr ctxt, int nargs);
void xmlXPathBooleanFunction(xmlXPathParserContextPtr ctxt, int nargs);

/**
 * Really internal functions
 */
void xmlXPathNodeSetFreeNs(xmlNsPtr ns);

/* LIBXML_XPATH_ENABLED */
/* ! __XML_XPATH_INTERNALS_H__ */
