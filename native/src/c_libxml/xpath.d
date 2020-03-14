module c_libxml.xpath;

import c_libxml.dict;
import c_libxml.hash;
import c_libxml.tree;
import c_libxml.xmlerror;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/*
 * Summary: XML Path Language implementation
 * Description: API for the XML Path Language implementation
 *
 * XML Path Language implementation
 * XPath is a language for addressing parts of an XML document,
 * designed to be used by both XSLT and XPointer
 *     http://www.w3.org/TR/xpath
 *
 * Implements
 * W3C Recommendation 16 November 1999
 *     http://www.w3.org/TR/1999/REC-xpath-19991116
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

import core.stdc.config;
import core.stdc.stddef;

extern (C) nothrow @system:

/* LIBXML_XPATH_ENABLED */

/* LIBXML_XPATH_ENABLED or LIBXML_SCHEMAS_ENABLED */

alias xmlXPathContext = _xmlXPathContext;
alias xmlXPathContextPtr = _xmlXPathContext*;
alias xmlXPathParserContext = _xmlXPathParserContext;
alias xmlXPathParserContextPtr = _xmlXPathParserContext*;

/**
 * The set of XPath error codes.
 */

enum xmlXPathError
{
    athExpressionOk = 0,
    athNumberError = 1,
    athUnfinishedLiteralError = 2,
    athStartLiteralError = 3,
    athVariableRefError = 4,
    athUndefVariableError = 5,
    athInvalidPredicateError = 6,
    athExprError = 7,
    athUnclosedError = 8,
    athUnknownFuncError = 9,
    athInvalidOperand = 10,
    athInvalidType = 11,
    athInvalidArity = 12,
    athInvalidCtxtSize = 13,
    athInvalidCtxtPosition = 14,
    athMemoryError = 15,
    trSyntaxError = 16,
    trResourceError = 17,
    trSubResourceError = 18,
    athUndefPrefixError = 19,
    athEncodingError = 20,
    athInvalidCharError = 21,
    athInvalidCtxt = 22,
    athStackError = 23,
    athForbidVariableError = 24,
    athOpLimitExceeded = 25,
    athRecursionLimitExceeded = 26
}

/*
 * A node-set (an unordered collection of nodes without duplicates).
 */
alias xmlNodeSet = _xmlNodeSet;
alias xmlNodeSetPtr = _xmlNodeSet*;

struct _xmlNodeSet
{
    int nodeNr; /* number of nodes in the set */
    int nodeMax; /* size of the array as allocated */
    xmlNodePtr* nodeTab; /* array of nodes in no particular order */
    /* @@ with_ns to check whether namespace nodes should be looked at @@ */
}

/*
 * An expression is evaluated to yield an object, which
 * has one of the following four basic types:
 *   - node-set
 *   - boolean
 *   - number
 *   - string
 *
 * @@ XPointer will add more types !
 */

enum xmlXPathObjectType
{
    undefined = 0,
    nodeset = 1,
    boolean = 2,
    number = 3,
    string = 4,
    point = 5,
    range = 6,
    locationset = 7,
    users = 8,
    xsltTree = 9 /* An XSLT value tree, non modifiable */
}

alias xmlXPathObject = _xmlXPathObject;
alias xmlXPathObjectPtr = _xmlXPathObject*;

struct _xmlXPathObject
{
    xmlXPathObjectType type;
    xmlNodeSetPtr nodesetval;
    int boolval;
    double floatval;
    xmlChar* stringval;
    void* user;
    int index;
    void* user2;
    int index2;
}

/**
 * xmlXPathConvertFunc:
 * @obj:  an XPath object
 * @type:  the number of the target type
 *
 * A conversion function is associated to a type and used to cast
 * the new type to primitive values.
 *
 * Returns -1 in case of error, 0 otherwise
 */
alias xmlXPathConvertFunc = int function(xmlXPathObjectPtr obj, int type);

/*
 * Extra type: a name and a conversion function.
 */

alias xmlXPathType = _xmlXPathType;
alias xmlXPathTypePtr = _xmlXPathType*;

struct _xmlXPathType
{
    const(xmlChar)* name; /* the type name */
    xmlXPathConvertFunc func; /* the conversion function */
}

/*
 * Extra variable: a name and a value.
 */

alias xmlXPathVariable = _xmlXPathVariable;
alias xmlXPathVariablePtr = _xmlXPathVariable*;

struct _xmlXPathVariable
{
    const(xmlChar)* name; /* the variable name */
    xmlXPathObjectPtr value; /* the value */
}

/**
 * xmlXPathEvalFunc:
 * @ctxt: an XPath parser context
 * @nargs: the number of arguments passed to the function
 *
 * An XPath evaluation function, the parameters are on the XPath context stack.
 */

alias xmlXPathEvalFunc = void function(
    xmlXPathParserContextPtr ctxt,
    int nargs);

/*
 * Extra function: a name and a evaluation function.
 */

alias xmlXPathFunct = _xmlXPathFunct;
alias xmlXPathFuncPtr = _xmlXPathFunct*;

struct _xmlXPathFunct
{
    const(xmlChar)* name; /* the function name */
    xmlXPathEvalFunc func; /* the evaluation function */
}

/**
 * xmlXPathAxisFunc:
 * @ctxt:  the XPath interpreter context
 * @cur:  the previous node being explored on that axis
 *
 * An axis traversal function. To traverse an axis, the engine calls
 * the first time with cur == NULL and repeat until the function returns
 * NULL indicating the end of the axis traversal.
 *
 * Returns the next node in that axis or NULL if at the end of the axis.
 */

alias xmlXPathAxisFunc = _xmlXPathObject* function(
    xmlXPathParserContextPtr ctxt,
    xmlXPathObjectPtr cur);

/*
 * Extra axis: a name and an axis function.
 */

alias xmlXPathAxis = _xmlXPathAxis;
alias xmlXPathAxisPtr = _xmlXPathAxis*;

struct _xmlXPathAxis
{
    const(xmlChar)* name; /* the axis name */
    xmlXPathAxisFunc func; /* the search function */
}

/**
 * xmlXPathFunction:
 * @ctxt:  the XPath interprestation context
 * @nargs:  the number of arguments
 *
 * An XPath function.
 * The arguments (if any) are popped out from the context stack
 * and the result is pushed on the stack.
 */

alias xmlXPathFunction = void function(xmlXPathParserContextPtr ctxt, int nargs);

/*
 * Function and Variable Lookup.
 */

/**
 * xmlXPathVariableLookupFunc:
 * @ctxt:  an XPath context
 * @name:  name of the variable
 * @ns_uri:  the namespace name hosting this variable
 *
 * Prototype for callbacks used to plug variable lookup in the XPath
 * engine.
 *
 * Returns the XPath object value or NULL if not found.
 */
alias xmlXPathVariableLookupFunc = _xmlXPathObject* function(
    void* ctxt,
    const(xmlChar)* name,
    const(xmlChar)* ns_uri);

/**
 * xmlXPathFuncLookupFunc:
 * @ctxt:  an XPath context
 * @name:  name of the function
 * @ns_uri:  the namespace name hosting this function
 *
 * Prototype for callbacks used to plug function lookup in the XPath
 * engine.
 *
 * Returns the XPath function or NULL if not found.
 */
alias xmlXPathFuncLookupFunc = void function(void* ctxt, const(xmlChar)* name, const(xmlChar)* ns_uri) function(
    void* ctxt,
    const(xmlChar)* name,
    const(xmlChar)* ns_uri);

/**
 * xmlXPathFlags:
 * Flags for XPath engine compilation and runtime
 */
/**
 * XML_XPATH_CHECKNS:
 *
 * check namespaces at compilation
 */
enum XML_XPATH_CHECKNS = 1 << 0;
/**
 * XML_XPATH_NOVAR:
 *
 * forbid variables in expression
 */
enum XML_XPATH_NOVAR = 1 << 1;

/**
 * xmlXPathContext:
 *
 * Expression evaluation occurs with respect to a context.
 * he context consists of:
 *    - a node (the context node)
 *    - a node list (the context node list)
 *    - a set of variable bindings
 *    - a function library
 *    - the set of namespace declarations in scope for the expression
 * Following the switch to hash tables, this need to be trimmed up at
 * the next binary incompatible release.
 * The node may be modified when the context is passed to libxml2
 * for an XPath evaluation so you may need to initialize it again
 * before the next call.
 */

struct _xmlXPathContext
{
    xmlDocPtr doc; /* The current document */
    xmlNodePtr node; /* The current node */

    int nb_variables_unused; /* unused (hash table) */
    int max_variables_unused; /* unused (hash table) */
    xmlHashTablePtr varHash; /* Hash table of defined variables */

    int nb_types; /* number of defined types */
    int max_types; /* max number of types */
    xmlXPathTypePtr types; /* Array of defined types */

    int nb_funcs_unused; /* unused (hash table) */
    int max_funcs_unused; /* unused (hash table) */
    xmlHashTablePtr funcHash; /* Hash table of defined funcs */

    int nb_axis; /* number of defined axis */
    int max_axis; /* max number of axis */
    xmlXPathAxisPtr axis; /* Array of defined axis */

    /* the namespace nodes of the context node */
    xmlNsPtr* namespaces; /* Array of namespaces */
    int nsNr; /* number of namespace in scope */
    void* user; /* function to free */

    /* extra variables */
    int contextSize; /* the context size */
    int proximityPosition; /* the proximity position */

    /* extra stuff for XPointer */
    int xptr; /* is this an XPointer context? */
    xmlNodePtr here; /* for here() */
    xmlNodePtr origin; /* for origin() */

    /* the set of namespace declarations in scope for the expression */
    xmlHashTablePtr nsHash; /* The namespaces hash table */
    xmlXPathVariableLookupFunc varLookupFunc; /* variable lookup func */
    void* varLookupData; /* variable lookup data */

    /* Possibility to link in an extra item */
    void* extra; /* needed for XSLT */

    /* The function name and URI when calling a function */
    const(xmlChar)* function_;
    const(xmlChar)* functionURI;

    /* function lookup function and data */
    xmlXPathFuncLookupFunc funcLookupFunc; /* function lookup func */
    void* funcLookupData; /* function lookup data */

    /* temporary namespace lists kept for walking the namespace axis */
    xmlNsPtr* tmpNsList; /* Array of namespaces */
    int tmpNsNr; /* number of namespaces in scope */

    /* error reporting mechanism */
    void* userData; /* user specific data block */
    xmlStructuredErrorFunc error; /* the callback in case of errors */
    xmlError lastError; /* the last error */
    xmlNodePtr debugNode; /* the source node XSLT */

    /* dictionary */
    xmlDictPtr dict; /* dictionary if any */

    int flags; /* flags to control compilation */

    /* Cache for reusal of XPath objects */
    void* cache;

    /* Resource limits */
    c_ulong opLimit;
    c_ulong opCount;
    int depth;
    int maxDepth;
    int maxParserDepth;
}

/*
 * The structure of a compiled expression form is not public.
 */

struct _xmlXPathCompExpr;
alias xmlXPathCompExpr = _xmlXPathCompExpr;
alias xmlXPathCompExprPtr = _xmlXPathCompExpr*;

/**
 * xmlXPathParserContext:
 *
 * An XPath parser context. It contains pure parsing informations,
 * an xmlXPathContext, and the stack of objects.
 */
struct _xmlXPathParserContext
{
    const(xmlChar)* cur; /* the current char being parsed */
    const(xmlChar)* base; /* the full expression */

    int error; /* error code */

    xmlXPathContextPtr context; /* the evaluation context */
    xmlXPathObjectPtr value; /* the current value */
    int valueNr; /* number of values stacked */
    int valueMax; /* max number of values stacked */
    xmlXPathObjectPtr* valueTab; /* stack of values */

    xmlXPathCompExprPtr comp; /* the precompiled expression */
    int xptr; /* it this an XPointer expression */
    xmlNodePtr ancestor; /* used for walking preceding axis */

    int valueFrame; /* used to limit Pop on the stack */
}

/************************************************************************
 *                                                                      *
 *                      Public API                                      *
 *                                                                      *
 ************************************************************************/

/**
 * Objects and Nodesets handling
 */

extern __gshared double xmlXPathNAN;
extern __gshared double xmlXPathPINF;
extern __gshared double xmlXPathNINF;

/* These macros may later turn into functions */
/**
 * xmlXPathNodeSetGetLength:
 * @ns:  a node-set
 *
 * Implement a functionality similar to the DOM NodeList.length.
 *
 * Returns the number of nodes in the node-set.
 */
extern (D) auto xmlXPathNodeSetGetLength(T)(auto ref T ns)
{
    return ns ? ns.nodeNr : 0;
}

/**
 * xmlXPathNodeSetItem:
 * @ns:  a node-set
 * @index:  index of a node in the set
 *
 * Implements a functionality similar to the DOM NodeList.item().
 *
 * Returns the xmlNodePtr at the given @index in @ns or NULL if
 *         @index is out of range (0 to length-1)
 */
extern (D) auto xmlXPathNodeSetItem(T0, T1)(auto ref T0 ns, auto ref T1 index)
{
    return ((ns != NULL) && (index >= 0) && (index < ns.nodeNr)) ? ns.nodeTab[index] : NULL;
}

/**
 * xmlXPathNodeSetIsEmpty:
 * @ns: a node-set
 *
 * Checks whether @ns is empty or not.
 *
 * Returns %TRUE if @ns is an empty node-set.
 */
extern (D) auto xmlXPathNodeSetIsEmpty(T)(auto ref T ns)
{
    return (ns == NULL) || (ns.nodeNr == 0) || (ns.nodeTab == NULL);
}

void xmlXPathFreeObject(xmlXPathObjectPtr obj);
xmlNodeSetPtr xmlXPathNodeSetCreate(xmlNodePtr val);
void xmlXPathFreeNodeSetList(xmlXPathObjectPtr obj);
void xmlXPathFreeNodeSet(xmlNodeSetPtr obj);
xmlXPathObjectPtr xmlXPathObjectCopy(xmlXPathObjectPtr val);
int xmlXPathCmpNodes(xmlNodePtr node1, xmlNodePtr node2);
/**
 * Conversion functions to basic types.
 */
int xmlXPathCastNumberToBoolean(double val);
int xmlXPathCastStringToBoolean(const(xmlChar)* val);
int xmlXPathCastNodeSetToBoolean(xmlNodeSetPtr ns);
int xmlXPathCastToBoolean(xmlXPathObjectPtr val);

double xmlXPathCastBooleanToNumber(int val);
double xmlXPathCastStringToNumber(const(xmlChar)* val);
double xmlXPathCastNodeToNumber(xmlNodePtr node);
double xmlXPathCastNodeSetToNumber(xmlNodeSetPtr ns);
double xmlXPathCastToNumber(xmlXPathObjectPtr val);

xmlChar* xmlXPathCastBooleanToString(int val);
xmlChar* xmlXPathCastNumberToString(double val);
xmlChar* xmlXPathCastNodeToString(xmlNodePtr node);
xmlChar* xmlXPathCastNodeSetToString(xmlNodeSetPtr ns);
xmlChar* xmlXPathCastToString(xmlXPathObjectPtr val);

xmlXPathObjectPtr xmlXPathConvertBoolean(xmlXPathObjectPtr val);
xmlXPathObjectPtr xmlXPathConvertNumber(xmlXPathObjectPtr val);
xmlXPathObjectPtr xmlXPathConvertString(xmlXPathObjectPtr val);

/**
 * Context handling.
 */
xmlXPathContextPtr xmlXPathNewContext(xmlDocPtr doc);
void xmlXPathFreeContext(xmlXPathContextPtr ctxt);
int xmlXPathContextSetCache(
    xmlXPathContextPtr ctxt,
    int active,
    int value,
    int options);
/**
 * Evaluation functions.
 */
c_long xmlXPathOrderDocElems(xmlDocPtr doc);
int xmlXPathSetContextNode(xmlNodePtr node, xmlXPathContextPtr ctx);
xmlXPathObjectPtr xmlXPathNodeEval(
    xmlNodePtr node,
    const(xmlChar)* str,
    xmlXPathContextPtr ctx);
xmlXPathObjectPtr xmlXPathEval(const(xmlChar)* str, xmlXPathContextPtr ctx);
xmlXPathObjectPtr xmlXPathEvalExpression(
    const(xmlChar)* str,
    xmlXPathContextPtr ctxt);
int xmlXPathEvalPredicate(xmlXPathContextPtr ctxt, xmlXPathObjectPtr res);
/**
 * Separate compilation/evaluation entry points.
 */
xmlXPathCompExprPtr xmlXPathCompile(const(xmlChar)* str);
xmlXPathCompExprPtr xmlXPathCtxtCompile(
    xmlXPathContextPtr ctxt,
    const(xmlChar)* str);
xmlXPathObjectPtr xmlXPathCompiledEval(
    xmlXPathCompExprPtr comp,
    xmlXPathContextPtr ctx);
int xmlXPathCompiledEvalToBoolean(
    xmlXPathCompExprPtr comp,
    xmlXPathContextPtr ctxt);
void xmlXPathFreeCompExpr(xmlXPathCompExprPtr comp);
/* LIBXML_XPATH_ENABLED */
void xmlXPathInit();
int xmlXPathIsNaN(double val);
int xmlXPathIsInf(double val);

/* LIBXML_XPATH_ENABLED or LIBXML_SCHEMAS_ENABLED*/
/* ! __XML_XPATH_H__ */
