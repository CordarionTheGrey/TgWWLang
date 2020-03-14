module c_libxml.list;

import c_libxml.xmlversion;

/*
 * Summary: lists interfaces
 * Description: this module implement the list support used in
 * various place in the library.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Gary Pennington <Gary.Pennington@uk.sun.com>
 */

extern (C) nothrow @system:

struct _xmlLink;
alias xmlLink = _xmlLink;
alias xmlLinkPtr = _xmlLink*;

struct _xmlList;
alias xmlList = _xmlList;
alias xmlListPtr = _xmlList*;

/**
 * xmlListDeallocator:
 * @lk:  the data to deallocate
 *
 * Callback function used to free data from a list.
 */
alias xmlListDeallocator = void function(xmlLinkPtr lk);
/**
 * xmlListDataCompare:
 * @data0: the first data
 * @data1: the second data
 *
 * Callback function used to compare 2 data.
 *
 * Returns 0 is equality, -1 or 1 otherwise depending on the ordering.
 */
alias xmlListDataCompare = int function(const(void)* data0, const(void)* data1);
/**
 * xmlListWalker:
 * @data: the data found in the list
 * @user: extra user provided data to the walker
 *
 * Callback function used when walking a list with xmlListWalk().
 *
 * Returns 0 to stop walking the list, 1 otherwise.
 */
alias xmlListWalker = int function(const(void)* data, void* user);

/* Creation/Deletion */
xmlListPtr xmlListCreate(
    xmlListDeallocator deallocator,
    xmlListDataCompare compare);
void xmlListDelete(xmlListPtr l);

/* Basic Operators */
void* xmlListSearch(xmlListPtr l, void* data);
void* xmlListReverseSearch(xmlListPtr l, void* data);
int xmlListInsert(xmlListPtr l, void* data);
int xmlListAppend(xmlListPtr l, void* data);
int xmlListRemoveFirst(xmlListPtr l, void* data);
int xmlListRemoveLast(xmlListPtr l, void* data);
int xmlListRemoveAll(xmlListPtr l, void* data);
void xmlListClear(xmlListPtr l);
int xmlListEmpty(xmlListPtr l);
xmlLinkPtr xmlListFront(xmlListPtr l);
xmlLinkPtr xmlListEnd(xmlListPtr l);
int xmlListSize(xmlListPtr l);

void xmlListPopFront(xmlListPtr l);
void xmlListPopBack(xmlListPtr l);
int xmlListPushFront(xmlListPtr l, void* data);
int xmlListPushBack(xmlListPtr l, void* data);

/* Advanced Operators */
void xmlListReverse(xmlListPtr l);
void xmlListSort(xmlListPtr l);
void xmlListWalk(xmlListPtr l, xmlListWalker walker, void* user);
void xmlListReverseWalk(xmlListPtr l, xmlListWalker walker, void* user);
void xmlListMerge(xmlListPtr l1, xmlListPtr l2);
xmlListPtr xmlListDup(const xmlListPtr old);
int xmlListCopy(xmlListPtr cur, const xmlListPtr old);
/* Link operators */
void* xmlLinkGetData(xmlLinkPtr lk);

/* xmlListUnique() */
/* xmlListSwap */

/* __XML_LINK_INCLUDE__ */
