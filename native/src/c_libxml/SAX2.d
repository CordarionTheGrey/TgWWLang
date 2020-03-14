module c_libxml.SAX2;

import c_libxml.parser;
import c_libxml.tree;
import c_libxml.xlink;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/*
 * Summary: SAX2 parser interface used to build the DOM tree
 * Description: those are the default SAX2 interfaces used by
 *              the library when building DOM tree.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C) nothrow @system:

const(xmlChar)* xmlSAX2GetPublicId(void* ctx);
const(xmlChar)* xmlSAX2GetSystemId(void* ctx);
void xmlSAX2SetDocumentLocator(void* ctx, xmlSAXLocatorPtr loc);

int xmlSAX2GetLineNumber(void* ctx);
int xmlSAX2GetColumnNumber(void* ctx);

int xmlSAX2IsStandalone(void* ctx);
int xmlSAX2HasInternalSubset(void* ctx);
int xmlSAX2HasExternalSubset(void* ctx);

void xmlSAX2InternalSubset(
    void* ctx,
    const(xmlChar)* name,
    const(xmlChar)* ExternalID,
    const(xmlChar)* SystemID);
void xmlSAX2ExternalSubset(
    void* ctx,
    const(xmlChar)* name,
    const(xmlChar)* ExternalID,
    const(xmlChar)* SystemID);
xmlEntityPtr xmlSAX2GetEntity(void* ctx, const(xmlChar)* name);
xmlEntityPtr xmlSAX2GetParameterEntity(void* ctx, const(xmlChar)* name);
xmlParserInputPtr xmlSAX2ResolveEntity(
    void* ctx,
    const(xmlChar)* publicId,
    const(xmlChar)* systemId);

void xmlSAX2EntityDecl(
    void* ctx,
    const(xmlChar)* name,
    int type,
    const(xmlChar)* publicId,
    const(xmlChar)* systemId,
    xmlChar* content);
void xmlSAX2AttributeDecl(
    void* ctx,
    const(xmlChar)* elem,
    const(xmlChar)* fullname,
    int type,
    int def,
    const(xmlChar)* defaultValue,
    xmlEnumerationPtr tree);
void xmlSAX2ElementDecl(
    void* ctx,
    const(xmlChar)* name,
    int type,
    xmlElementContentPtr content);
void xmlSAX2NotationDecl(
    void* ctx,
    const(xmlChar)* name,
    const(xmlChar)* publicId,
    const(xmlChar)* systemId);
void xmlSAX2UnparsedEntityDecl(
    void* ctx,
    const(xmlChar)* name,
    const(xmlChar)* publicId,
    const(xmlChar)* systemId,
    const(xmlChar)* notationName);

void xmlSAX2StartDocument(void* ctx);
void xmlSAX2EndDocument(void* ctx);

/* LIBXML_SAX1_ENABLED or LIBXML_HTML_ENABLED or LIBXML_LEGACY_ENABLED */
void xmlSAX2StartElementNs(
    void* ctx,
    const(xmlChar)* localname,
    const(xmlChar)* prefix,
    const(xmlChar)* URI,
    int nb_namespaces,
    const(xmlChar*)* namespaces,
    int nb_attributes,
    int nb_defaulted,
    const(xmlChar*)* attributes);
void xmlSAX2EndElementNs(
    void* ctx,
    const(xmlChar)* localname,
    const(xmlChar)* prefix,
    const(xmlChar)* URI);
void xmlSAX2Reference(void* ctx, const(xmlChar)* name);
void xmlSAX2Characters(void* ctx, const(xmlChar)* ch, int len);
void xmlSAX2IgnorableWhitespace(void* ctx, const(xmlChar)* ch, int len);
void xmlSAX2ProcessingInstruction(
    void* ctx,
    const(xmlChar)* target,
    const(xmlChar)* data);
void xmlSAX2Comment(void* ctx, const(xmlChar)* value);
void xmlSAX2CDataBlock(void* ctx, const(xmlChar)* value, int len);

/* LIBXML_SAX1_ENABLED */

int xmlSAXVersion(xmlSAXHandler* hdlr, int version_);
void xmlSAX2InitDefaultSAXHandler(xmlSAXHandler* hdlr, int warning);

void xmlDefaultSAXHandlerInit();

/* __XML_SAX2_H__ */
