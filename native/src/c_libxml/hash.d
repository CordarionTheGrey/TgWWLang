module c_libxml.hash;

import c_libxml.dict;
import c_libxml.parser;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/*
 * Summary: Chained hash tables
 * Description: This module implements the hash table support used in
 *              various places in the library.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Bjorn Reese <bjorn.reese@systematic.dk>
 */

extern (C):

/*
 * The hash table.
 */
struct _xmlHashTable;
alias xmlHashTable = _xmlHashTable;
alias xmlHashTablePtr = _xmlHashTable*;

/*
 * Recent version of gcc produce a warning when a function pointer is assigned
 * to an object pointer, or vice versa.  The following macro is a dirty hack
 * to allow suppression of the warning.  If your architecture has function
 * pointers which are a different size than a void pointer, there may be some
 * serious trouble within the library.
 */
/**
 * XML_CAST_FPTR:
 * @fptr:  pointer to a function
 *
 * Macro to do a casting from an object pointer to a
 * function pointer without encountering a warning from
 * gcc
 *
 * #define XML_CAST_FPTR(fptr) (*(void **)(&fptr))
 * This macro violated ISO C aliasing rules (gcc4 on s390 broke)
 * so it is disabled now
 */

/*
 * function types:
 */
/**
 * xmlHashDeallocator:
 * @payload:  the data in the hash
 * @name:  the name associated
 *
 * Callback to free data from a hash.
 */
alias xmlHashDeallocator = void function(void* payload, const(xmlChar)* name);
/**
 * xmlHashCopier:
 * @payload:  the data in the hash
 * @name:  the name associated
 *
 * Callback to copy data from a hash.
 *
 * Returns a copy of the data or NULL in case of error.
 */
alias xmlHashCopier = void* function(void* payload, const(xmlChar)* name);
/**
 * xmlHashScanner:
 * @payload:  the data in the hash
 * @data:  extra scanner data
 * @name:  the name associated
 *
 * Callback when scanning data in a hash with the simple scanner.
 */
alias xmlHashScanner = void function(void* payload, void* data, const(xmlChar)* name);
/**
 * xmlHashScannerFull:
 * @payload:  the data in the hash
 * @data:  extra scanner data
 * @name:  the name associated
 * @name2:  the second name associated
 * @name3:  the third name associated
 *
 * Callback when scanning data in a hash with the full scanner.
 */
alias xmlHashScannerFull = void function(
    void* payload,
    void* data,
    const(xmlChar)* name,
    const(xmlChar)* name2,
    const(xmlChar)* name3);

/*
 * Constructor and destructor.
 */
xmlHashTablePtr xmlHashCreate(int size);
xmlHashTablePtr xmlHashCreateDict(int size, xmlDictPtr dict);
void xmlHashFree(xmlHashTablePtr table, xmlHashDeallocator f);
void xmlHashDefaultDeallocator(void* entry, const(xmlChar)* name);

/*
 * Add a new entry to the hash table.
 */
int xmlHashAddEntry(
    xmlHashTablePtr table,
    const(xmlChar)* name,
    void* userdata);
int xmlHashUpdateEntry(
    xmlHashTablePtr table,
    const(xmlChar)* name,
    void* userdata,
    xmlHashDeallocator f);
int xmlHashAddEntry2(
    xmlHashTablePtr table,
    const(xmlChar)* name,
    const(xmlChar)* name2,
    void* userdata);
int xmlHashUpdateEntry2(
    xmlHashTablePtr table,
    const(xmlChar)* name,
    const(xmlChar)* name2,
    void* userdata,
    xmlHashDeallocator f);
int xmlHashAddEntry3(
    xmlHashTablePtr table,
    const(xmlChar)* name,
    const(xmlChar)* name2,
    const(xmlChar)* name3,
    void* userdata);
int xmlHashUpdateEntry3(
    xmlHashTablePtr table,
    const(xmlChar)* name,
    const(xmlChar)* name2,
    const(xmlChar)* name3,
    void* userdata,
    xmlHashDeallocator f);

/*
 * Remove an entry from the hash table.
 */
int xmlHashRemoveEntry(
    xmlHashTablePtr table,
    const(xmlChar)* name,
    xmlHashDeallocator f);
int xmlHashRemoveEntry2(
    xmlHashTablePtr table,
    const(xmlChar)* name,
    const(xmlChar)* name2,
    xmlHashDeallocator f);
int xmlHashRemoveEntry3(
    xmlHashTablePtr table,
    const(xmlChar)* name,
    const(xmlChar)* name2,
    const(xmlChar)* name3,
    xmlHashDeallocator f);

/*
 * Retrieve the userdata.
 */
void* xmlHashLookup(xmlHashTablePtr table, const(xmlChar)* name);
void* xmlHashLookup2(
    xmlHashTablePtr table,
    const(xmlChar)* name,
    const(xmlChar)* name2);
void* xmlHashLookup3(
    xmlHashTablePtr table,
    const(xmlChar)* name,
    const(xmlChar)* name2,
    const(xmlChar)* name3);
void* xmlHashQLookup(
    xmlHashTablePtr table,
    const(xmlChar)* name,
    const(xmlChar)* prefix);
void* xmlHashQLookup2(
    xmlHashTablePtr table,
    const(xmlChar)* name,
    const(xmlChar)* prefix,
    const(xmlChar)* name2,
    const(xmlChar)* prefix2);
void* xmlHashQLookup3(
    xmlHashTablePtr table,
    const(xmlChar)* name,
    const(xmlChar)* prefix,
    const(xmlChar)* name2,
    const(xmlChar)* prefix2,
    const(xmlChar)* name3,
    const(xmlChar)* prefix3);

/*
 * Helpers.
 */
xmlHashTablePtr xmlHashCopy(xmlHashTablePtr table, xmlHashCopier f);
int xmlHashSize(xmlHashTablePtr table);
void xmlHashScan(xmlHashTablePtr table, xmlHashScanner f, void* data);
void xmlHashScan3(
    xmlHashTablePtr table,
    const(xmlChar)* name,
    const(xmlChar)* name2,
    const(xmlChar)* name3,
    xmlHashScanner f,
    void* data);
void xmlHashScanFull(xmlHashTablePtr table, xmlHashScannerFull f, void* data);
void xmlHashScanFull3(
    xmlHashTablePtr table,
    const(xmlChar)* name,
    const(xmlChar)* name2,
    const(xmlChar)* name3,
    xmlHashScannerFull f,
    void* data);

/* ! __XML_HASH_H__ */
