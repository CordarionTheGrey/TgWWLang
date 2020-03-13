module c_libxml.xmlmemory;

import c_libxml.globals;
import c_libxml.threads;
import c_libxml.xmlversion;

/*
 * Summary: interface for the memory allocator
 * Description: provides interfaces for the memory allocator,
 *              including debugging capabilities.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

import core.stdc.config;
import core.stdc.stdio;

extern (C) nothrow:

/**
 * DEBUG_MEMORY:
 *
 * DEBUG_MEMORY replaces the allocator with a collect and debug
 * shell to the libc allocator.
 * DEBUG_MEMORY should only be activated when debugging
 * libxml i.e. if libxml has been configured with --with-debug-mem too.
 */
/* #define DEBUG_MEMORY_FREED */
/* #define DEBUG_MEMORY_LOCATION */

/**
 * DEBUG_MEMORY_LOCATION:
 *
 * DEBUG_MEMORY_LOCATION should be activated only when debugging
 * libxml i.e. if libxml has been configured with --with-debug-mem too.
 */

/*
 * The XML memory wrapper support 4 basic overloadable functions.
 */
/**
 * xmlFreeFunc:
 * @mem: an already allocated block of memory
 *
 * Signature for a free() implementation.
 */
alias xmlFreeFunc = void function(void* mem);
/**
 * xmlMallocFunc:
 * @size:  the size requested in bytes
 *
 * Signature for a malloc() implementation.
 *
 * Returns a pointer to the newly allocated block or NULL in case of error.
 */
alias xmlMallocFunc = void* function(size_t size);

/**
 * xmlReallocFunc:
 * @mem: an already allocated block of memory
 * @size:  the new size requested in bytes
 *
 * Signature for a realloc() implementation.
 *
 * Returns a pointer to the newly reallocated block or NULL in case of error.
 */
alias xmlReallocFunc = void* function(void* mem, size_t size);

/**
 * xmlStrdupFunc:
 * @str: a zero terminated string
 *
 * Signature for an strdup() implementation.
 *
 * Returns the copy of the string or NULL in case of error.
 */
alias xmlStrdupFunc = char* function(const(char)* str);

/*
 * The 4 interfaces used for all memory handling within libxml.
LIBXML_DLL_IMPORT xmlFreeFunc xmlFree;
LIBXML_DLL_IMPORT xmlMallocFunc xmlMalloc;
LIBXML_DLL_IMPORT xmlMallocFunc xmlMallocAtomic;
LIBXML_DLL_IMPORT xmlReallocFunc xmlRealloc;
LIBXML_DLL_IMPORT xmlStrdupFunc xmlMemStrdup;
 */

/*
 * The way to overload the existing functions.
 * The xmlGc function have an extra entry for atomic block
 * allocations useful for garbage collected memory allocators
 */
int xmlMemSetup(
    xmlFreeFunc freeFunc,
    xmlMallocFunc mallocFunc,
    xmlReallocFunc reallocFunc,
    xmlStrdupFunc strdupFunc);
int xmlMemGet(
    xmlFreeFunc* freeFunc,
    xmlMallocFunc* mallocFunc,
    xmlReallocFunc* reallocFunc,
    xmlStrdupFunc* strdupFunc);
int xmlGcMemSetup(
    xmlFreeFunc freeFunc,
    xmlMallocFunc mallocFunc,
    xmlMallocFunc mallocAtomicFunc,
    xmlReallocFunc reallocFunc,
    xmlStrdupFunc strdupFunc);
int xmlGcMemGet(
    xmlFreeFunc* freeFunc,
    xmlMallocFunc* mallocFunc,
    xmlMallocFunc* mallocAtomicFunc,
    xmlReallocFunc* reallocFunc,
    xmlStrdupFunc* strdupFunc);

/*
 * Initialization of the memory layer.
 */
int xmlInitMemory();

/*
 * Cleanup of the memory layer.
 */
void xmlCleanupMemory();
/*
 * These are specific to the XML debug memory wrapper.
 */
int xmlMemUsed();
int xmlMemBlocks();
void xmlMemDisplay(FILE* fp);
void xmlMemDisplayLast(FILE* fp, c_long nbBytes);
void xmlMemShow(FILE* fp, int nr);
void xmlMemoryDump();
void* xmlMemMalloc(size_t size);
void* xmlMemRealloc(void* ptr, size_t size);
void xmlMemFree(void* ptr);
char* xmlMemoryStrdup(const(char)* str);
void* xmlMallocLoc(size_t size, const(char)* file, int line);
void* xmlReallocLoc(void* ptr, size_t size, const(char)* file, int line);
void* xmlMallocAtomicLoc(size_t size, const(char)* file, int line);
char* xmlMemStrdupLoc(const(char)* str, const(char)* file, int line);

/**
 * xmlMalloc:
 * @size:  number of bytes to allocate
 *
 * Wrapper for the malloc() function used in the XML library.
 *
 * Returns the pointer to the allocated area or NULL in case of error.
 */

/**
 * xmlMallocAtomic:
 * @size:  number of bytes to allocate
 *
 * Wrapper for the malloc() function used in the XML library for allocation
 * of block not containing pointers to other areas.
 *
 * Returns the pointer to the allocated area or NULL in case of error.
 */

/**
 * xmlRealloc:
 * @ptr:  pointer to the existing allocated area
 * @size:  number of bytes to allocate
 *
 * Wrapper for the realloc() function used in the XML library.
 *
 * Returns the pointer to the allocated area or NULL in case of error.
 */

/**
 * xmlMemStrdup:
 * @str:  pointer to the existing string
 *
 * Wrapper for the strdup() function, xmlStrdup() is usually preferred.
 *
 * Returns the pointer to the allocated area or NULL in case of error.
 */

/* DEBUG_MEMORY_LOCATION */

/* __cplusplus */

/* __DEBUG_MEMORY_ALLOC__ */
