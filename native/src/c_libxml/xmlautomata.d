module c_libxml.xmlautomata;

import c_libxml.tree;
import c_libxml.xmlregexp;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/*
 * Summary: API to build regexp automata
 * Description: the API to build regexp automata
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C):

/**
 * xmlAutomataPtr:
 *
 * A libxml automata description, It can be compiled into a regexp
 */
struct _xmlAutomata;
alias xmlAutomata = _xmlAutomata;
alias xmlAutomataPtr = _xmlAutomata*;

/**
 * xmlAutomataStatePtr:
 *
 * A state int the automata description,
 */
struct _xmlAutomataState;
alias xmlAutomataState = _xmlAutomataState;
alias xmlAutomataStatePtr = _xmlAutomataState*;

/*
 * Building API
 */
xmlAutomataPtr xmlNewAutomata();
void xmlFreeAutomata(xmlAutomataPtr am);

xmlAutomataStatePtr xmlAutomataGetInitState(xmlAutomataPtr am);
int xmlAutomataSetFinalState(xmlAutomataPtr am, xmlAutomataStatePtr state);
xmlAutomataStatePtr xmlAutomataNewState(xmlAutomataPtr am);
xmlAutomataStatePtr xmlAutomataNewTransition(
    xmlAutomataPtr am,
    xmlAutomataStatePtr from,
    xmlAutomataStatePtr to,
    const(xmlChar)* token,
    void* data);
xmlAutomataStatePtr xmlAutomataNewTransition2(
    xmlAutomataPtr am,
    xmlAutomataStatePtr from,
    xmlAutomataStatePtr to,
    const(xmlChar)* token,
    const(xmlChar)* token2,
    void* data);
xmlAutomataStatePtr xmlAutomataNewNegTrans(
    xmlAutomataPtr am,
    xmlAutomataStatePtr from,
    xmlAutomataStatePtr to,
    const(xmlChar)* token,
    const(xmlChar)* token2,
    void* data);

xmlAutomataStatePtr xmlAutomataNewCountTrans(
    xmlAutomataPtr am,
    xmlAutomataStatePtr from,
    xmlAutomataStatePtr to,
    const(xmlChar)* token,
    int min,
    int max,
    void* data);
xmlAutomataStatePtr xmlAutomataNewCountTrans2(
    xmlAutomataPtr am,
    xmlAutomataStatePtr from,
    xmlAutomataStatePtr to,
    const(xmlChar)* token,
    const(xmlChar)* token2,
    int min,
    int max,
    void* data);
xmlAutomataStatePtr xmlAutomataNewOnceTrans(
    xmlAutomataPtr am,
    xmlAutomataStatePtr from,
    xmlAutomataStatePtr to,
    const(xmlChar)* token,
    int min,
    int max,
    void* data);
xmlAutomataStatePtr xmlAutomataNewOnceTrans2(
    xmlAutomataPtr am,
    xmlAutomataStatePtr from,
    xmlAutomataStatePtr to,
    const(xmlChar)* token,
    const(xmlChar)* token2,
    int min,
    int max,
    void* data);
xmlAutomataStatePtr xmlAutomataNewAllTrans(
    xmlAutomataPtr am,
    xmlAutomataStatePtr from,
    xmlAutomataStatePtr to,
    int lax);
xmlAutomataStatePtr xmlAutomataNewEpsilon(
    xmlAutomataPtr am,
    xmlAutomataStatePtr from,
    xmlAutomataStatePtr to);
xmlAutomataStatePtr xmlAutomataNewCountedTrans(
    xmlAutomataPtr am,
    xmlAutomataStatePtr from,
    xmlAutomataStatePtr to,
    int counter);
xmlAutomataStatePtr xmlAutomataNewCounterTrans(
    xmlAutomataPtr am,
    xmlAutomataStatePtr from,
    xmlAutomataStatePtr to,
    int counter);
int xmlAutomataNewCounter(xmlAutomataPtr am, int min, int max);

xmlRegexpPtr xmlAutomataCompile(xmlAutomataPtr am);
int xmlAutomataIsDeterminist(xmlAutomataPtr am);

/* LIBXML_AUTOMATA_ENABLED */
/* LIBXML_REGEXP_ENABLED */

/* __XML_AUTOMATA_H__ */
