module c_libxml.parser;

import c_libxml.dict;
import c_libxml.encoding;
import c_libxml.entities;
import c_libxml.globals;
import c_libxml.hash;
import c_libxml.tree;
import c_libxml.valid;
import c_libxml.xmlerror;
import c_libxml.xmlIO;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/*
 * Summary: the core parser module
 * Description: Interfaces, constants and types related to the XML parser
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

import core.stdc.config;

extern (C) nothrow:

/**
 * XML_DEFAULT_VERSION:
 *
 * The default version of XML used: 1.0
 */
enum XML_DEFAULT_VERSION = "1.0";

/**
 * xmlParserInput:
 *
 * An xmlParserInput is an input flow for the XML processor.
 * Each entity parsed is associated an xmlParserInput (except the
 * few predefined ones). This is the case both for internal entities
 * - in which case the flow is already completely in memory - or
 * external entities - in which case we use the buf structure for
 * progressive reading and I18N conversions to the internal UTF-8 format.
 */

/**
 * xmlParserInputDeallocate:
 * @str:  the string to deallocate
 *
 * Callback for freeing some parser input allocations.
 */
alias xmlParserInputDeallocate = void function(xmlChar* str);

struct _xmlParserInput
{
    /* Input buffer */
    xmlParserInputBufferPtr buf; /* UTF-8 encoded buffer */

    const(char)* filename; /* The file analyzed, if any */
    const(char)* directory; /* the directory/base of the file */
    const(xmlChar)* base; /* Base of the array to parse */
    const(xmlChar)* cur; /* Current char being parsed */
    const(xmlChar)* end; /* end of the array to parse */
    int length; /* length if known */
    int line; /* Current line */
    int col; /* Current column */
    /*
     * NOTE: consumed is only tested for equality in the parser code,
     *       so even if there is an overflow this should not give troubles
     *       for parsing very large instances.
     */
    c_ulong consumed; /* How many xmlChars already consumed */
    xmlParserInputDeallocate free; /* function to deallocate the base */
    const(xmlChar)* encoding; /* the encoding string for entity */
    const(xmlChar)* version_; /* the version string for entity */
    int standalone; /* Was that entity marked standalone */
    int id; /* an unique identifier for the entity */
}

/**
 * xmlParserNodeInfo:
 *
 * The parser can be asked to collect Node informations, i.e. at what
 * place in the file they were detected.
 * NOTE: This is off by default and not very well tested.
 */
alias xmlParserNodeInfo = _xmlParserNodeInfo;
alias xmlParserNodeInfoPtr = _xmlParserNodeInfo*;

struct _xmlParserNodeInfo
{
    const(_xmlNode)* node;
    /* Position & line # that text that created the node begins & ends on */
    c_ulong begin_pos;
    c_ulong begin_line;
    c_ulong end_pos;
    c_ulong end_line;
}

alias xmlParserNodeInfoSeq = _xmlParserNodeInfoSeq;
alias xmlParserNodeInfoSeqPtr = _xmlParserNodeInfoSeq*;

struct _xmlParserNodeInfoSeq
{
    c_ulong maximum;
    c_ulong length;
    xmlParserNodeInfo* buffer;
}

/**
 * xmlParserInputState:
 *
 * The parser is now working also as a state based parser.
 * The recursive one use the state info for entities processing.
 */
enum xmlParserInputState
{
    eof = -1, /* nothing is to be parsed */
    start = 0, /* nothing has been parsed */
    misc = 1, /* Misc* before int subset */
    pi = 2, /* Within a processing instruction */
    dtd = 3, /* within some DTD content */
    prolog = 4, /* Misc* after internal subset */
    comment = 5, /* within a comment */
    startTag = 6, /* within a start tag */
    content = 7, /* within the content */
    cdataSection = 8, /* within a CDATA section */
    endTag = 9, /* within a closing tag */
    entityDecl = 10, /* within an entity declaration */
    entityValue = 11, /* within an entity value in a decl */
    attributeValue = 12, /* within an attribute value */
    systemLiteral = 13, /* within a SYSTEM value */
    epilog = 14, /* the Misc* after the last end tag */
    ignore = 15, /* within an IGNORED section */
    publicLiteral = 16 /* within a PUBLIC value */
}

/**
 * XML_DETECT_IDS:
 *
 * Bit in the loadsubset context field to tell to do ID/REFs lookups.
 * Use it to initialize xmlLoadExtDtdDefaultValue.
 */
enum XML_DETECT_IDS = 2;

/**
 * XML_COMPLETE_ATTRS:
 *
 * Bit in the loadsubset context field to tell to do complete the
 * elements attributes lists with the ones defaulted from the DTDs.
 * Use it to initialize xmlLoadExtDtdDefaultValue.
 */
enum XML_COMPLETE_ATTRS = 4;

/**
 * XML_SKIP_IDS:
 *
 * Bit in the loadsubset context field to tell to not do ID/REFs registration.
 * Used to initialize xmlLoadExtDtdDefaultValue in some special cases.
 */
enum XML_SKIP_IDS = 8;

/**
 * xmlParserMode:
 *
 * A parser can operate in various modes
 */
enum xmlParserMode
{
    unknown = 0,
    dom = 1,
    sax = 2,
    pushDom = 3,
    pushSax = 4,
    reader = 5
}

/**
 * xmlParserCtxt:
 *
 * The parser context.
 * NOTE This doesn't completely define the parser state, the (current ?)
 *      design of the parser uses recursive function calls since this allow
 *      and easy mapping from the production rules of the specification
 *      to the actual code. The drawback is that the actual function call
 *      also reflect the parser state. However most of the parsing routines
 *      takes as the only argument the parser context pointer, so migrating
 *      to a state based parser for progressive parsing shouldn't be too hard.
 */
struct _xmlParserCtxt
{
    _xmlSAXHandler* sax; /* The SAX handler */
    void* userData; /* For SAX interface only, used by DOM build */
    xmlDocPtr myDoc; /* the document being built */
    int wellFormed; /* is the document well formed */
    int replaceEntities; /* shall we replace entities ? */
    const(xmlChar)* version_; /* the XML version string */
    const(xmlChar)* encoding; /* the declared encoding, if any */
    int standalone; /* standalone document */
    int html; /* an HTML(1)/Docbook(2) document
     * 3 is HTML after <head>
     * 10 is HTML after <body>
     */

    /* Input stream stack */
    xmlParserInputPtr input; /* Current input stream */
    int inputNr; /* Number of current input streams */
    int inputMax; /* Max number of input streams */
    xmlParserInputPtr* inputTab; /* stack of inputs */

    /* Node analysis stack only used for DOM building */
    xmlNodePtr node; /* Current parsed Node */
    int nodeNr; /* Depth of the parsing stack */
    int nodeMax; /* Max depth of the parsing stack */
    xmlNodePtr* nodeTab; /* array of nodes */

    int record_info; /* Whether node info should be kept */
    xmlParserNodeInfoSeq node_seq; /* info about each node parsed */

    int errNo; /* error code */

    int hasExternalSubset; /* reference and external subset */
    int hasPErefs; /* the internal subset has PE refs */
    int external; /* are we parsing an external entity */

    int valid; /* is the document valid */
    int validate; /* shall we try to validate ? */
    xmlValidCtxt vctxt; /* The validity context */

    xmlParserInputState instate; /* current type of input */
    int token; /* next char look-ahead */

    char* directory; /* the data directory */

    /* Node name stack */
    const(xmlChar)* name; /* Current parsed Node */
    int nameNr; /* Depth of the parsing stack */
    int nameMax; /* Max depth of the parsing stack */
    const(xmlChar*)* nameTab; /* array of nodes */

    c_long nbChars; /* number of xmlChar processed */
    c_long checkIndex; /* used by progressive parsing lookup */
    int keepBlanks; /* ugly but ... */
    int disableSAX; /* SAX callbacks are disabled */
    int inSubset; /* Parsing is in int 1/ext 2 subset */
    const(xmlChar)* intSubName; /* name of subset */
    xmlChar* extSubURI; /* URI of external subset */
    xmlChar* extSubSystem; /* SYSTEM ID of external subset */

    /* xml:space values */
    int* space; /* Should the parser preserve spaces */
    int spaceNr; /* Depth of the parsing stack */
    int spaceMax; /* Max depth of the parsing stack */
    int* spaceTab; /* array of space infos */

    int depth; /* to prevent entity substitution loops */
    xmlParserInputPtr entity; /* used to check entities boundaries */
    int charset; /* encoding of the in-memory content
                             actually an xmlCharEncoding */
    int nodelen; /* Those two fields are there to */
    int nodemem; /* Speed up large node parsing */
    int pedantic; /* signal pedantic warnings */
    void* _private; /* For user data, libxml won't touch it */

    int loadsubset; /* should the external subset be loaded */
    int linenumbers; /* set line number in element content */
    void* catalogs; /* document's own catalog */
    int recovery; /* run in recovery mode */
    int progressive; /* is this a progressive parsing */
    xmlDictPtr dict; /* dictionary for the parser */
    const(xmlChar*)* atts; /* array for the attributes callbacks */
    int maxatts; /* the size of the array */
    int docdict; /* use strings from dict to build tree */

    /*
     * pre-interned strings
     */
    const(xmlChar)* str_xml;
    const(xmlChar)* str_xmlns;
    const(xmlChar)* str_xml_ns;

    /*
     * Everything below is used only by the new SAX mode
     */
    int sax2; /* operating in the new SAX mode */
    int nsNr; /* the number of inherited namespaces */
    int nsMax; /* the size of the arrays */
    const(xmlChar*)* nsTab; /* the array of prefix/namespace name */
    int* attallocs; /* which attribute were allocated */
    void** pushTab; /* array of data for push */
    xmlHashTablePtr attsDefault; /* defaulted attributes if any */
    xmlHashTablePtr attsSpecial; /* non-CDATA attributes if any */
    int nsWellFormed; /* is the document XML Namespace okay */
    int options; /* Extra options */

    /*
     * Those fields are needed only for streaming parsing so far
     */
    int dictNames; /* Use dictionary names for the tree */
    int freeElemsNr; /* number of freed element nodes */
    xmlNodePtr freeElems; /* List of freed element nodes */
    int freeAttrsNr; /* number of freed attributes nodes */
    xmlAttrPtr freeAttrs; /* List of freed attributes nodes */

    /*
     * the complete error informations for the last error.
     */
    xmlError lastError;
    xmlParserMode parseMode; /* the parser mode */
    c_ulong nbentities; /* number of entities references */
    c_ulong sizeentities; /* size of parsed entities */

    /* for use by HTML non-recursive parser */
    xmlParserNodeInfo* nodeInfo; /* Current NodeInfo */
    int nodeInfoNr; /* Depth of the parsing stack */
    int nodeInfoMax; /* Max depth of the parsing stack */
    xmlParserNodeInfo* nodeInfoTab; /* array of nodeInfos */

    int input_id; /* we need to label inputs */
    c_ulong sizeentcopy; /* volume of entity copy */
}

/**
 * xmlSAXLocator:
 *
 * A SAX Locator.
 */
struct _xmlSAXLocator
{
    const(xmlChar)* function(void* ctx) getPublicId;
    const(xmlChar)* function(void* ctx) getSystemId;
    int function(void* ctx) getLineNumber;
    int function(void* ctx) getColumnNumber;
}

/**
 * xmlSAXHandler:
 *
 * A SAX handler is bunch of callbacks called by the parser when processing
 * of the input generate data or structure informations.
 */

/**
 * resolveEntitySAXFunc:
 * @ctx:  the user data (XML parser context)
 * @publicId: The public ID of the entity
 * @systemId: The system ID of the entity
 *
 * Callback:
 * The entity loader, to control the loading of external entities,
 * the application can either:
 *    - override this resolveEntity() callback in the SAX block
 *    - or better use the xmlSetExternalEntityLoader() function to
 *      set up it's own entity resolution routine
 *
 * Returns the xmlParserInputPtr if inlined or NULL for DOM behaviour.
 */
alias resolveEntitySAXFunc = _xmlParserInput* function(
    void* ctx,
    const(xmlChar)* publicId,
    const(xmlChar)* systemId);
/**
 * internalSubsetSAXFunc:
 * @ctx:  the user data (XML parser context)
 * @name:  the root element name
 * @ExternalID:  the external ID
 * @SystemID:  the SYSTEM ID (e.g. filename or URL)
 *
 * Callback on internal subset declaration.
 */
alias internalSubsetSAXFunc = void function(
    void* ctx,
    const(xmlChar)* name,
    const(xmlChar)* ExternalID,
    const(xmlChar)* SystemID);
/**
 * externalSubsetSAXFunc:
 * @ctx:  the user data (XML parser context)
 * @name:  the root element name
 * @ExternalID:  the external ID
 * @SystemID:  the SYSTEM ID (e.g. filename or URL)
 *
 * Callback on external subset declaration.
 */
alias externalSubsetSAXFunc = void function(
    void* ctx,
    const(xmlChar)* name,
    const(xmlChar)* ExternalID,
    const(xmlChar)* SystemID);
/**
 * getEntitySAXFunc:
 * @ctx:  the user data (XML parser context)
 * @name: The entity name
 *
 * Get an entity by name.
 *
 * Returns the xmlEntityPtr if found.
 */
alias getEntitySAXFunc = _xmlEntity* function(void* ctx, const(xmlChar)* name);
/**
 * getParameterEntitySAXFunc:
 * @ctx:  the user data (XML parser context)
 * @name: The entity name
 *
 * Get a parameter entity by name.
 *
 * Returns the xmlEntityPtr if found.
 */
alias getParameterEntitySAXFunc = _xmlEntity* function(
    void* ctx,
    const(xmlChar)* name);
/**
 * entityDeclSAXFunc:
 * @ctx:  the user data (XML parser context)
 * @name:  the entity name
 * @type:  the entity type
 * @publicId: The public ID of the entity
 * @systemId: The system ID of the entity
 * @content: the entity value (without processing).
 *
 * An entity definition has been parsed.
 */
alias entityDeclSAXFunc = void function(
    void* ctx,
    const(xmlChar)* name,
    int type,
    const(xmlChar)* publicId,
    const(xmlChar)* systemId,
    xmlChar* content);
/**
 * notationDeclSAXFunc:
 * @ctx:  the user data (XML parser context)
 * @name: The name of the notation
 * @publicId: The public ID of the entity
 * @systemId: The system ID of the entity
 *
 * What to do when a notation declaration has been parsed.
 */
alias notationDeclSAXFunc = void function(
    void* ctx,
    const(xmlChar)* name,
    const(xmlChar)* publicId,
    const(xmlChar)* systemId);
/**
 * attributeDeclSAXFunc:
 * @ctx:  the user data (XML parser context)
 * @elem:  the name of the element
 * @fullname:  the attribute name
 * @type:  the attribute type
 * @def:  the type of default value
 * @defaultValue: the attribute default value
 * @tree:  the tree of enumerated value set
 *
 * An attribute definition has been parsed.
 */
alias attributeDeclSAXFunc = void function(
    void* ctx,
    const(xmlChar)* elem,
    const(xmlChar)* fullname,
    int type,
    int def,
    const(xmlChar)* defaultValue,
    xmlEnumerationPtr tree);
/**
 * elementDeclSAXFunc:
 * @ctx:  the user data (XML parser context)
 * @name:  the element name
 * @type:  the element type
 * @content: the element value tree
 *
 * An element definition has been parsed.
 */
alias elementDeclSAXFunc = void function(
    void* ctx,
    const(xmlChar)* name,
    int type,
    xmlElementContentPtr content);
/**
 * unparsedEntityDeclSAXFunc:
 * @ctx:  the user data (XML parser context)
 * @name: The name of the entity
 * @publicId: The public ID of the entity
 * @systemId: The system ID of the entity
 * @notationName: the name of the notation
 *
 * What to do when an unparsed entity declaration is parsed.
 */
alias unparsedEntityDeclSAXFunc = void function(
    void* ctx,
    const(xmlChar)* name,
    const(xmlChar)* publicId,
    const(xmlChar)* systemId,
    const(xmlChar)* notationName);
/**
 * setDocumentLocatorSAXFunc:
 * @ctx:  the user data (XML parser context)
 * @loc: A SAX Locator
 *
 * Receive the document locator at startup, actually xmlDefaultSAXLocator.
 * Everything is available on the context, so this is useless in our case.
 */
alias setDocumentLocatorSAXFunc = void function(
    void* ctx,
    xmlSAXLocatorPtr loc);
/**
 * startDocumentSAXFunc:
 * @ctx:  the user data (XML parser context)
 *
 * Called when the document start being processed.
 */
alias startDocumentSAXFunc = void function(void* ctx);
/**
 * endDocumentSAXFunc:
 * @ctx:  the user data (XML parser context)
 *
 * Called when the document end has been detected.
 */
alias endDocumentSAXFunc = void function(void* ctx);
/**
 * startElementSAXFunc:
 * @ctx:  the user data (XML parser context)
 * @name:  The element name, including namespace prefix
 * @atts:  An array of name/value attributes pairs, NULL terminated
 *
 * Called when an opening tag has been processed.
 */
alias startElementSAXFunc = void function(
    void* ctx,
    const(xmlChar)* name,
    const(xmlChar*)* atts);
/**
 * endElementSAXFunc:
 * @ctx:  the user data (XML parser context)
 * @name:  The element name
 *
 * Called when the end of an element has been detected.
 */
alias endElementSAXFunc = void function(void* ctx, const(xmlChar)* name);
/**
 * attributeSAXFunc:
 * @ctx:  the user data (XML parser context)
 * @name:  The attribute name, including namespace prefix
 * @value:  The attribute value
 *
 * Handle an attribute that has been read by the parser.
 * The default handling is to convert the attribute into an
 * DOM subtree and past it in a new xmlAttr element added to
 * the element.
 */
alias attributeSAXFunc = void function(
    void* ctx,
    const(xmlChar)* name,
    const(xmlChar)* value);
/**
 * referenceSAXFunc:
 * @ctx:  the user data (XML parser context)
 * @name:  The entity name
 *
 * Called when an entity reference is detected.
 */
alias referenceSAXFunc = void function(void* ctx, const(xmlChar)* name);
/**
 * charactersSAXFunc:
 * @ctx:  the user data (XML parser context)
 * @ch:  a xmlChar string
 * @len: the number of xmlChar
 *
 * Receiving some chars from the parser.
 */
alias charactersSAXFunc = void function(
    void* ctx,
    const(xmlChar)* ch,
    int len);
/**
 * ignorableWhitespaceSAXFunc:
 * @ctx:  the user data (XML parser context)
 * @ch:  a xmlChar string
 * @len: the number of xmlChar
 *
 * Receiving some ignorable whitespaces from the parser.
 * UNUSED: by default the DOM building will use characters.
 */
alias ignorableWhitespaceSAXFunc = void function(
    void* ctx,
    const(xmlChar)* ch,
    int len);
/**
 * processingInstructionSAXFunc:
 * @ctx:  the user data (XML parser context)
 * @target:  the target name
 * @data: the PI data's
 *
 * A processing instruction has been parsed.
 */
alias processingInstructionSAXFunc = void function(
    void* ctx,
    const(xmlChar)* target,
    const(xmlChar)* data);
/**
 * commentSAXFunc:
 * @ctx:  the user data (XML parser context)
 * @value:  the comment content
 *
 * A comment has been parsed.
 */
alias commentSAXFunc = void function(void* ctx, const(xmlChar)* value);
/**
 * cdataBlockSAXFunc:
 * @ctx:  the user data (XML parser context)
 * @value:  The pcdata content
 * @len:  the block length
 *
 * Called when a pcdata block has been parsed.
 */
alias cdataBlockSAXFunc = void function(
    void* ctx,
    const(xmlChar)* value,
    int len);
/**
 * warningSAXFunc:
 * @ctx:  an XML parser context
 * @msg:  the message to display/transmit
 * @...:  extra parameters for the message display
 *
 * Display and format a warning messages, callback.
 */
alias warningSAXFunc = void function(void* ctx, const(char)* msg, ...);
/**
 * errorSAXFunc:
 * @ctx:  an XML parser context
 * @msg:  the message to display/transmit
 * @...:  extra parameters for the message display
 *
 * Display and format an error messages, callback.
 */
alias errorSAXFunc = void function(void* ctx, const(char)* msg, ...);
/**
 * fatalErrorSAXFunc:
 * @ctx:  an XML parser context
 * @msg:  the message to display/transmit
 * @...:  extra parameters for the message display
 *
 * Display and format fatal error messages, callback.
 * Note: so far fatalError() SAX callbacks are not used, error()
 *       get all the callbacks for errors.
 */
alias fatalErrorSAXFunc = void function(void* ctx, const(char)* msg, ...);
/**
 * isStandaloneSAXFunc:
 * @ctx:  the user data (XML parser context)
 *
 * Is this document tagged standalone?
 *
 * Returns 1 if true
 */
alias isStandaloneSAXFunc = int function(void* ctx);
/**
 * hasInternalSubsetSAXFunc:
 * @ctx:  the user data (XML parser context)
 *
 * Does this document has an internal subset.
 *
 * Returns 1 if true
 */
alias hasInternalSubsetSAXFunc = int function(void* ctx);

/**
 * hasExternalSubsetSAXFunc:
 * @ctx:  the user data (XML parser context)
 *
 * Does this document has an external subset?
 *
 * Returns 1 if true
 */
alias hasExternalSubsetSAXFunc = int function(void* ctx);

/************************************************************************
 *                                                                      *
 *                      The SAX version 2 API extensions                *
 *                                                                      *
 ************************************************************************/
/**
 * XML_SAX2_MAGIC:
 *
 * Special constant found in SAX2 blocks initialized fields
 */
enum XML_SAX2_MAGIC = 0xDEEDBEAF;

/**
 * startElementNsSAX2Func:
 * @ctx:  the user data (XML parser context)
 * @localname:  the local name of the element
 * @prefix:  the element namespace prefix if available
 * @URI:  the element namespace name if available
 * @nb_namespaces:  number of namespace definitions on that node
 * @namespaces:  pointer to the array of prefix/URI pairs namespace definitions
 * @nb_attributes:  the number of attributes on that node
 * @nb_defaulted:  the number of defaulted attributes. The defaulted
 *                  ones are at the end of the array
 * @attributes:  pointer to the array of (localname/prefix/URI/value/end)
 *               attribute values.
 *
 * SAX2 callback when an element start has been detected by the parser.
 * It provides the namespace informations for the element, as well as
 * the new namespace declarations on the element.
 */

alias startElementNsSAX2Func = void function(
    void* ctx,
    const(xmlChar)* localname,
    const(xmlChar)* prefix,
    const(xmlChar)* URI,
    int nb_namespaces,
    const(xmlChar*)* namespaces,
    int nb_attributes,
    int nb_defaulted,
    const(xmlChar*)* attributes);

/**
 * endElementNsSAX2Func:
 * @ctx:  the user data (XML parser context)
 * @localname:  the local name of the element
 * @prefix:  the element namespace prefix if available
 * @URI:  the element namespace name if available
 *
 * SAX2 callback when an element end has been detected by the parser.
 * It provides the namespace informations for the element.
 */

alias endElementNsSAX2Func = void function(
    void* ctx,
    const(xmlChar)* localname,
    const(xmlChar)* prefix,
    const(xmlChar)* URI);

struct _xmlSAXHandler
{
    internalSubsetSAXFunc internalSubset;
    isStandaloneSAXFunc isStandalone;
    hasInternalSubsetSAXFunc hasInternalSubset;
    hasExternalSubsetSAXFunc hasExternalSubset;
    resolveEntitySAXFunc resolveEntity;
    getEntitySAXFunc getEntity;
    entityDeclSAXFunc entityDecl;
    notationDeclSAXFunc notationDecl;
    attributeDeclSAXFunc attributeDecl;
    elementDeclSAXFunc elementDecl;
    unparsedEntityDeclSAXFunc unparsedEntityDecl;
    setDocumentLocatorSAXFunc setDocumentLocator;
    startDocumentSAXFunc startDocument;
    endDocumentSAXFunc endDocument;
    startElementSAXFunc startElement;
    endElementSAXFunc endElement;
    referenceSAXFunc reference;
    charactersSAXFunc characters;
    ignorableWhitespaceSAXFunc ignorableWhitespace;
    processingInstructionSAXFunc processingInstruction;
    commentSAXFunc comment;
    warningSAXFunc warning;
    errorSAXFunc error;
    fatalErrorSAXFunc fatalError; /* unused error() get all the errors */
    getParameterEntitySAXFunc getParameterEntity;
    cdataBlockSAXFunc cdataBlock;
    externalSubsetSAXFunc externalSubset;
    uint initialized;
    /* The following fields are extensions available only on version 2 */
    void* _private;
    startElementNsSAX2Func startElementNs;
    endElementNsSAX2Func endElementNs;
    xmlStructuredErrorFunc serror;
}

/*
 * SAX Version 1
 */
alias xmlSAXHandlerV1 = _xmlSAXHandlerV1;
alias xmlSAXHandlerV1Ptr = _xmlSAXHandlerV1*;

struct _xmlSAXHandlerV1
{
    internalSubsetSAXFunc internalSubset;
    isStandaloneSAXFunc isStandalone;
    hasInternalSubsetSAXFunc hasInternalSubset;
    hasExternalSubsetSAXFunc hasExternalSubset;
    resolveEntitySAXFunc resolveEntity;
    getEntitySAXFunc getEntity;
    entityDeclSAXFunc entityDecl;
    notationDeclSAXFunc notationDecl;
    attributeDeclSAXFunc attributeDecl;
    elementDeclSAXFunc elementDecl;
    unparsedEntityDeclSAXFunc unparsedEntityDecl;
    setDocumentLocatorSAXFunc setDocumentLocator;
    startDocumentSAXFunc startDocument;
    endDocumentSAXFunc endDocument;
    startElementSAXFunc startElement;
    endElementSAXFunc endElement;
    referenceSAXFunc reference;
    charactersSAXFunc characters;
    ignorableWhitespaceSAXFunc ignorableWhitespace;
    processingInstructionSAXFunc processingInstruction;
    commentSAXFunc comment;
    warningSAXFunc warning;
    errorSAXFunc error;
    fatalErrorSAXFunc fatalError; /* unused error() get all the errors */
    getParameterEntitySAXFunc getParameterEntity;
    cdataBlockSAXFunc cdataBlock;
    externalSubsetSAXFunc externalSubset;
    uint initialized;
}

/**
 * xmlExternalEntityLoader:
 * @URL: The System ID of the resource requested
 * @ID: The Public ID of the resource requested
 * @context: the XML parser context
 *
 * External entity loaders types.
 *
 * Returns the entity input parser.
 */
alias xmlExternalEntityLoader = _xmlParserInput* function(
    const(char)* URL,
    const(char)* ID,
    xmlParserCtxtPtr context);

/*
 * Init/Cleanup
 */
void xmlInitParser();
void xmlCleanupParser();

/*
 * Input functions
 */
int xmlParserInputRead(xmlParserInputPtr in_, int len);
int xmlParserInputGrow(xmlParserInputPtr in_, int len);

/*
 * Basic parsing Interfaces
 */

/* LIBXML_SAX1_ENABLED */
int xmlSubstituteEntitiesDefault(int val);
int xmlKeepBlanksDefault(int val);
void xmlStopParser(xmlParserCtxtPtr ctxt);
int xmlPedanticParserDefault(int val);
int xmlLineNumbersDefault(int val);

/*
 * Recovery mode
 */

/* LIBXML_SAX1_ENABLED */

/*
 * Less common routines and SAX interfaces
 */
int xmlParseDocument(xmlParserCtxtPtr ctxt);
int xmlParseExtParsedEnt(xmlParserCtxtPtr ctxt);

/* LIBXML_SAX1_ENABLED */

/* LIBXML_VALID_ENABLE */

/* LIBXML_SAX1_ENABLED */
xmlParserErrors xmlParseInNodeContext(
    xmlNodePtr node,
    const(char)* data,
    int datalen,
    int options,
    xmlNodePtr* lst);

/* LIBXML_SAX1_ENABLED */
int xmlParseCtxtExternalEntity(
    xmlParserCtxtPtr ctx,
    const(xmlChar)* URL,
    const(xmlChar)* ID,
    xmlNodePtr* lst);

/*
 * Parser contexts handling.
 */
xmlParserCtxtPtr xmlNewParserCtxt();
int xmlInitParserCtxt(xmlParserCtxtPtr ctxt);
void xmlClearParserCtxt(xmlParserCtxtPtr ctxt);
void xmlFreeParserCtxt(xmlParserCtxtPtr ctxt);

/* LIBXML_SAX1_ENABLED */
xmlParserCtxtPtr xmlCreateDocParserCtxt(const(xmlChar)* cur);

/*
 * Reading/setting optional parsing features.
 */

/* LIBXML_LEGACY_ENABLED */

/*
 * Interfaces for the Push mode.
 */

/* LIBXML_PUSH_ENABLED */

/*
 * Special I/O mode.
 */

xmlParserCtxtPtr xmlCreateIOParserCtxt(
    xmlSAXHandlerPtr sax,
    void* user_data,
    xmlInputReadCallback ioread,
    xmlInputCloseCallback ioclose,
    void* ioctx,
    xmlCharEncoding enc);

xmlParserInputPtr xmlNewIOInputStream(
    xmlParserCtxtPtr ctxt,
    xmlParserInputBufferPtr input,
    xmlCharEncoding enc);

/*
 * Node infos.
 */
const(xmlParserNodeInfo)* xmlParserFindNodeInfo(
    const xmlParserCtxtPtr ctxt,
    const xmlNodePtr node);
void xmlInitNodeInfoSeq(xmlParserNodeInfoSeqPtr seq);
void xmlClearNodeInfoSeq(xmlParserNodeInfoSeqPtr seq);
c_ulong xmlParserFindNodeInfoIndex(
    const xmlParserNodeInfoSeqPtr seq,
    const xmlNodePtr node);
void xmlParserAddNodeInfo(
    xmlParserCtxtPtr ctxt,
    const xmlParserNodeInfoPtr info);

/*
 * External entities handling actually implemented in xmlIO.
 */

void xmlSetExternalEntityLoader(xmlExternalEntityLoader f);
xmlExternalEntityLoader xmlGetExternalEntityLoader();
xmlParserInputPtr xmlLoadExternalEntity(
    const(char)* URL,
    const(char)* ID,
    xmlParserCtxtPtr ctxt);

/*
 * Index lookup, actually implemented in the encoding module
 */
c_long xmlByteConsumed(xmlParserCtxtPtr ctxt);

/*
 * New set of simpler/more flexible APIs
 */
/**
 * xmlParserOption:
 *
 * This is the set of XML parser options that can be passed down
 * to the xmlReadDoc() and similar calls.
 */
enum xmlParserOption
{
    recover = 1 << 0, /* recover on errors */
    noent = 1 << 1, /* substitute entities */
    dtdload = 1 << 2, /* load the external subset */
    dtdattr = 1 << 3, /* default DTD attributes */
    dtdvalid = 1 << 4, /* validate with the DTD */
    noerror = 1 << 5, /* suppress error reports */
    nowarning = 1 << 6, /* suppress warning reports */
    pedantic = 1 << 7, /* pedantic error reporting */
    noblanks = 1 << 8, /* remove blank nodes */
    sax1 = 1 << 9, /* use the SAX1 interface internally */
    xinclude = 1 << 10, /* Implement XInclude substitution  */
    nonet = 1 << 11, /* Forbid network access */
    nodict = 1 << 12, /* Do not reuse the context dictionary */
    nsclean = 1 << 13, /* remove redundant namespaces declarations */
    nocdata = 1 << 14, /* merge CDATA as text nodes */
    noxincnode = 1 << 15, /* do not generate XINCLUDE START/END nodes */
    compact = 1 << 16, /* compact small text nodes; no modification of
                                       the tree allowed afterwards (will possibly
                       crash if you try to modify the tree) */
    old10 = 1 << 17, /* parse using XML-1.0 before update 5 */
    nobasefix = 1 << 18, /* do not fixup XINCLUDE xml:base uris */
    huge = 1 << 19, /* relax any hardcoded limit from the parser */
    oldsax = 1 << 20, /* parse using SAX2 interface before 2.7.0 */
    ignoreEnc = 1 << 21, /* ignore internal document encoding hint */
    bigLines = 1 << 22 /* Store big lines numbers in text PSVI field */
}

void xmlCtxtReset(xmlParserCtxtPtr ctxt);
int xmlCtxtResetPush(
    xmlParserCtxtPtr ctxt,
    const(char)* chunk,
    int size,
    const(char)* filename,
    const(char)* encoding);
int xmlCtxtUseOptions(xmlParserCtxtPtr ctxt, int options);
xmlDocPtr xmlReadDoc(
    const(xmlChar)* cur,
    const(char)* URL,
    const(char)* encoding,
    int options);
xmlDocPtr xmlReadFile(const(char)* URL, const(char)* encoding, int options);
xmlDocPtr xmlReadMemory(
    const(char)* buffer,
    int size,
    const(char)* URL,
    const(char)* encoding,
    int options);
xmlDocPtr xmlReadFd(
    int fd,
    const(char)* URL,
    const(char)* encoding,
    int options);
xmlDocPtr xmlReadIO(
    xmlInputReadCallback ioread,
    xmlInputCloseCallback ioclose,
    void* ioctx,
    const(char)* URL,
    const(char)* encoding,
    int options);
xmlDocPtr xmlCtxtReadDoc(
    xmlParserCtxtPtr ctxt,
    const(xmlChar)* cur,
    const(char)* URL,
    const(char)* encoding,
    int options);
xmlDocPtr xmlCtxtReadFile(
    xmlParserCtxtPtr ctxt,
    const(char)* filename,
    const(char)* encoding,
    int options);
xmlDocPtr xmlCtxtReadMemory(
    xmlParserCtxtPtr ctxt,
    const(char)* buffer,
    int size,
    const(char)* URL,
    const(char)* encoding,
    int options);
xmlDocPtr xmlCtxtReadFd(
    xmlParserCtxtPtr ctxt,
    int fd,
    const(char)* URL,
    const(char)* encoding,
    int options);
xmlDocPtr xmlCtxtReadIO(
    xmlParserCtxtPtr ctxt,
    xmlInputReadCallback ioread,
    xmlInputCloseCallback ioclose,
    void* ioctx,
    const(char)* URL,
    const(char)* encoding,
    int options);

/*
 * Library wide options
 */
/**
 * xmlFeature:
 *
 * Used to examine the existence of features that can be enabled
 * or disabled at compile-time.
 * They used to be called XML_FEATURE_xxx but this clashed with Expat
 */
enum xmlFeature
{
    thread = 1,
    tree = 2,
    output = 3,
    push = 4,
    reader = 5,
    pattern = 6,
    writer = 7,
    sax1 = 8,
    ftp = 9,
    http = 10,
    valid = 11,
    html = 12,
    legacy = 13,
    c14n = 14,
    catalog = 15,
    xpath = 16,
    xptr = 17,
    xinclude = 18,
    iconv = 19,
    iso8859x = 20,
    unicode = 21,
    regexp = 22,
    automata = 23,
    expr = 24,
    schemas = 25,
    schematron = 26,
    modules = 27,
    debug_ = 28,
    debugMem = 29,
    debugRun = 30,
    zlib = 31,
    icu = 32,
    lzma = 33,
    none = 99999 /* just to be sure of allocation size */
}

int xmlHasFeature(xmlFeature feature);

/* __XML_PARSER_H__ */
