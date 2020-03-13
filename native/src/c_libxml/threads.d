module c_libxml.threads;

import c_libxml.globals;
import c_libxml.xmlversion;

/**
 * Summary: interfaces for thread handling
 * Description: set of generic threading related routines
 *              should work with pthreads, Windows native or TLS threads
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C) nothrow:

/*
 * xmlMutex are a simple mutual exception locks.
 */
struct _xmlMutex;
alias xmlMutex = _xmlMutex;
alias xmlMutexPtr = _xmlMutex*;

/*
 * xmlRMutex are reentrant mutual exception locks.
 */
struct _xmlRMutex;
alias xmlRMutex = _xmlRMutex;
alias xmlRMutexPtr = _xmlRMutex*;

xmlMutexPtr xmlNewMutex();
void xmlMutexLock(xmlMutexPtr tok);
void xmlMutexUnlock(xmlMutexPtr tok);
void xmlFreeMutex(xmlMutexPtr tok);

xmlRMutexPtr xmlNewRMutex();
void xmlRMutexLock(xmlRMutexPtr tok);
void xmlRMutexUnlock(xmlRMutexPtr tok);
void xmlFreeRMutex(xmlRMutexPtr tok);

/*
 * Library wide APIs.
 */
void xmlInitThreads();
void xmlLockLibrary();
void xmlUnlockLibrary();
int xmlGetThreadId();
int xmlIsMainThread();
void xmlCleanupThreads();
xmlGlobalStatePtr xmlGetGlobalState();

/* __XML_THREADS_H__ */
