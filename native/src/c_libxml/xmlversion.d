module c_libxml.xmlversion;

import c_libxml.xmlexports;

/*
 * Summary: compile-time version informations
 * Description: compile-time version informations for the XML library
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C) nothrow:

/*
 * use those to be sure nothing nasty will happen if
 * your library and includes mismatch
 */

void xmlCheckVersion(int version_);
/* LIBXML2_COMPILING_MSCCDEF */

/**
 * LIBXML_DOTTED_VERSION:
 *
 * the version string like "1.2.3"
 */
enum LIBXML_DOTTED_VERSION = "2.9.10";

/**
 * LIBXML_VERSION:
 *
 * the version number: 1.2.3 value is 10203
 */
enum LIBXML_VERSION = 20910;

/**
 * LIBXML_VERSION_STRING:
 *
 * the version number string, 1.2.3 value is "10203"
 */
enum LIBXML_VERSION_STRING = "20910";

/**
 * LIBXML_VERSION_EXTRA:
 *
 * extra version information, used to show a CVS compilation
 */
enum LIBXML_VERSION_EXTRA = "";

/**
 * LIBXML_TEST_VERSION:
 *
 * Macro to check that the libxml version in use is compatible with
 * the version the software has been compiled against
 */

/**
 * WITH_TRIO:
 *
 * defined if the trio support need to be configured in
 */

/**
 * WITHOUT_TRIO:
 *
 * defined if the trio support should not be configured in
 */

/* VMS */
/**
 * WITH_TRIO:
 *
 * defined if the trio support need to be configured in
 */

/* VMS */

/**
 * LIBXML_THREAD_ENABLED:
 *
 * Whether the thread support is configured in
 */

/**
 * LIBXML_THREAD_ALLOC_ENABLED:
 *
 * Whether the allocation hooks are per-thread
 */

/**
 * LIBXML_TREE_ENABLED:
 *
 * Whether the DOM like tree manipulation API support is configured in
 */

/**
 * LIBXML_OUTPUT_ENABLED:
 *
 * Whether the serialization/saving support is configured in
 */

/**
 * LIBXML_PUSH_ENABLED:
 *
 * Whether the push parsing interfaces are configured in
 */

/**
 * LIBXML_READER_ENABLED:
 *
 * Whether the xmlReader parsing interface is configured in
 */

/**
 * LIBXML_PATTERN_ENABLED:
 *
 * Whether the xmlPattern node selection interface is configured in
 */

/**
 * LIBXML_WRITER_ENABLED:
 *
 * Whether the xmlWriter saving interface is configured in
 */

/**
 * LIBXML_SAX1_ENABLED:
 *
 * Whether the older SAX1 interface is configured in
 */

/**
 * LIBXML_FTP_ENABLED:
 *
 * Whether the FTP support is configured in
 */

/**
 * LIBXML_HTTP_ENABLED:
 *
 * Whether the HTTP support is configured in
 */

/**
 * LIBXML_VALID_ENABLED:
 *
 * Whether the DTD validation support is configured in
 */

/**
 * LIBXML_HTML_ENABLED:
 *
 * Whether the HTML support is configured in
 */

/**
 * LIBXML_LEGACY_ENABLED:
 *
 * Whether the deprecated APIs are compiled in for compatibility
 */

/**
 * LIBXML_C14N_ENABLED:
 *
 * Whether the Canonicalization support is configured in
 */

/**
 * LIBXML_CATALOG_ENABLED:
 *
 * Whether the Catalog support is configured in
 */

/**
 * LIBXML_DOCB_ENABLED:
 *
 * Whether the SGML Docbook support is configured in
 */

/**
 * LIBXML_XPATH_ENABLED:
 *
 * Whether XPath is configured in
 */

/**
 * LIBXML_XPTR_ENABLED:
 *
 * Whether XPointer is configured in
 */

/**
 * LIBXML_XINCLUDE_ENABLED:
 *
 * Whether XInclude is configured in
 */

/**
 * LIBXML_ICONV_ENABLED:
 *
 * Whether iconv support is available
 */

/**
 * LIBXML_ICU_ENABLED:
 *
 * Whether icu support is available
 */

/**
 * LIBXML_ISO8859X_ENABLED:
 *
 * Whether ISO-8859-* support is made available in case iconv is not
 */

/**
 * LIBXML_DEBUG_ENABLED:
 *
 * Whether Debugging module is configured in
 */

/**
 * DEBUG_MEMORY_LOCATION:
 *
 * Whether the memory debugging is configured in
 */

/**
 * LIBXML_DEBUG_RUNTIME:
 *
 * Whether the runtime debugging is configured in
 */

/**
 * LIBXML_UNICODE_ENABLED:
 *
 * Whether the Unicode related interfaces are compiled in
 */

/**
 * LIBXML_REGEXP_ENABLED:
 *
 * Whether the regular expressions interfaces are compiled in
 */

/**
 * LIBXML_AUTOMATA_ENABLED:
 *
 * Whether the automata interfaces are compiled in
 */

/**
 * LIBXML_EXPR_ENABLED:
 *
 * Whether the formal expressions interfaces are compiled in
 *
 * This code is unused and disabled unconditionally for now.
 */

/**
 * LIBXML_SCHEMAS_ENABLED:
 *
 * Whether the Schemas validation interfaces are compiled in
 */

/**
 * LIBXML_SCHEMATRON_ENABLED:
 *
 * Whether the Schematron validation interfaces are compiled in
 */

/**
 * LIBXML_MODULES_ENABLED:
 *
 * Whether the module interfaces are compiled in
 */

/**
 * LIBXML_MODULE_EXTENSION:
 *
 * the string suffix used by dynamic modules (usually shared libraries)
 */

/**
 * LIBXML_ZLIB_ENABLED:
 *
 * Whether the Zlib support is compiled in
 */

/**
 * LIBXML_LZMA_ENABLED:
 *
 * Whether the Lzma support is compiled in
 */

/**
 * ATTRIBUTE_UNUSED:
 *
 * Macro used to signal to GCC unused function parameters
 */

/**
 * LIBXML_ATTR_ALLOC_SIZE:
 *
 * Macro used to indicate to GCC this is an allocator function
 */

/**
 * LIBXML_ATTR_FORMAT:
 *
 * Macro used to indicate to GCC the parameter are printf like
 */

/* ! __GNUC__ */
/**
 * ATTRIBUTE_UNUSED:
 *
 * Macro used to signal to GCC unused function parameters
 */

/**
 * LIBXML_ATTR_ALLOC_SIZE:
 *
 * Macro used to indicate to GCC this is an allocator function
 */

/**
 * LIBXML_ATTR_FORMAT:
 *
 * Macro used to indicate to GCC the parameter are printf like
 */

/* __GNUC__ */

/* __cplusplus */
