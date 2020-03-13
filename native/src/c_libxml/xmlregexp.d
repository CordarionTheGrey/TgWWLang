module c_libxml.xmlregexp;

import c_libxml.dict;
import c_libxml.tree;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/*
 * Summary: regular expressions handling
 * Description: basic API for libxml regular expressions handling used
 *              for XML Schemas and validation.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

import core.stdc.stdio;

extern (C) nothrow:

/**
 * xmlRegexpPtr:
 *
 * A libxml regular expression, they can actually be far more complex
 * thank the POSIX regex expressions.
 */
struct _xmlRegexp;
alias xmlRegexp = _xmlRegexp;
alias xmlRegexpPtr = _xmlRegexp*;

/**
 * xmlRegExecCtxtPtr:
 *
 * A libxml progressive regular expression evaluation context
 */
struct _xmlRegExecCtxt;
alias xmlRegExecCtxt = _xmlRegExecCtxt;
alias xmlRegExecCtxtPtr = _xmlRegExecCtxt*;

/*
 * The POSIX like API
 */
xmlRegexpPtr xmlRegexpCompile(const(xmlChar)* regexp);
void xmlRegFreeRegexp(xmlRegexpPtr regexp);
int xmlRegexpExec(xmlRegexpPtr comp, const(xmlChar)* value);
void xmlRegexpPrint(FILE* output, xmlRegexpPtr regexp);
int xmlRegexpIsDeterminist(xmlRegexpPtr comp);

/**
 * xmlRegExecCallbacks:
 * @exec: the regular expression context
 * @token: the current token string
 * @transdata: transition data
 * @inputdata: input data
 *
 * Callback function when doing a transition in the automata
 */
alias xmlRegExecCallbacks = void function(
    xmlRegExecCtxtPtr exec,
    const(xmlChar)* token,
    void* transdata,
    void* inputdata);

/*
 * The progressive API
 */
xmlRegExecCtxtPtr xmlRegNewExecCtxt(
    xmlRegexpPtr comp,
    xmlRegExecCallbacks callback,
    void* data);
void xmlRegFreeExecCtxt(xmlRegExecCtxtPtr exec);
int xmlRegExecPushString(
    xmlRegExecCtxtPtr exec,
    const(xmlChar)* value,
    void* data);
int xmlRegExecPushString2(
    xmlRegExecCtxtPtr exec,
    const(xmlChar)* value,
    const(xmlChar)* value2,
    void* data);

int xmlRegExecNextValues(
    xmlRegExecCtxtPtr exec,
    int* nbval,
    int* nbneg,
    xmlChar** values,
    int* terminal);
int xmlRegExecErrInfo(
    xmlRegExecCtxtPtr exec,
    const(xmlChar*)* string,
    int* nbval,
    int* nbneg,
    xmlChar** values,
    int* terminal);

/*
 * Formal regular expression handling
 * Its goal is to do some formal work on content models
 */

/* expressions are used within a context */

/* Expressions are trees but the tree is opaque */

/*
 * 2 core expressions shared by all for the empty language set
 * and for the set with just the empty token
 */

/*
 * Expressions are reference counted internally
 */

/*
 * constructors can be either manual or from a string
 */

/*
 * The really interesting APIs
 */

/* LIBXML_EXPR_ENABLED */

/* LIBXML_REGEXP_ENABLED */

/*__XML_REGEXP_H__ */
