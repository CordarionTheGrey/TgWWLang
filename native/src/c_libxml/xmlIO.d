module c_libxml.xmlIO;

import c_libxml.encoding;
import c_libxml.globals;
import c_libxml.parser;
import c_libxml.tree;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/*
 * Summary: interface for the I/O interfaces used by the parser
 * Description: interface for the I/O interfaces used by the parser
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

import core.stdc.config;
import core.stdc.stdio;

extern (C):

/*
 * Those are the functions and datatypes for the parser input
 * I/O structures.
 */

/**
 * xmlInputMatchCallback:
 * @filename: the filename or URI
 *
 * Callback used in the I/O Input API to detect if the current handler
 * can provide input functionality for this resource.
 *
 * Returns 1 if yes and 0 if another Input module should be used
 */
alias xmlInputMatchCallback = int function(const(char)* filename);
/**
 * xmlInputOpenCallback:
 * @filename: the filename or URI
 *
 * Callback used in the I/O Input API to open the resource
 *
 * Returns an Input context or NULL in case or error
 */
alias xmlInputOpenCallback = void* function(const(char)* filename);
/**
 * xmlInputReadCallback:
 * @context:  an Input context
 * @buffer:  the buffer to store data read
 * @len:  the length of the buffer in bytes
 *
 * Callback used in the I/O Input API to read the resource
 *
 * Returns the number of bytes read or -1 in case of error
 */
alias xmlInputReadCallback = int function(void* context, char* buffer, int len);
/**
 * xmlInputCloseCallback:
 * @context:  an Input context
 *
 * Callback used in the I/O Input API to close the resource
 *
 * Returns 0 or -1 in case of error
 */
alias xmlInputCloseCallback = int function(void* context);

/*
 * Those are the functions and datatypes for the library output
 * I/O structures.
 */

/**
 * xmlOutputMatchCallback:
 * @filename: the filename or URI
 *
 * Callback used in the I/O Output API to detect if the current handler
 * can provide output functionality for this resource.
 *
 * Returns 1 if yes and 0 if another Output module should be used
 */

/**
 * xmlOutputOpenCallback:
 * @filename: the filename or URI
 *
 * Callback used in the I/O Output API to open the resource
 *
 * Returns an Output context or NULL in case or error
 */

/**
 * xmlOutputWriteCallback:
 * @context:  an Output context
 * @buffer:  the buffer of data to write
 * @len:  the length of the buffer in bytes
 *
 * Callback used in the I/O Output API to write to the resource
 *
 * Returns the number of bytes written or -1 in case of error
 */

/**
 * xmlOutputCloseCallback:
 * @context:  an Output context
 *
 * Callback used in the I/O Output API to close the resource
 *
 * Returns 0 or -1 in case of error
 */

/* LIBXML_OUTPUT_ENABLED */

struct _xmlParserInputBuffer
{
    void* context;
    xmlInputReadCallback readcallback;
    xmlInputCloseCallback closecallback;

    xmlCharEncodingHandlerPtr encoder; /* I18N conversions to UTF-8 */

    xmlBufPtr buffer; /* Local buffer encoded in UTF-8 */
    xmlBufPtr raw; /* if encoder != NULL buffer for raw input */
    int compressed; /* -1=unknown, 0=not compressed, 1=compressed */
    int error;
    c_ulong rawconsumed; /* amount consumed from raw */
}

/* I18N conversions to UTF-8 */

/* Local buffer encoded in UTF-8 or ISOLatin */
/* if encoder != NULL buffer for output */
/* total number of byte written */

/* LIBXML_OUTPUT_ENABLED */

/*
 * Interfaces for input
 */
void xmlCleanupInputCallbacks();

int xmlPopInputCallbacks();

void xmlRegisterDefaultInputCallbacks();
xmlParserInputBufferPtr xmlAllocParserInputBuffer(xmlCharEncoding enc);

xmlParserInputBufferPtr xmlParserInputBufferCreateFilename(
    const(char)* URI,
    xmlCharEncoding enc);
xmlParserInputBufferPtr xmlParserInputBufferCreateFile(
    FILE* file,
    xmlCharEncoding enc);
xmlParserInputBufferPtr xmlParserInputBufferCreateFd(
    int fd,
    xmlCharEncoding enc);
xmlParserInputBufferPtr xmlParserInputBufferCreateMem(
    const(char)* mem,
    int size,
    xmlCharEncoding enc);
xmlParserInputBufferPtr xmlParserInputBufferCreateStatic(
    const(char)* mem,
    int size,
    xmlCharEncoding enc);
xmlParserInputBufferPtr xmlParserInputBufferCreateIO(
    xmlInputReadCallback ioread,
    xmlInputCloseCallback ioclose,
    void* ioctx,
    xmlCharEncoding enc);
int xmlParserInputBufferRead(xmlParserInputBufferPtr in_, int len);
int xmlParserInputBufferGrow(xmlParserInputBufferPtr in_, int len);
int xmlParserInputBufferPush(
    xmlParserInputBufferPtr in_,
    int len,
    const(char)* buf);
void xmlFreeParserInputBuffer(xmlParserInputBufferPtr in_);
char* xmlParserGetDirectory(const(char)* filename);

int xmlRegisterInputCallbacks(
    xmlInputMatchCallback matchFunc,
    xmlInputOpenCallback openFunc,
    xmlInputReadCallback readFunc,
    xmlInputCloseCallback closeFunc);

xmlParserInputBufferPtr __xmlParserInputBufferCreateFilename(
    const(char)* URI,
    xmlCharEncoding enc);

/*
 * Interfaces for output
 */

/* Couple of APIs to get the output without digging into the buffers */

/*  This function only exists if HTTP support built into the library  */

/* LIBXML_HTTP_ENABLED */

/* LIBXML_OUTPUT_ENABLED */

xmlParserInputPtr xmlCheckHTTPInput(
    xmlParserCtxtPtr ctxt,
    xmlParserInputPtr ret);

/*
 * A predefined entity loader disabling network accesses
 */
xmlParserInputPtr xmlNoNetExternalEntityLoader(
    const(char)* URL,
    const(char)* ID,
    xmlParserCtxtPtr ctxt);

/*
 * xmlNormalizeWindowsPath is obsolete, don't use it.
 * Check xmlCanonicPath in uri.h for a better alternative.
 */
xmlChar* xmlNormalizeWindowsPath(const(xmlChar)* path);

int xmlCheckFilename(const(char)* path);
/**
 * Default 'file://' protocol callbacks
 */
int xmlFileMatch(const(char)* filename);
void* xmlFileOpen(const(char)* filename);
int xmlFileRead(void* context, char* buffer, int len);
int xmlFileClose(void* context);

/**
 * Default 'http://' protocol callbacks
 */

/* LIBXML_OUTPUT_ENABLED */

/* LIBXML_HTTP_ENABLED */

/**
 * Default 'ftp://' protocol callbacks
 */

/* LIBXML_FTP_ENABLED */

/* __XML_IO_H__ */
