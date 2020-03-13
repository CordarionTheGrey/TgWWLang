module c_libxml.xmlexports;

/*
 * Summary: macros for marking symbols as exportable/importable.
 * Description: macros for marking symbols as exportable/importable.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Igor Zlatovic <igor@zlatkovic.com>
 */

extern (C) nothrow:

/**
 * XMLPUBFUN, XMLPUBVAR, XMLCALL
 *
 * Macros which declare an exportable function, an exportable variable and
 * the calling convention used for functions.
 *
 * Please use an extra block for every platform/compiler combination when
 * modifying this, rather than overlong #ifdef lines. This helps
 * readability as well as the fact that different compilers on the same
 * platform might need different definitions.
 */

/**
 * XMLPUBFUN:
 *
 * Macros which declare an exportable function
 */
/**
 * XMLPUBVAR:
 *
 * Macros which declare an exportable variable
 */
/**
 * XMLCALL:
 *
 * Macros which declare the called convention for exported functions
 */
/**
 * XMLCDECL:
 *
 * Macro which declares the calling convention for exported functions that
 * use '...'.
 */

/** DOC_DISABLE */

/* Windows platform with MS compiler */

/* Windows platform with Borland compiler */

/* Windows platform with GNU compiler (Mingw) */

/*
 * if defined(IN_LIBXML) this raises problems on mingw with msys
 * _imp__xmlFree listed as missing. Try to workaround the problem
 * by also making that declaration when compiling client code.
 */

/* Cygwin platform (does not define _WIN32), GNU compiler */

/* Compatibility */

/* __XML_EXPORTS_H__ */
