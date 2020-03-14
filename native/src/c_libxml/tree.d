module c_libxml.tree;

import c_libxml.dict;
import c_libxml.entities;
import c_libxml.parser;
import c_libxml.xmlIO;
import c_libxml.xmlregexp;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/*
 * Summary: interfaces for tree manipulation
 * Description: this module describes the structures found in an tree resulting
 *              from an XML or HTML parsing, as well as the API provided for
 *              various processing on that tree
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

import core.stdc.config;
import core.stdc.stdio;

extern (C) nothrow @system:

/*
 * Some of the basic types pointer to structures:
 */
/* xmlIO.h */
alias xmlParserInputBuffer = _xmlParserInputBuffer;
alias xmlParserInputBufferPtr = _xmlParserInputBuffer*;

static if (!is(_xmlOutputBuffer))
    struct _xmlOutputBuffer;
alias xmlOutputBuffer = _xmlOutputBuffer;
alias xmlOutputBufferPtr = _xmlOutputBuffer*;

/* parser.h */
alias xmlParserInput = _xmlParserInput;
alias xmlParserInputPtr = _xmlParserInput*;

alias xmlParserCtxt = _xmlParserCtxt;
alias xmlParserCtxtPtr = _xmlParserCtxt*;

alias xmlSAXLocator = _xmlSAXLocator;
alias xmlSAXLocatorPtr = _xmlSAXLocator*;

alias xmlSAXHandler = _xmlSAXHandler;
alias xmlSAXHandlerPtr = _xmlSAXHandler*;

/* entities.h */
alias xmlEntity = _xmlEntity;
alias xmlEntityPtr = _xmlEntity*;

/**
 * BASE_BUFFER_SIZE:
 *
 * default buffer size 4000.
 */
enum BASE_BUFFER_SIZE = 4096;

/**
 * LIBXML_NAMESPACE_DICT:
 *
 * Defines experimental behaviour:
 * 1) xmlNs gets an additional field @context (a xmlDoc)
 * 2) when creating a tree, xmlNs->href is stored in the dict of xmlDoc.
 */
/* #define LIBXML_NAMESPACE_DICT */

/**
 * xmlBufferAllocationScheme:
 *
 * A buffer allocation scheme can be defined to either match exactly the
 * need or double it's allocated size each time it is found too small.
 */

enum xmlBufferAllocationScheme
{
    doubleit = 0, /* double each time one need to grow */
    exact = 1, /* grow only to the minimal size */
    immutable_ = 2, /* immutable buffer */
    io = 3, /* special allocation scheme used for I/O */
    hybrid = 4, /* exact up to a threshold, and doubleit thereafter */
    bounded = 5 /* limit the upper size of the buffer */
}

/**
 * xmlBuffer:
 *
 * A buffer structure, this old construct is limited to 2GB and
 * is being deprecated, use API with xmlBuf instead
 */
alias xmlBuffer = _xmlBuffer;
alias xmlBufferPtr = _xmlBuffer*;

struct _xmlBuffer
{
    xmlChar* content; /* The buffer content UTF8 */
    uint use; /* The buffer size used */
    uint size; /* The buffer size */
    xmlBufferAllocationScheme alloc; /* The realloc method */
    xmlChar* contentIO; /* in IO mode we may have a different base */
}

/**
 * xmlBuf:
 *
 * A buffer structure, new one, the actual structure internals are not public
 */

struct _xmlBuf;
alias xmlBuf = _xmlBuf;

/**
 * xmlBufPtr:
 *
 * A pointer to a buffer structure, the actual structure internals are not
 * public
 */

alias xmlBufPtr = _xmlBuf*;

/*
 * A few public routines for xmlBuf. As those are expected to be used
 * mostly internally the bulk of the routines are internal in buf.h
 */
xmlChar* xmlBufContent(const(xmlBuf)* buf);
xmlChar* xmlBufEnd(xmlBufPtr buf);
size_t xmlBufUse(const xmlBufPtr buf);
size_t xmlBufShrink(xmlBufPtr buf, size_t len);

/*
 * LIBXML2_NEW_BUFFER:
 *
 * Macro used to express that the API use the new buffers for
 * xmlParserInputBuffer and xmlOutputBuffer. The change was
 * introduced in 2.9.0.
 */

/**
 * XML_XML_NAMESPACE:
 *
 * This is the namespace for the special xml: prefix predefined in the
 * XML Namespace specification.
 */
enum XML_XML_NAMESPACE = cast(const(xmlChar)*) "http://www.w3.org/XML/1998/namespace";

/**
 * XML_XML_ID:
 *
 * This is the name for the special xml:id attribute
 */
enum XML_XML_ID = cast(const(xmlChar)*) "xml:id";

/*
 * The different element types carried by an XML tree.
 *
 * NOTE: This is synchronized with DOM Level1 values
 *       See http://www.w3.org/TR/REC-DOM-Level-1/
 *
 * Actually this had diverged a bit, and now XML_DOCUMENT_TYPE_NODE should
 * be deprecated to use an XML_DTD_NODE.
 */
enum xmlElementType
{
    elementNode = 1,
    attributeNode = 2,
    textNode = 3,
    cdataSectionNode = 4,
    entityRefNode = 5,
    entityNode = 6,
    piNode = 7,
    commentNode = 8,
    documentNode = 9,
    documentTypeNode = 10,
    documentFragNode = 11,
    notationNode = 12,
    htmlDocumentNode = 13,
    dtdNode = 14,
    elementDecl = 15,
    attributeDecl = 16,
    entityDecl = 17,
    namespaceDecl = 18,
    xincludeStart = 19,
    xincludeEnd = 20
}

/**
 * xmlNotation:
 *
 * A DTD Notation definition.
 */

alias xmlNotation = _xmlNotation;
alias xmlNotationPtr = _xmlNotation*;

struct _xmlNotation
{
    const(xmlChar)* name; /* Notation name */
    const(xmlChar)* PublicID; /* Public identifier, if any */
    const(xmlChar)* SystemID; /* System identifier, if any */
}

/**
 * xmlAttributeType:
 *
 * A DTD Attribute type definition.
 */

enum xmlAttributeType
{
    cdata = 1,
    id = 2,
    idref = 3,
    idrefs = 4,
    entity = 5,
    entities = 6,
    nmtoken = 7,
    nmtokens = 8,
    enumeration = 9,
    notation = 10
}

/**
 * xmlAttributeDefault:
 *
 * A DTD Attribute default definition.
 */

enum xmlAttributeDefault
{
    none = 1,
    required = 2,
    implied = 3,
    fixed = 4
}

/**
 * xmlEnumeration:
 *
 * List structure used when there is an enumeration in DTDs.
 */

alias xmlEnumeration = _xmlEnumeration;
alias xmlEnumerationPtr = _xmlEnumeration*;

struct _xmlEnumeration
{
    _xmlEnumeration* next; /* next one */
    const(xmlChar)* name; /* Enumeration name */
}

/**
 * xmlAttribute:
 *
 * An Attribute declaration in a DTD.
 */

alias xmlAttribute = _xmlAttribute;
alias xmlAttributePtr = _xmlAttribute*;

struct _xmlAttribute
{
    void* _private; /* application data */
    xmlElementType type; /* XML_ATTRIBUTE_DECL, must be second ! */
    const(xmlChar)* name; /* Attribute name */
    _xmlNode* children; /* NULL */
    _xmlNode* last; /* NULL */
    _xmlDtd* parent; /* -> DTD */
    _xmlNode* next; /* next sibling link  */
    _xmlNode* prev; /* previous sibling link  */
    _xmlDoc* doc; /* the containing document */

    _xmlAttribute* nexth; /* next in hash table */
    xmlAttributeType atype; /* The attribute type */
    xmlAttributeDefault def; /* the default */
    const(xmlChar)* defaultValue; /* or the default value */
    xmlEnumerationPtr tree; /* or the enumeration tree if any */
    const(xmlChar)* prefix; /* the namespace prefix if any */
    const(xmlChar)* elem; /* Element holding the attribute */
}

/**
 * xmlElementContentType:
 *
 * Possible definitions of element content types.
 */
enum xmlElementContentType
{
    pcdata = 1,
    element = 2,
    seq = 3,
    or = 4
}

/**
 * xmlElementContentOccur:
 *
 * Possible definitions of element content occurrences.
 */
enum xmlElementContentOccur
{
    once = 1,
    opt = 2,
    mult = 3,
    plus = 4
}

/**
 * xmlElementContent:
 *
 * An XML Element content as stored after parsing an element definition
 * in a DTD.
 */

alias xmlElementContent = _xmlElementContent;
alias xmlElementContentPtr = _xmlElementContent*;

struct _xmlElementContent
{
    xmlElementContentType type; /* PCDATA, ELEMENT, SEQ or OR */
    xmlElementContentOccur ocur; /* ONCE, OPT, MULT or PLUS */
    const(xmlChar)* name; /* Element name */
    _xmlElementContent* c1; /* first child */
    _xmlElementContent* c2; /* second child */
    _xmlElementContent* parent; /* parent */
    const(xmlChar)* prefix; /* Namespace prefix */
}

/**
 * xmlElementTypeVal:
 *
 * The different possibilities for an element content type.
 */

enum xmlElementTypeVal
{
    undefined = 0,
    empty = 1,
    any = 2,
    mixed = 3,
    element = 4
}

/**
 * xmlElement:
 *
 * An XML Element declaration from a DTD.
 */

alias xmlElement = _xmlElement;
alias xmlElementPtr = _xmlElement*;

struct _xmlElement
{
    void* _private; /* application data */
    xmlElementType type; /* XML_ELEMENT_DECL, must be second ! */
    const(xmlChar)* name; /* Element name */
    _xmlNode* children; /* NULL */
    _xmlNode* last; /* NULL */
    _xmlDtd* parent; /* -> DTD */
    _xmlNode* next; /* next sibling link  */
    _xmlNode* prev; /* previous sibling link  */
    _xmlDoc* doc; /* the containing document */

    xmlElementTypeVal etype; /* The type */
    xmlElementContentPtr content; /* the allowed element content */
    xmlAttributePtr attributes; /* List of the declared attributes */
    const(xmlChar)* prefix; /* the namespace prefix if any */

    xmlRegexpPtr contModel; /* the validating regexp */
}

/**
 * XML_LOCAL_NAMESPACE:
 *
 * A namespace declaration node.
 */
enum XML_LOCAL_NAMESPACE = xmlElementType.namespaceDecl;
alias xmlNsType = xmlElementType;

/**
 * xmlNs:
 *
 * An XML namespace.
 * Note that prefix == NULL is valid, it defines the default namespace
 * within the subtree (until overridden).
 *
 * xmlNsType is unified with xmlElementType.
 */

alias xmlNs = _xmlNs;
alias xmlNsPtr = _xmlNs*;

struct _xmlNs
{
    _xmlNs* next; /* next Ns link for this node  */
    xmlNsType type; /* global or local */
    const(xmlChar)* href; /* URL for the namespace */
    const(xmlChar)* prefix; /* prefix for the namespace */
    void* _private; /* application data */
    _xmlDoc* context; /* normally an xmlDoc */
}

/**
 * xmlDtd:
 *
 * An XML DTD, as defined by <!DOCTYPE ... There is actually one for
 * the internal subset and for the external subset.
 */
alias xmlDtd = _xmlDtd;
alias xmlDtdPtr = _xmlDtd*;

struct _xmlDtd
{
    void* _private; /* application data */
    xmlElementType type; /* XML_DTD_NODE, must be second ! */
    const(xmlChar)* name; /* Name of the DTD */
    _xmlNode* children; /* the value of the property link */
    _xmlNode* last; /* last child link */
    _xmlDoc* parent; /* child->parent link */
    _xmlNode* next; /* next sibling link  */
    _xmlNode* prev; /* previous sibling link  */
    _xmlDoc* doc; /* the containing document */

    /* End of common part */
    void* notations; /* Hash table for notations if any */
    void* elements; /* Hash table for elements if any */
    void* attributes; /* Hash table for attributes if any */
    void* entities; /* Hash table for entities if any */
    const(xmlChar)* ExternalID; /* External identifier for PUBLIC DTD */
    const(xmlChar)* SystemID; /* URI for a SYSTEM or PUBLIC DTD */
    void* pentities; /* Hash table for param entities if any */
}

/**
 * xmlAttr:
 *
 * An attribute on an XML node.
 */
alias xmlAttr = _xmlAttr;
alias xmlAttrPtr = _xmlAttr*;

struct _xmlAttr
{
    void* _private; /* application data */
    xmlElementType type; /* XML_ATTRIBUTE_NODE, must be second ! */
    const(xmlChar)* name; /* the name of the property */
    _xmlNode* children; /* the value of the property */
    _xmlNode* last; /* NULL */
    _xmlNode* parent; /* child->parent link */
    _xmlAttr* next; /* next sibling link  */
    _xmlAttr* prev; /* previous sibling link  */
    _xmlDoc* doc; /* the containing document */
    xmlNs* ns; /* pointer to the associated namespace */
    xmlAttributeType atype; /* the attribute type if validating */
    void* psvi; /* for type/PSVI informations */
}

/**
 * xmlID:
 *
 * An XML ID instance.
 */

alias xmlID = _xmlID;
alias xmlIDPtr = _xmlID*;

struct _xmlID
{
    _xmlID* next; /* next ID */
    const(xmlChar)* value; /* The ID name */
    xmlAttrPtr attr; /* The attribute holding it */
    const(xmlChar)* name; /* The attribute if attr is not available */
    int lineno; /* The line number if attr is not available */
    _xmlDoc* doc; /* The document holding the ID */
}

/**
 * xmlRef:
 *
 * An XML IDREF instance.
 */

alias xmlRef = _xmlRef;
alias xmlRefPtr = _xmlRef*;

struct _xmlRef
{
    _xmlRef* next; /* next Ref */
    const(xmlChar)* value; /* The Ref name */
    xmlAttrPtr attr; /* The attribute holding it */
    const(xmlChar)* name; /* The attribute if attr is not available */
    int lineno; /* The line number if attr is not available */
}

/**
 * xmlNode:
 *
 * A node in an XML tree.
 */
alias xmlNode = _xmlNode;
alias xmlNodePtr = _xmlNode*;

struct _xmlNode
{
    void* _private; /* application data */
    xmlElementType type; /* type number, must be second ! */
    const(xmlChar)* name; /* the name of the node, or the entity */
    _xmlNode* children; /* parent->childs link */
    _xmlNode* last; /* last child link */
    _xmlNode* parent; /* child->parent link */
    _xmlNode* next; /* next sibling link  */
    _xmlNode* prev; /* previous sibling link  */
    _xmlDoc* doc; /* the containing document */

    /* End of common part */
    xmlNs* ns; /* pointer to the associated namespace */
    xmlChar* content; /* the content */
    _xmlAttr* properties; /* properties list */
    xmlNs* nsDef; /* namespace definitions on this node */
    void* psvi; /* for type/PSVI informations */
    ushort line; /* line number */
    ushort extra; /* extra data for XPath/XSLT */
}

/**
 * XML_GET_CONTENT:
 *
 * Macro to extract the content pointer of a node.
 */
extern (D) auto XML_GET_CONTENT(T)(auto ref T n)
{
    return n.type == xmlElementType.elementNode ? NULL : n.content;
}

/**
 * XML_GET_LINE:
 *
 * Macro to extract the line number of an element node.
 */
extern (D) auto XML_GET_LINE(T)(auto ref T n)
{
    return xmlGetLineNo(n);
}

/**
 * xmlDocProperty
 *
 * Set of properties of the document as found by the parser
 * Some of them are linked to similarly named xmlParserOption
 */
enum xmlDocProperties
{
    wellformed = 1 << 0, /* document is XML well formed */
    nsvalid = 1 << 1, /* document is Namespace valid */
    old10 = 1 << 2, /* parsed with old XML-1.0 parser */
    dtdvalid = 1 << 3, /* DTD validation was successful */
    xinclude = 1 << 4, /* XInclude substitution was done */
    userbuilt = 1 << 5, /* Document was built using the API
                and not by parsing an instance */
    internal = 1 << 6, /* built for internal processing */
    html = 1 << 7 /* parsed or built HTML document */
}

/**
 * xmlDoc:
 *
 * An XML document.
 */
alias xmlDoc = _xmlDoc;
alias xmlDocPtr = _xmlDoc*;

struct _xmlDoc
{
    void* _private; /* application data */
    xmlElementType type; /* XML_DOCUMENT_NODE, must be second ! */
    char* name; /* name/filename/URI of the document */
    _xmlNode* children; /* the document tree */
    _xmlNode* last; /* last child link */
    _xmlNode* parent; /* child->parent link */
    _xmlNode* next; /* next sibling link  */
    _xmlNode* prev; /* previous sibling link  */
    _xmlDoc* doc; /* autoreference to itself */

    /* End of common part */
    int compression; /* level of zlib compression */
    int standalone; /* standalone document (no external refs)
                         1 if standalone="yes"
                         0 if standalone="no"
                        -1 if there is no XML declaration
                        -2 if there is an XML declaration, but no
                        standalone attribute was specified */
    _xmlDtd* intSubset; /* the document internal subset */
    _xmlDtd* extSubset; /* the document external subset */
    _xmlNs* oldNs; /* Global namespace, the old way */
    const(xmlChar)* version_; /* the XML version string */
    const(xmlChar)* encoding; /* external initial encoding, if any */
    void* ids; /* Hash table for ID attributes if any */
    void* refs; /* Hash table for IDREFs attributes if any */
    const(xmlChar)* URL; /* The URI for that document */
    int charset; /* Internal flag for charset handling,
                       actually an xmlCharEncoding */
    _xmlDict* dict; /* dict used to allocate names or NULL */
    void* psvi; /* for type/PSVI informations */
    int parseFlags; /* set of xmlParserOption used to parse the
                       document */
    int properties; /* set of xmlDocProperties for this document
                       set at the end of parsing */
}

alias xmlDOMWrapCtxt = _xmlDOMWrapCtxt;
alias xmlDOMWrapCtxtPtr = _xmlDOMWrapCtxt*;

/**
 * xmlDOMWrapAcquireNsFunction:
 * @ctxt:  a DOM wrapper context
 * @node:  the context node (element or attribute)
 * @nsName:  the requested namespace name
 * @nsPrefix:  the requested namespace prefix
 *
 * A function called to acquire namespaces (xmlNs) from the wrapper.
 *
 * Returns an xmlNsPtr or NULL in case of an error.
 */
alias xmlDOMWrapAcquireNsFunction = _xmlNs* function(
    xmlDOMWrapCtxtPtr ctxt,
    xmlNodePtr node,
    const(xmlChar)* nsName,
    const(xmlChar)* nsPrefix);

/**
 * xmlDOMWrapCtxt:
 *
 * Context for DOM wrapper-operations.
 */
struct _xmlDOMWrapCtxt
{
    void* _private;
    /*
    * The type of this context, just in case we need specialized
    * contexts in the future.
    */
    int type;
    /*
    * Internal namespace map used for various operations.
    */
    void* namespaceMap;
    /*
    * Use this one to acquire an xmlNsPtr intended for node->ns.
    * (Note that this is not intended for elem->nsDef).
    */
    xmlDOMWrapAcquireNsFunction getNsForNodeFunc;
}

/**
 * xmlChildrenNode:
 *
 * Macro for compatibility naming layer with libxml1. Maps
 * to "children."
 */

/**
 * xmlRootNode:
 *
 * Macro for compatibility naming layer with libxml1. Maps
 * to "children".
 */

/*
 * Variables.
 */

/*
 * Some helper functions
 */

int xmlValidateNCName(const(xmlChar)* value, int space);

int xmlValidateQName(const(xmlChar)* value, int space);
int xmlValidateName(const(xmlChar)* value, int space);
int xmlValidateNMToken(const(xmlChar)* value, int space);

xmlChar* xmlBuildQName(
    const(xmlChar)* ncname,
    const(xmlChar)* prefix,
    xmlChar* memory,
    int len);
xmlChar* xmlSplitQName2(const(xmlChar)* name, xmlChar** prefix);
const(xmlChar)* xmlSplitQName3(const(xmlChar)* name, int* len);

/*
 * Handling Buffers, the old ones see @xmlBuf for the new ones.
 */

void xmlSetBufferAllocationScheme(xmlBufferAllocationScheme scheme);
xmlBufferAllocationScheme xmlGetBufferAllocationScheme();

xmlBufferPtr xmlBufferCreate();
xmlBufferPtr xmlBufferCreateSize(size_t size);
xmlBufferPtr xmlBufferCreateStatic(void* mem, size_t size);
int xmlBufferResize(xmlBufferPtr buf, uint size);
void xmlBufferFree(xmlBufferPtr buf);
int xmlBufferDump(FILE* file, xmlBufferPtr buf);
int xmlBufferAdd(xmlBufferPtr buf, const(xmlChar)* str, int len);
int xmlBufferAddHead(xmlBufferPtr buf, const(xmlChar)* str, int len);
int xmlBufferCat(xmlBufferPtr buf, const(xmlChar)* str);
int xmlBufferCCat(xmlBufferPtr buf, const(char)* str);
int xmlBufferShrink(xmlBufferPtr buf, uint len);
int xmlBufferGrow(xmlBufferPtr buf, uint len);
void xmlBufferEmpty(xmlBufferPtr buf);
const(xmlChar)* xmlBufferContent(const(xmlBuffer)* buf);
xmlChar* xmlBufferDetach(xmlBufferPtr buf);
void xmlBufferSetAllocationScheme(
    xmlBufferPtr buf,
    xmlBufferAllocationScheme scheme);
int xmlBufferLength(const(xmlBuffer)* buf);

/*
 * Creating/freeing new structures.
 */
xmlDtdPtr xmlCreateIntSubset(
    xmlDocPtr doc,
    const(xmlChar)* name,
    const(xmlChar)* ExternalID,
    const(xmlChar)* SystemID);
xmlDtdPtr xmlNewDtd(
    xmlDocPtr doc,
    const(xmlChar)* name,
    const(xmlChar)* ExternalID,
    const(xmlChar)* SystemID);
xmlDtdPtr xmlGetIntSubset(const(xmlDoc)* doc);
void xmlFreeDtd(xmlDtdPtr cur);

/* LIBXML_LEGACY_ENABLED */
xmlNsPtr xmlNewNs(
    xmlNodePtr node,
    const(xmlChar)* href,
    const(xmlChar)* prefix);
void xmlFreeNs(xmlNsPtr cur);
void xmlFreeNsList(xmlNsPtr cur);
xmlDocPtr xmlNewDoc(const(xmlChar)* version_);
void xmlFreeDoc(xmlDocPtr cur);
xmlAttrPtr xmlNewDocProp(
    xmlDocPtr doc,
    const(xmlChar)* name,
    const(xmlChar)* value);
xmlAttrPtr xmlNewProp(
    xmlNodePtr node,
    const(xmlChar)* name,
    const(xmlChar)* value);

xmlAttrPtr xmlNewNsProp(
    xmlNodePtr node,
    xmlNsPtr ns,
    const(xmlChar)* name,
    const(xmlChar)* value);
xmlAttrPtr xmlNewNsPropEatName(
    xmlNodePtr node,
    xmlNsPtr ns,
    xmlChar* name,
    const(xmlChar)* value);
void xmlFreePropList(xmlAttrPtr cur);
void xmlFreeProp(xmlAttrPtr cur);
xmlAttrPtr xmlCopyProp(xmlNodePtr target, xmlAttrPtr cur);
xmlAttrPtr xmlCopyPropList(xmlNodePtr target, xmlAttrPtr cur);
xmlDtdPtr xmlCopyDtd(xmlDtdPtr dtd);
/* LIBXML_TREE_ENABLED */
xmlDocPtr xmlCopyDoc(xmlDocPtr doc, int recursive);
/* defined(LIBXML_TREE_ENABLED) || defined(LIBXML_SCHEMAS_ENABLED) */
/*
 * Creating new nodes.
 */
xmlNodePtr xmlNewDocNode(
    xmlDocPtr doc,
    xmlNsPtr ns,
    const(xmlChar)* name,
    const(xmlChar)* content);
xmlNodePtr xmlNewDocNodeEatName(
    xmlDocPtr doc,
    xmlNsPtr ns,
    xmlChar* name,
    const(xmlChar)* content);
xmlNodePtr xmlNewNode(xmlNsPtr ns, const(xmlChar)* name);
xmlNodePtr xmlNewNodeEatName(xmlNsPtr ns, xmlChar* name);
xmlNodePtr xmlNewChild(
    xmlNodePtr parent,
    xmlNsPtr ns,
    const(xmlChar)* name,
    const(xmlChar)* content);

xmlNodePtr xmlNewDocText(const(xmlDoc)* doc, const(xmlChar)* content);
xmlNodePtr xmlNewText(const(xmlChar)* content);
xmlNodePtr xmlNewDocPI(
    xmlDocPtr doc,
    const(xmlChar)* name,
    const(xmlChar)* content);
xmlNodePtr xmlNewPI(const(xmlChar)* name, const(xmlChar)* content);
xmlNodePtr xmlNewDocTextLen(xmlDocPtr doc, const(xmlChar)* content, int len);
xmlNodePtr xmlNewTextLen(const(xmlChar)* content, int len);
xmlNodePtr xmlNewDocComment(xmlDocPtr doc, const(xmlChar)* content);
xmlNodePtr xmlNewComment(const(xmlChar)* content);
xmlNodePtr xmlNewCDataBlock(xmlDocPtr doc, const(xmlChar)* content, int len);
xmlNodePtr xmlNewCharRef(xmlDocPtr doc, const(xmlChar)* name);
xmlNodePtr xmlNewReference(const(xmlDoc)* doc, const(xmlChar)* name);
xmlNodePtr xmlCopyNode(xmlNodePtr node, int recursive);
xmlNodePtr xmlDocCopyNode(xmlNodePtr node, xmlDocPtr doc, int recursive);
xmlNodePtr xmlDocCopyNodeList(xmlDocPtr doc, xmlNodePtr node);
xmlNodePtr xmlCopyNodeList(xmlNodePtr node);
xmlNodePtr xmlNewTextChild(
    xmlNodePtr parent,
    xmlNsPtr ns,
    const(xmlChar)* name,
    const(xmlChar)* content);
xmlNodePtr xmlNewDocRawNode(
    xmlDocPtr doc,
    xmlNsPtr ns,
    const(xmlChar)* name,
    const(xmlChar)* content);
xmlNodePtr xmlNewDocFragment(xmlDocPtr doc);
/* LIBXML_TREE_ENABLED */

/*
 * Navigating.
 */
c_long xmlGetLineNo(const(xmlNode)* node);
xmlChar* xmlGetNodePath(const(xmlNode)* node);
/* defined(LIBXML_TREE_ENABLED) || defined(LIBXML_DEBUG_ENABLED) */
xmlNodePtr xmlDocGetRootElement(const(xmlDoc)* doc);
xmlNodePtr xmlGetLastChild(const(xmlNode)* parent);
int xmlNodeIsText(const(xmlNode)* node);
int xmlIsBlankNode(const(xmlNode)* node);

/*
 * Changing the structure.
 */
xmlNodePtr xmlDocSetRootElement(xmlDocPtr doc, xmlNodePtr root);
/* defined(LIBXML_TREE_ENABLED) || defined(LIBXML_WRITER_ENABLED) */
void xmlNodeSetName(xmlNodePtr cur, const(xmlChar)* name);
/* LIBXML_TREE_ENABLED */
xmlNodePtr xmlAddChild(xmlNodePtr parent, xmlNodePtr cur);
xmlNodePtr xmlAddChildList(xmlNodePtr parent, xmlNodePtr cur);
xmlNodePtr xmlReplaceNode(xmlNodePtr old, xmlNodePtr cur);
/* defined(LIBXML_TREE_ENABLED) || defined(LIBXML_WRITER_ENABLED) */
xmlNodePtr xmlAddPrevSibling(xmlNodePtr cur, xmlNodePtr elem);
/* LIBXML_TREE_ENABLED || LIBXML_HTML_ENABLED || LIBXML_SCHEMAS_ENABLED */
xmlNodePtr xmlAddSibling(xmlNodePtr cur, xmlNodePtr elem);
xmlNodePtr xmlAddNextSibling(xmlNodePtr cur, xmlNodePtr elem);
void xmlUnlinkNode(xmlNodePtr cur);
xmlNodePtr xmlTextMerge(xmlNodePtr first, xmlNodePtr second);
int xmlTextConcat(xmlNodePtr node, const(xmlChar)* content, int len);
void xmlFreeNodeList(xmlNodePtr cur);
void xmlFreeNode(xmlNodePtr cur);
void xmlSetTreeDoc(xmlNodePtr tree, xmlDocPtr doc);
void xmlSetListDoc(xmlNodePtr list, xmlDocPtr doc);
/*
 * Namespaces.
 */
xmlNsPtr xmlSearchNs(xmlDocPtr doc, xmlNodePtr node, const(xmlChar)* nameSpace);
xmlNsPtr xmlSearchNsByHref(
    xmlDocPtr doc,
    xmlNodePtr node,
    const(xmlChar)* href);
xmlNsPtr* xmlGetNsList(const(xmlDoc)* doc, const(xmlNode)* node);
/* defined(LIBXML_TREE_ENABLED) || defined(LIBXML_XPATH_ENABLED) */

void xmlSetNs(xmlNodePtr node, xmlNsPtr ns);
xmlNsPtr xmlCopyNamespace(xmlNsPtr cur);
xmlNsPtr xmlCopyNamespaceList(xmlNsPtr cur);

/*
 * Changing the content.
 */
xmlAttrPtr xmlSetProp(
    xmlNodePtr node,
    const(xmlChar)* name,
    const(xmlChar)* value);
xmlAttrPtr xmlSetNsProp(
    xmlNodePtr node,
    xmlNsPtr ns,
    const(xmlChar)* name,
    const(xmlChar)* value);
/* defined(LIBXML_TREE_ENABLED) || defined(LIBXML_XINCLUDE_ENABLED) || \
      defined(LIBXML_SCHEMAS_ENABLED) || defined(LIBXML_HTML_ENABLED) */
xmlChar* xmlGetNoNsProp(const(xmlNode)* node, const(xmlChar)* name);
xmlChar* xmlGetProp(const(xmlNode)* node, const(xmlChar)* name);
xmlAttrPtr xmlHasProp(const(xmlNode)* node, const(xmlChar)* name);
xmlAttrPtr xmlHasNsProp(
    const(xmlNode)* node,
    const(xmlChar)* name,
    const(xmlChar)* nameSpace);
xmlChar* xmlGetNsProp(
    const(xmlNode)* node,
    const(xmlChar)* name,
    const(xmlChar)* nameSpace);
xmlNodePtr xmlStringGetNodeList(const(xmlDoc)* doc, const(xmlChar)* value);
xmlNodePtr xmlStringLenGetNodeList(
    const(xmlDoc)* doc,
    const(xmlChar)* value,
    int len);
xmlChar* xmlNodeListGetString(xmlDocPtr doc, const(xmlNode)* list, int inLine);
xmlChar* xmlNodeListGetRawString(
    const(xmlDoc)* doc,
    const(xmlNode)* list,
    int inLine);
/* LIBXML_TREE_ENABLED */
void xmlNodeSetContent(xmlNodePtr cur, const(xmlChar)* content);
void xmlNodeSetContentLen(xmlNodePtr cur, const(xmlChar)* content, int len);
/* LIBXML_TREE_ENABLED */
void xmlNodeAddContent(xmlNodePtr cur, const(xmlChar)* content);
void xmlNodeAddContentLen(xmlNodePtr cur, const(xmlChar)* content, int len);
xmlChar* xmlNodeGetContent(const(xmlNode)* cur);

int xmlNodeBufGetContent(xmlBufferPtr buffer, const(xmlNode)* cur);
int xmlBufGetNodeContent(xmlBufPtr buf, const(xmlNode)* cur);

xmlChar* xmlNodeGetLang(const(xmlNode)* cur);
int xmlNodeGetSpacePreserve(const(xmlNode)* cur);
void xmlNodeSetLang(xmlNodePtr cur, const(xmlChar)* lang);
void xmlNodeSetSpacePreserve(xmlNodePtr cur, int val);
/* LIBXML_TREE_ENABLED */
xmlChar* xmlNodeGetBase(const(xmlDoc)* doc, const(xmlNode)* cur);
void xmlNodeSetBase(xmlNodePtr cur, const(xmlChar)* uri);

/*
 * Removing content.
 */
int xmlRemoveProp(xmlAttrPtr cur);
int xmlUnsetNsProp(xmlNodePtr node, xmlNsPtr ns, const(xmlChar)* name);
int xmlUnsetProp(xmlNodePtr node, const(xmlChar)* name);
/* defined(LIBXML_TREE_ENABLED) || defined(LIBXML_SCHEMAS_ENABLED) */

/*
 * Internal, don't use.
 */
void xmlBufferWriteCHAR(xmlBufferPtr buf, const(xmlChar)* string);
void xmlBufferWriteChar(xmlBufferPtr buf, const(char)* string);
void xmlBufferWriteQuotedString(xmlBufferPtr buf, const(xmlChar)* string);

/* LIBXML_OUTPUT_ENABLED */

/*
 * Namespace handling.
 */
int xmlReconciliateNs(xmlDocPtr doc, xmlNodePtr tree);

/*
 * Saving.
 */

/* LIBXML_OUTPUT_ENABLED */
/*
 * XHTML
 */
int xmlIsXHTML(const(xmlChar)* systemID, const(xmlChar)* publicID);

/*
 * Compression.
 */
int xmlGetDocCompressMode(const(xmlDoc)* doc);
void xmlSetDocCompressMode(xmlDocPtr doc, int mode);
int xmlGetCompressMode();
void xmlSetCompressMode(int mode);

/*
* DOM-wrapper helper functions.
*/
xmlDOMWrapCtxtPtr xmlDOMWrapNewCtxt();
void xmlDOMWrapFreeCtxt(xmlDOMWrapCtxtPtr ctxt);
int xmlDOMWrapReconcileNamespaces(
    xmlDOMWrapCtxtPtr ctxt,
    xmlNodePtr elem,
    int options);
int xmlDOMWrapAdoptNode(
    xmlDOMWrapCtxtPtr ctxt,
    xmlDocPtr sourceDoc,
    xmlNodePtr node,
    xmlDocPtr destDoc,
    xmlNodePtr destParent,
    int options);
int xmlDOMWrapRemoveNode(
    xmlDOMWrapCtxtPtr ctxt,
    xmlDocPtr doc,
    xmlNodePtr node,
    int options);
int xmlDOMWrapCloneNode(
    xmlDOMWrapCtxtPtr ctxt,
    xmlDocPtr sourceDoc,
    xmlNodePtr node,
    xmlNodePtr* clonedNode,
    xmlDocPtr destDoc,
    xmlNodePtr destParent,
    int deep,
    int options);

/*
 * 5 interfaces from DOM ElementTraversal, but different in entities
 * traversal.
 */
c_ulong xmlChildElementCount(xmlNodePtr parent);
xmlNodePtr xmlNextElementSibling(xmlNodePtr node);
xmlNodePtr xmlFirstElementChild(xmlNodePtr parent);
xmlNodePtr xmlLastElementChild(xmlNodePtr parent);
xmlNodePtr xmlPreviousElementSibling(xmlNodePtr node);

/* __XML_TREE_H__ */
