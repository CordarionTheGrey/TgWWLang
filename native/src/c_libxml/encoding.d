module c_libxml.encoding;

import c_libxml.tree;
import c_libxml.xmlversion;

/*
 * Summary: interface for the encoding conversion functions
 * Description: interface for the encoding conversion functions needed for
 *              XML basic encoding and iconv() support.
 *
 * Related specs are
 * rfc2044        (UTF-8 and UTF-16) F. Yergeau Alis Technologies
 * [ISO-10646]    UTF-8 and UTF-16 in Annexes
 * [ISO-8859-1]   ISO Latin-1 characters codes.
 * [UNICODE]      The Unicode Consortium, "The Unicode Standard --
 *                Worldwide Character Encoding -- Version 1.0", Addison-
 *                Wesley, Volume 1, 1991, Volume 2, 1992.  UTF-8 is
 *                described in Unicode Technical Report #4.
 * [US-ASCII]     Coded Character Set--7-bit American Standard Code for
 *                Information Interchange, ANSI X3.4-1986.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C) nothrow @system:

/*
 * xmlCharEncoding:
 *
 * Predefined values for some standard encodings.
 * Libxml does not do beforehand translation on UTF8 and ISOLatinX.
 * It also supports ASCII, ISO-8859-1, and UTF16 (LE and BE) by default.
 *
 * Anything else would have to be translated to UTF8 before being
 * given to the parser itself. The BOM for UTF16 and the encoding
 * declaration are looked at and a converter is looked for at that
 * point. If not found the parser stops here as asked by the XML REC. A
 * converter can be registered by the user using xmlRegisterCharEncodingHandler
 * but the current form doesn't allow stateful transcoding (a serious
 * problem agreed !). If iconv has been found it will be used
 * automatically and allow stateful transcoding, the simplest is then
 * to be sure to enable iconv and to provide iconv libs for the encoding
 * support needed.
 *
 * Note that the generic "UTF-16" is not a predefined value.  Instead, only
 * the specific UTF-16LE and UTF-16BE are present.
 */
enum xmlCharEncoding
{
    error = -1, /* No char encoding detected */
    none = 0, /* No char encoding detected */
    utf8 = 1, /* UTF-8 */
    utf16le = 2, /* UTF-16 little endian */
    utf16be = 3, /* UTF-16 big endian */
    ucs4le = 4, /* UCS-4 little endian */
    ucs4be = 5, /* UCS-4 big endian */
    ebcdic = 6, /* EBCDIC uh! */
    ucs42143 = 7, /* UCS-4 unusual ordering */
    ucs43412 = 8, /* UCS-4 unusual ordering */
    ucs2 = 9, /* UCS-2 */
    iso88591 = 10, /* ISO-8859-1 ISO Latin 1 */
    iso88592 = 11, /* ISO-8859-2 ISO Latin 2 */
    iso88593 = 12, /* ISO-8859-3 */
    iso88594 = 13, /* ISO-8859-4 */
    iso88595 = 14, /* ISO-8859-5 */
    iso88596 = 15, /* ISO-8859-6 */
    iso88597 = 16, /* ISO-8859-7 */
    iso88598 = 17, /* ISO-8859-8 */
    iso88599 = 18, /* ISO-8859-9 */
    iso2022Jp = 19, /* ISO-2022-JP */
    shiftJis = 20, /* Shift_JIS */
    eucJp = 21, /* EUC-JP */
    ascii = 22 /* pure ASCII */
}

/**
 * xmlCharEncodingInputFunc:
 * @out:  a pointer to an array of bytes to store the UTF-8 result
 * @outlen:  the length of @out
 * @in:  a pointer to an array of chars in the original encoding
 * @inlen:  the length of @in
 *
 * Take a block of chars in the original encoding and try to convert
 * it to an UTF-8 block of chars out.
 *
 * Returns the number of bytes written, -1 if lack of space, or -2
 *     if the transcoding failed.
 * The value of @inlen after return is the number of octets consumed
 *     if the return value is positive, else unpredictiable.
 * The value of @outlen after return is the number of octets consumed.
 */
alias xmlCharEncodingInputFunc = int function(
    ubyte* out_,
    int* outlen,
    const(ubyte)* in_,
    int* inlen);

/**
 * xmlCharEncodingOutputFunc:
 * @out:  a pointer to an array of bytes to store the result
 * @outlen:  the length of @out
 * @in:  a pointer to an array of UTF-8 chars
 * @inlen:  the length of @in
 *
 * Take a block of UTF-8 chars in and try to convert it to another
 * encoding.
 * Note: a first call designed to produce heading info is called with
 * in = NULL. If stateful this should also initialize the encoder state.
 *
 * Returns the number of bytes written, -1 if lack of space, or -2
 *     if the transcoding failed.
 * The value of @inlen after return is the number of octets consumed
 *     if the return value is positive, else unpredictiable.
 * The value of @outlen after return is the number of octets produced.
 */
alias xmlCharEncodingOutputFunc = int function(
    ubyte* out_,
    int* outlen,
    const(ubyte)* in_,
    int* inlen);

/*
 * Block defining the handlers for non UTF-8 encodings.
 * If iconv is supported, there are two extra fields.
 */

/* Size of pivot buffer, same as icu/source/common/ucnv.cpp CHUNK_SIZE */

/* for conversion between an encoding and UTF-16 */
/* for conversion between UTF-8 and UTF-16 */

alias xmlCharEncodingHandler = _xmlCharEncodingHandler;
alias xmlCharEncodingHandlerPtr = _xmlCharEncodingHandler*;

struct _xmlCharEncodingHandler
{
    char* name;
    xmlCharEncodingInputFunc input;
    xmlCharEncodingOutputFunc output;

    /* LIBXML_ICONV_ENABLED */

    /* LIBXML_ICU_ENABLED */
}

/*
 * Interfaces for encoding handlers.
 */
void xmlInitCharEncodingHandlers();
void xmlCleanupCharEncodingHandlers();
void xmlRegisterCharEncodingHandler(xmlCharEncodingHandlerPtr handler);
xmlCharEncodingHandlerPtr xmlGetCharEncodingHandler(xmlCharEncoding enc);
xmlCharEncodingHandlerPtr xmlFindCharEncodingHandler(const(char)* name);
xmlCharEncodingHandlerPtr xmlNewCharEncodingHandler(
    const(char)* name,
    xmlCharEncodingInputFunc input,
    xmlCharEncodingOutputFunc output);

/*
 * Interfaces for encoding names and aliases.
 */
int xmlAddEncodingAlias(const(char)* name, const(char)* alias_);
int xmlDelEncodingAlias(const(char)* alias_);
const(char)* xmlGetEncodingAlias(const(char)* alias_);
void xmlCleanupEncodingAliases();
xmlCharEncoding xmlParseCharEncoding(const(char)* name);
const(char)* xmlGetCharEncodingName(xmlCharEncoding enc);

/*
 * Interfaces directly used by the parsers.
 */
xmlCharEncoding xmlDetectCharEncoding(const(ubyte)* in_, int len);

int xmlCharEncOutFunc(
    xmlCharEncodingHandler* handler,
    xmlBufferPtr out_,
    xmlBufferPtr in_);

int xmlCharEncInFunc(
    xmlCharEncodingHandler* handler,
    xmlBufferPtr out_,
    xmlBufferPtr in_);
int xmlCharEncFirstLine(
    xmlCharEncodingHandler* handler,
    xmlBufferPtr out_,
    xmlBufferPtr in_);
int xmlCharEncCloseFunc(xmlCharEncodingHandler* handler);

/*
 * Export a few useful functions
 */

/* LIBXML_OUTPUT_ENABLED */
int isolat1ToUTF8(ubyte* out_, int* outlen, const(ubyte)* in_, int* inlen);

/* __XML_CHAR_ENCODING_H__ */
