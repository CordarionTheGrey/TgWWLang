module c_libxml.parserInternals;

import c_libxml.chvalid;
import c_libxml.encoding;
import c_libxml.HTMLparser;
import c_libxml.parser;
import c_libxml.tree;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/*
 * Summary: internals routines and limits exported by the parser.
 * Description: this module exports a number of internal parsing routines
 *              they are not really all intended for applications but
 *              can prove useful doing low level processing.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C) nothrow:

/**
 * xmlParserMaxDepth:
 *
 * arbitrary depth limit for the XML documents that we allow to
 * process. This is not a limitation of the parser but a safety
 * boundary feature, use XML_PARSE_HUGE option to override it.
 */
extern __gshared uint xmlParserMaxDepth;

/**
 * XML_MAX_TEXT_LENGTH:
 *
 * Maximum size allowed for a single text node when building a tree.
 * This is not a limitation of the parser but a safety boundary feature,
 * use XML_PARSE_HUGE option to override it.
 * Introduced in 2.9.0
 */
enum XML_MAX_TEXT_LENGTH = 10000000;

/**
 * XML_MAX_NAME_LENGTH:
 *
 * Maximum size allowed for a markup identifier.
 * This is not a limitation of the parser but a safety boundary feature,
 * use XML_PARSE_HUGE option to override it.
 * Note that with the use of parsing dictionaries overriding the limit
 * may result in more runtime memory usage in face of "unfriendly' content
 * Introduced in 2.9.0
 */
enum XML_MAX_NAME_LENGTH = 50000;

/**
 * XML_MAX_DICTIONARY_LIMIT:
 *
 * Maximum size allowed by the parser for a dictionary by default
 * This is not a limitation of the parser but a safety boundary feature,
 * use XML_PARSE_HUGE option to override it.
 * Introduced in 2.9.0
 */
enum XML_MAX_DICTIONARY_LIMIT = 10000000;

/**
 * XML_MAX_LOOKUP_LIMIT:
 *
 * Maximum size allowed by the parser for ahead lookup
 * This is an upper boundary enforced by the parser to avoid bad
 * behaviour on "unfriendly' content
 * Introduced in 2.9.0
 */
enum XML_MAX_LOOKUP_LIMIT = 10000000;

/**
 * XML_MAX_NAMELEN:
 *
 * Identifiers can be longer, but this will be more costly
 * at runtime.
 */
enum XML_MAX_NAMELEN = 100;

/**
 * INPUT_CHUNK:
 *
 * The parser tries to always have that amount of input ready.
 * One of the point is providing context when reporting errors.
 */
enum INPUT_CHUNK = 250;

/************************************************************************
 *                                                                      *
 * UNICODE version of the macros.                                       *
 *                                                                      *
 ************************************************************************/
/**
 * IS_BYTE_CHAR:
 * @c:  an byte value (int)
 *
 * Macro to check the following production in the XML spec:
 *
 * [2] Char ::= #x9 | #xA | #xD | [#x20...]
 * any byte character in the accepted range
 */
alias IS_BYTE_CHAR = xmlIsChar_ch;

/**
 * IS_CHAR:
 * @c:  an UNICODE value (int)
 *
 * Macro to check the following production in the XML spec:
 *
 * [2] Char ::= #x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD]
 *                  | [#x10000-#x10FFFF]
 * any Unicode character, excluding the surrogate blocks, FFFE, and FFFF.
 */
alias IS_CHAR = xmlIsCharQ;

/**
 * IS_CHAR_CH:
 * @c: an xmlChar (usually an unsigned char)
 *
 * Behaves like IS_CHAR on single-byte value
 */
alias IS_CHAR_CH = xmlIsChar_ch;

/**
 * IS_BLANK:
 * @c:  an UNICODE value (int)
 *
 * Macro to check the following production in the XML spec:
 *
 * [3] S ::= (#x20 | #x9 | #xD | #xA)+
 */
alias IS_BLANK = xmlIsBlankQ;

/**
 * IS_BLANK_CH:
 * @c:  an xmlChar value (normally unsigned char)
 *
 * Behaviour same as IS_BLANK
 */
alias IS_BLANK_CH = xmlIsBlank_ch;

/**
 * IS_BASECHAR:
 * @c:  an UNICODE value (int)
 *
 * Macro to check the following production in the XML spec:
 *
 * [85] BaseChar ::= ... long list see REC ...
 */
alias IS_BASECHAR = xmlIsBaseCharQ;

/**
 * IS_DIGIT:
 * @c:  an UNICODE value (int)
 *
 * Macro to check the following production in the XML spec:
 *
 * [88] Digit ::= ... long list see REC ...
 */
alias IS_DIGIT = xmlIsDigitQ;

/**
 * IS_DIGIT_CH:
 * @c:  an xmlChar value (usually an unsigned char)
 *
 * Behaves like IS_DIGIT but with a single byte argument
 */
alias IS_DIGIT_CH = xmlIsDigit_ch;

/**
 * IS_COMBINING:
 * @c:  an UNICODE value (int)
 *
 * Macro to check the following production in the XML spec:
 *
 * [87] CombiningChar ::= ... long list see REC ...
 */
alias IS_COMBINING = xmlIsCombiningQ;

/**
 * IS_COMBINING_CH:
 * @c:  an xmlChar (usually an unsigned char)
 *
 * Always false (all combining chars > 0xff)
 */
extern (D) int IS_COMBINING_CH(T)(auto ref T c)
{
    return 0;
}

/**
 * IS_EXTENDER:
 * @c:  an UNICODE value (int)
 *
 * Macro to check the following production in the XML spec:
 *
 *
 * [89] Extender ::= #x00B7 | #x02D0 | #x02D1 | #x0387 | #x0640 |
 *                   #x0E46 | #x0EC6 | #x3005 | [#x3031-#x3035] |
 *                   [#x309D-#x309E] | [#x30FC-#x30FE]
 */
alias IS_EXTENDER = xmlIsExtenderQ;

/**
 * IS_EXTENDER_CH:
 * @c:  an xmlChar value (usually an unsigned char)
 *
 * Behaves like IS_EXTENDER but with a single-byte argument
 */
alias IS_EXTENDER_CH = xmlIsExtender_ch;

/**
 * IS_IDEOGRAPHIC:
 * @c:  an UNICODE value (int)
 *
 * Macro to check the following production in the XML spec:
 *
 *
 * [86] Ideographic ::= [#x4E00-#x9FA5] | #x3007 | [#x3021-#x3029]
 */
alias IS_IDEOGRAPHIC = xmlIsIdeographicQ;

/**
 * IS_LETTER:
 * @c:  an UNICODE value (int)
 *
 * Macro to check the following production in the XML spec:
 *
 *
 * [84] Letter ::= BaseChar | Ideographic
 */
extern (D) auto IS_LETTER(T)(auto ref T c)
{
    return IS_BASECHAR(c) || IS_IDEOGRAPHIC(c);
}

/**
 * IS_LETTER_CH:
 * @c:  an xmlChar value (normally unsigned char)
 *
 * Macro behaves like IS_LETTER, but only check base chars
 *
 */
alias IS_LETTER_CH = xmlIsBaseChar_ch;

/**
 * IS_ASCII_LETTER:
 * @c: an xmlChar value
 *
 * Macro to check [a-zA-Z]
 *
 */
extern (D) auto IS_ASCII_LETTER(T)(auto ref T c)
{
    return ((0x41 <= c) && (c <= 0x5a)) || ((0x61 <= c) && (c <= 0x7a));
}

/**
 * IS_ASCII_DIGIT:
 * @c: an xmlChar value
 *
 * Macro to check [0-9]
 *
 */
extern (D) auto IS_ASCII_DIGIT(T)(auto ref T c)
{
    return (0x30 <= c) && (c <= 0x39);
}

/**
 * IS_PUBIDCHAR:
 * @c:  an UNICODE value (int)
 *
 * Macro to check the following production in the XML spec:
 *
 *
 * [13] PubidChar ::= #x20 | #xD | #xA | [a-zA-Z0-9] | [-'()+,./:=?;!*#@$_%]
 */
alias IS_PUBIDCHAR = xmlIsPubidCharQ;

/**
 * IS_PUBIDCHAR_CH:
 * @c:  an xmlChar value (normally unsigned char)
 *
 * Same as IS_PUBIDCHAR but for single-byte value
 */
alias IS_PUBIDCHAR_CH = xmlIsPubidChar_ch;

/**
 * SKIP_EOL:
 * @p:  and UTF8 string pointer
 *
 * Skips the end of line chars.
 */

/**
 * MOVETO_ENDTAG:
 * @p:  and UTF8 string pointer
 *
 * Skips to the next '>' char.
 */

/**
 * MOVETO_STARTTAG:
 * @p:  and UTF8 string pointer
 *
 * Skips to the next '<' char.
 */

/**
 * Global variables used for predefined strings.
 */
extern __gshared const(xmlChar)[] xmlStringText;
extern __gshared const(xmlChar)[] xmlStringTextNoenc;
extern __gshared const(xmlChar)[] xmlStringComment;

/*
 * Function to finish the work of the macros where needed.
 */
int xmlIsLetter(int c);

/**
 * Parser context.
 */
xmlParserCtxtPtr xmlCreateFileParserCtxt(const(char)* filename);
xmlParserCtxtPtr xmlCreateURLParserCtxt(const(char)* filename, int options);
xmlParserCtxtPtr xmlCreateMemoryParserCtxt(const(char)* buffer, int size);
xmlParserCtxtPtr xmlCreateEntityParserCtxt(
    const(xmlChar)* URL,
    const(xmlChar)* ID,
    const(xmlChar)* base);
int xmlSwitchEncoding(xmlParserCtxtPtr ctxt, xmlCharEncoding enc);
int xmlSwitchToEncoding(
    xmlParserCtxtPtr ctxt,
    xmlCharEncodingHandlerPtr handler);
int xmlSwitchInputEncoding(
    xmlParserCtxtPtr ctxt,
    xmlParserInputPtr input,
    xmlCharEncodingHandlerPtr handler);

/* internal error reporting */

/**
 * Input Streams.
 */
xmlParserInputPtr xmlNewStringInputStream(
    xmlParserCtxtPtr ctxt,
    const(xmlChar)* buffer);
xmlParserInputPtr xmlNewEntityInputStream(
    xmlParserCtxtPtr ctxt,
    xmlEntityPtr entity);
int xmlPushInput(xmlParserCtxtPtr ctxt, xmlParserInputPtr input);
xmlChar xmlPopInput(xmlParserCtxtPtr ctxt);
void xmlFreeInputStream(xmlParserInputPtr input);
xmlParserInputPtr xmlNewInputFromFile(
    xmlParserCtxtPtr ctxt,
    const(char)* filename);
xmlParserInputPtr xmlNewInputStream(xmlParserCtxtPtr ctxt);

/**
 * Namespaces.
 */
xmlChar* xmlSplitQName(
    xmlParserCtxtPtr ctxt,
    const(xmlChar)* name,
    xmlChar** prefix);

/**
 * Generic production rules.
 */
const(xmlChar)* xmlParseName(xmlParserCtxtPtr ctxt);
xmlChar* xmlParseNmtoken(xmlParserCtxtPtr ctxt);
xmlChar* xmlParseEntityValue(xmlParserCtxtPtr ctxt, xmlChar** orig);
xmlChar* xmlParseAttValue(xmlParserCtxtPtr ctxt);
xmlChar* xmlParseSystemLiteral(xmlParserCtxtPtr ctxt);
xmlChar* xmlParsePubidLiteral(xmlParserCtxtPtr ctxt);
void xmlParseCharData(xmlParserCtxtPtr ctxt, int cdata);
xmlChar* xmlParseExternalID(
    xmlParserCtxtPtr ctxt,
    xmlChar** publicID,
    int strict);
void xmlParseComment(xmlParserCtxtPtr ctxt);
const(xmlChar)* xmlParsePITarget(xmlParserCtxtPtr ctxt);
void xmlParsePI(xmlParserCtxtPtr ctxt);
void xmlParseNotationDecl(xmlParserCtxtPtr ctxt);
void xmlParseEntityDecl(xmlParserCtxtPtr ctxt);
int xmlParseDefaultDecl(xmlParserCtxtPtr ctxt, xmlChar** value);
xmlEnumerationPtr xmlParseNotationType(xmlParserCtxtPtr ctxt);
xmlEnumerationPtr xmlParseEnumerationType(xmlParserCtxtPtr ctxt);
int xmlParseEnumeratedType(xmlParserCtxtPtr ctxt, xmlEnumerationPtr* tree);
int xmlParseAttributeType(xmlParserCtxtPtr ctxt, xmlEnumerationPtr* tree);
void xmlParseAttributeListDecl(xmlParserCtxtPtr ctxt);
xmlElementContentPtr xmlParseElementMixedContentDecl(
    xmlParserCtxtPtr ctxt,
    int inputchk);
xmlElementContentPtr xmlParseElementChildrenContentDecl(
    xmlParserCtxtPtr ctxt,
    int inputchk);
int xmlParseElementContentDecl(
    xmlParserCtxtPtr ctxt,
    const(xmlChar)* name,
    xmlElementContentPtr* result);
int xmlParseElementDecl(xmlParserCtxtPtr ctxt);
void xmlParseMarkupDecl(xmlParserCtxtPtr ctxt);
int xmlParseCharRef(xmlParserCtxtPtr ctxt);
xmlEntityPtr xmlParseEntityRef(xmlParserCtxtPtr ctxt);
void xmlParseReference(xmlParserCtxtPtr ctxt);
void xmlParsePEReference(xmlParserCtxtPtr ctxt);
void xmlParseDocTypeDecl(xmlParserCtxtPtr ctxt);

/* LIBXML_SAX1_ENABLED */
void xmlParseCDSect(xmlParserCtxtPtr ctxt);
void xmlParseContent(xmlParserCtxtPtr ctxt);
void xmlParseElement(xmlParserCtxtPtr ctxt);
xmlChar* xmlParseVersionNum(xmlParserCtxtPtr ctxt);
xmlChar* xmlParseVersionInfo(xmlParserCtxtPtr ctxt);
xmlChar* xmlParseEncName(xmlParserCtxtPtr ctxt);
const(xmlChar)* xmlParseEncodingDecl(xmlParserCtxtPtr ctxt);
int xmlParseSDDecl(xmlParserCtxtPtr ctxt);
void xmlParseXMLDecl(xmlParserCtxtPtr ctxt);
void xmlParseTextDecl(xmlParserCtxtPtr ctxt);
void xmlParseMisc(xmlParserCtxtPtr ctxt);
void xmlParseExternalSubset(
    xmlParserCtxtPtr ctxt,
    const(xmlChar)* ExternalID,
    const(xmlChar)* SystemID);
/**
 * XML_SUBSTITUTE_NONE:
 *
 * If no entities need to be substituted.
 */
enum XML_SUBSTITUTE_NONE = 0;
/**
 * XML_SUBSTITUTE_REF:
 *
 * Whether general entities need to be substituted.
 */
enum XML_SUBSTITUTE_REF = 1;
/**
 * XML_SUBSTITUTE_PEREF:
 *
 * Whether parameter entities need to be substituted.
 */
enum XML_SUBSTITUTE_PEREF = 2;
/**
 * XML_SUBSTITUTE_BOTH:
 *
 * Both general and parameter entities need to be substituted.
 */
enum XML_SUBSTITUTE_BOTH = 3;

xmlChar* xmlStringDecodeEntities(
    xmlParserCtxtPtr ctxt,
    const(xmlChar)* str,
    int what,
    xmlChar end,
    xmlChar end2,
    xmlChar end3);
xmlChar* xmlStringLenDecodeEntities(
    xmlParserCtxtPtr ctxt,
    const(xmlChar)* str,
    int len,
    int what,
    xmlChar end,
    xmlChar end2,
    xmlChar end3);

/*
 * Generated by MACROS on top of parser.c c.f. PUSH_AND_POP.
 */
int nodePush(xmlParserCtxtPtr ctxt, xmlNodePtr value);
xmlNodePtr nodePop(xmlParserCtxtPtr ctxt);
int inputPush(xmlParserCtxtPtr ctxt, xmlParserInputPtr value);
xmlParserInputPtr inputPop(xmlParserCtxtPtr ctxt);
const(xmlChar)* namePop(xmlParserCtxtPtr ctxt);
int namePush(xmlParserCtxtPtr ctxt, const(xmlChar)* value);

/*
 * other commodities shared between parser.c and parserInternals.
 */
int xmlSkipBlankChars(xmlParserCtxtPtr ctxt);
int xmlStringCurrentChar(xmlParserCtxtPtr ctxt, const(xmlChar)* cur, int* len);
void xmlParserHandlePEReference(xmlParserCtxtPtr ctxt);
int xmlCheckLanguageID(const(xmlChar)* lang);

/*
 * Really core function shared with HTML parser.
 */
int xmlCurrentChar(xmlParserCtxtPtr ctxt, int* len);
int xmlCopyCharMultiByte(xmlChar* out_, int val);
int xmlCopyChar(int len, xmlChar* out_, int val);
void xmlNextChar(xmlParserCtxtPtr ctxt);
void xmlParserInputShrink(xmlParserInputPtr in_);

/*
 * Actually comes from the HTML parser but launched from the init stuff.
 */

/*
 * Specific function to keep track of entities references
 * and used by the XSLT debugger.
 */

/**
 * xmlEntityReferenceFunc:
 * @ent: the entity
 * @firstNode:  the fist node in the chunk
 * @lastNode:  the last nod in the chunk
 *
 * Callback function used when one needs to be able to track back the
 * provenance of a chunk of nodes inherited from an entity replacement.
 */

/**
 * Entities
 */

/* LIBXML_LEGACY_ENABLED */

/*
 * internal only
 */

/* __XML_PARSER_INTERNALS_H__ */
