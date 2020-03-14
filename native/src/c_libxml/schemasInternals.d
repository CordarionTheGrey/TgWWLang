module c_libxml.schemasInternals;

import c_libxml.dict;
import c_libxml.hash;
import c_libxml.tree;
import c_libxml.xmlregexp;
import c_libxml.xmlstring;
import c_libxml.xmlversion;

/*
 * Summary: internal interfaces for XML Schemas
 * Description: internal interfaces for the XML Schemas handling
 *              and schema validity checking
 *              The Schemas development is a Work In Progress.
 *              Some of those interfaces are not guaranteed to be API or ABI stable !
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C) nothrow @system:

enum xmlSchemaValType
{
    unknown = 0,
    string = 1,
    normstring = 2,
    decimal = 3,
    time = 4,
    gday = 5,
    gmonth = 6,
    gmonthday = 7,
    gyear = 8,
    gyearmonth = 9,
    date = 10,
    datetime = 11,
    duration = 12,
    float_ = 13,
    double_ = 14,
    boolean = 15,
    token = 16,
    language = 17,
    nmtoken = 18,
    nmtokens = 19,
    name = 20,
    qname = 21,
    ncname = 22,
    id = 23,
    idref = 24,
    idrefs = 25,
    entity = 26,
    entities = 27,
    notation = 28,
    anyuri = 29,
    integer = 30,
    npinteger = 31,
    ninteger = 32,
    nninteger = 33,
    pinteger = 34,
    int_ = 35,
    uint_ = 36,
    long_ = 37,
    ulong_ = 38,
    short_ = 39,
    ushort_ = 40,
    byte_ = 41,
    ubyte_ = 42,
    hexbinary = 43,
    base64binary = 44,
    anytype = 45,
    anysimpletype = 46
}

/*
 * XML Schemas defines multiple type of types.
 */
enum xmlSchemaTypeType
{
    typeBasic = 1, /* A built-in datatype */
    typeAny = 2,
    typeFacet = 3,
    typeSimple = 4,
    typeComplex = 5,
    typeSequence = 6,
    typeChoice = 7,
    typeAll = 8,
    typeSimpleContent = 9,
    typeComplexContent = 10,
    typeUr = 11,
    typeRestriction = 12,
    typeExtension = 13,
    typeElement = 14,
    typeAttribute = 15,
    typeAttributegroup = 16,
    typeGroup = 17,
    typeNotation = 18,
    typeList = 19,
    typeUnion = 20,
    typeAnyAttribute = 21,
    typeIdcUnique = 22,
    typeIdcKey = 23,
    typeIdcKeyref = 24,
    typeParticle = 25,
    typeAttributeUse = 26,
    facetMininclusive = 1000,
    facetMinexclusive = 1001,
    facetMaxinclusive = 1002,
    facetMaxexclusive = 1003,
    facetTotaldigits = 1004,
    facetFractiondigits = 1005,
    facetPattern = 1006,
    facetEnumeration = 1007,
    facetWhitespace = 1008,
    facetLength = 1009,
    facetMaxlength = 1010,
    facetMinlength = 1011,
    extraQnameref = 2000,
    extraAttrUseProhib = 2001
}

enum xmlSchemaContentType
{
    unknown = 0,
    empty = 1,
    elements = 2,
    mixed = 3,
    simple = 4,
    mixedOrElements = 5, /* Obsolete */
    basic = 6,
    any = 7
}

struct _xmlSchemaVal;
alias xmlSchemaVal = _xmlSchemaVal;
alias xmlSchemaValPtr = _xmlSchemaVal*;

alias xmlSchemaType = _xmlSchemaType;
alias xmlSchemaTypePtr = _xmlSchemaType*;

alias xmlSchemaFacet = _xmlSchemaFacet;
alias xmlSchemaFacetPtr = _xmlSchemaFacet*;

/**
 * Annotation
 */
alias xmlSchemaAnnot = _xmlSchemaAnnot;
alias xmlSchemaAnnotPtr = _xmlSchemaAnnot*;

struct _xmlSchemaAnnot
{
    _xmlSchemaAnnot* next;
    xmlNodePtr content; /* the annotation */
}

/**
 * XML_SCHEMAS_ANYATTR_SKIP:
 *
 * Skip unknown attribute from validation
 * Obsolete, not used anymore.
 */
enum XML_SCHEMAS_ANYATTR_SKIP = 1;
/**
 * XML_SCHEMAS_ANYATTR_LAX:
 *
 * Ignore validation non definition on attributes
 * Obsolete, not used anymore.
 */
enum XML_SCHEMAS_ANYATTR_LAX = 2;
/**
 * XML_SCHEMAS_ANYATTR_STRICT:
 *
 * Apply strict validation rules on attributes
 * Obsolete, not used anymore.
 */
enum XML_SCHEMAS_ANYATTR_STRICT = 3;
/**
 * XML_SCHEMAS_ANY_SKIP:
 *
 * Skip unknown attribute from validation
 */
enum XML_SCHEMAS_ANY_SKIP = 1;
/**
 * XML_SCHEMAS_ANY_LAX:
 *
 * Used by wildcards.
 * Validate if type found, don't worry if not found
 */
enum XML_SCHEMAS_ANY_LAX = 2;
/**
 * XML_SCHEMAS_ANY_STRICT:
 *
 * Used by wildcards.
 * Apply strict validation rules
 */
enum XML_SCHEMAS_ANY_STRICT = 3;
/**
 * XML_SCHEMAS_ATTR_USE_PROHIBITED:
 *
 * Used by wildcards.
 * The attribute is prohibited.
 */
enum XML_SCHEMAS_ATTR_USE_PROHIBITED = 0;
/**
 * XML_SCHEMAS_ATTR_USE_REQUIRED:
 *
 * The attribute is required.
 */
enum XML_SCHEMAS_ATTR_USE_REQUIRED = 1;
/**
 * XML_SCHEMAS_ATTR_USE_OPTIONAL:
 *
 * The attribute is optional.
 */
enum XML_SCHEMAS_ATTR_USE_OPTIONAL = 2;
/**
 * XML_SCHEMAS_ATTR_GLOBAL:
 *
 * allow elements in no namespace
 */
enum XML_SCHEMAS_ATTR_GLOBAL = 1 << 0;
/**
 * XML_SCHEMAS_ATTR_NSDEFAULT:
 *
 * allow elements in no namespace
 */
enum XML_SCHEMAS_ATTR_NSDEFAULT = 1 << 7;
/**
 * XML_SCHEMAS_ATTR_INTERNAL_RESOLVED:
 *
 * this is set when the "type" and "ref" references
 * have been resolved.
 */
enum XML_SCHEMAS_ATTR_INTERNAL_RESOLVED = 1 << 8;
/**
 * XML_SCHEMAS_ATTR_FIXED:
 *
 * the attribute has a fixed value
 */
enum XML_SCHEMAS_ATTR_FIXED = 1 << 9;

/**
 * xmlSchemaAttribute:
 * An attribute definition.
 */

alias xmlSchemaAttribute = _xmlSchemaAttribute;
alias xmlSchemaAttributePtr = _xmlSchemaAttribute*;

struct _xmlSchemaAttribute
{
    xmlSchemaTypeType type;
    _xmlSchemaAttribute* next; /* the next attribute (not used?) */
    const(xmlChar)* name; /* the name of the declaration */
    const(xmlChar)* id; /* Deprecated; not used */
    const(xmlChar)* ref_; /* Deprecated; not used */
    const(xmlChar)* refNs; /* Deprecated; not used */
    const(xmlChar)* typeName; /* the local name of the type definition */
    const(xmlChar)* typeNs; /* the ns URI of the type definition */
    xmlSchemaAnnotPtr annot;

    xmlSchemaTypePtr base; /* Deprecated; not used */
    int occurs; /* Deprecated; not used */
    const(xmlChar)* defValue; /* The initial value of the value constraint */
    xmlSchemaTypePtr subtypes; /* the type definition */
    xmlNodePtr node;
    const(xmlChar)* targetNamespace;
    int flags;
    const(xmlChar)* refPrefix; /* Deprecated; not used */
    xmlSchemaValPtr defVal; /* The compiled value constraint */
    xmlSchemaAttributePtr refDecl; /* Deprecated; not used */
}

/**
 * xmlSchemaAttributeLink:
 * Used to build a list of attribute uses on complexType definitions.
 * WARNING: Deprecated; not used.
 */
alias xmlSchemaAttributeLink = _xmlSchemaAttributeLink;
alias xmlSchemaAttributeLinkPtr = _xmlSchemaAttributeLink*;

struct _xmlSchemaAttributeLink
{
    _xmlSchemaAttributeLink* next; /* the next attribute link ... */
    _xmlSchemaAttribute* attr; /* the linked attribute */
}

/**
 * XML_SCHEMAS_WILDCARD_COMPLETE:
 *
 * If the wildcard is complete.
 */
enum XML_SCHEMAS_WILDCARD_COMPLETE = 1 << 0;

/**
 * xmlSchemaCharValueLink:
 * Used to build a list of namespaces on wildcards.
 */
alias xmlSchemaWildcardNs = _xmlSchemaWildcardNs;
alias xmlSchemaWildcardNsPtr = _xmlSchemaWildcardNs*;

struct _xmlSchemaWildcardNs
{
    _xmlSchemaWildcardNs* next; /* the next constraint link ... */
    const(xmlChar)* value; /* the value */
}

/**
 * xmlSchemaWildcard.
 * A wildcard.
 */
alias xmlSchemaWildcard = _xmlSchemaWildcard;
alias xmlSchemaWildcardPtr = _xmlSchemaWildcard*;

struct _xmlSchemaWildcard
{
    xmlSchemaTypeType type; /* The kind of type */
    const(xmlChar)* id; /* Deprecated; not used */
    xmlSchemaAnnotPtr annot;
    xmlNodePtr node;
    int minOccurs; /* Deprecated; not used */
    int maxOccurs; /* Deprecated; not used */
    int processContents;
    int any; /* Indicates if the ns constraint is of ##any */
    xmlSchemaWildcardNsPtr nsSet; /* The list of allowed namespaces */
    xmlSchemaWildcardNsPtr negNsSet; /* The negated namespace */
    int flags;
}

/**
 * XML_SCHEMAS_ATTRGROUP_WILDCARD_BUILDED:
 *
 * The attribute wildcard has been built.
 */
enum XML_SCHEMAS_ATTRGROUP_WILDCARD_BUILDED = 1 << 0;
/**
 * XML_SCHEMAS_ATTRGROUP_GLOBAL:
 *
 * The attribute group has been defined.
 */
enum XML_SCHEMAS_ATTRGROUP_GLOBAL = 1 << 1;
/**
 * XML_SCHEMAS_ATTRGROUP_MARKED:
 *
 * Marks the attr group as marked; used for circular checks.
 */
enum XML_SCHEMAS_ATTRGROUP_MARKED = 1 << 2;

/**
 * XML_SCHEMAS_ATTRGROUP_REDEFINED:
 *
 * The attr group was redefined.
 */
enum XML_SCHEMAS_ATTRGROUP_REDEFINED = 1 << 3;
/**
 * XML_SCHEMAS_ATTRGROUP_HAS_REFS:
 *
 * Whether this attr. group contains attr. group references.
 */
enum XML_SCHEMAS_ATTRGROUP_HAS_REFS = 1 << 4;

/**
 * An attribute group definition.
 *
 * xmlSchemaAttribute and xmlSchemaAttributeGroup start of structures
 * must be kept similar
 */
alias xmlSchemaAttributeGroup = _xmlSchemaAttributeGroup;
alias xmlSchemaAttributeGroupPtr = _xmlSchemaAttributeGroup*;

struct _xmlSchemaAttributeGroup
{
    xmlSchemaTypeType type; /* The kind of type */
    _xmlSchemaAttribute* next; /* the next attribute if in a group ... */
    const(xmlChar)* name;
    const(xmlChar)* id;
    const(xmlChar)* ref_; /* Deprecated; not used */
    const(xmlChar)* refNs; /* Deprecated; not used */
    xmlSchemaAnnotPtr annot;

    xmlSchemaAttributePtr attributes; /* Deprecated; not used */
    xmlNodePtr node;
    int flags;
    xmlSchemaWildcardPtr attributeWildcard;
    const(xmlChar)* refPrefix; /* Deprecated; not used */
    xmlSchemaAttributeGroupPtr refItem; /* Deprecated; not used */
    const(xmlChar)* targetNamespace;
    void* attrUses;
}

/**
 * xmlSchemaTypeLink:
 * Used to build a list of types (e.g. member types of
 * simpleType with variety "union").
 */
alias xmlSchemaTypeLink = _xmlSchemaTypeLink;
alias xmlSchemaTypeLinkPtr = _xmlSchemaTypeLink*;

struct _xmlSchemaTypeLink
{
    _xmlSchemaTypeLink* next; /* the next type link ... */
    xmlSchemaTypePtr type; /* the linked type */
}

/**
 * xmlSchemaFacetLink:
 * Used to build a list of facets.
 */
alias xmlSchemaFacetLink = _xmlSchemaFacetLink;
alias xmlSchemaFacetLinkPtr = _xmlSchemaFacetLink*;

struct _xmlSchemaFacetLink
{
    _xmlSchemaFacetLink* next; /* the next facet link ... */
    xmlSchemaFacetPtr facet; /* the linked facet */
}

/**
 * XML_SCHEMAS_TYPE_MIXED:
 *
 * the element content type is mixed
 */
enum XML_SCHEMAS_TYPE_MIXED = 1 << 0;
/**
 * XML_SCHEMAS_TYPE_DERIVATION_METHOD_EXTENSION:
 *
 * the simple or complex type has a derivation method of "extension".
 */
enum XML_SCHEMAS_TYPE_DERIVATION_METHOD_EXTENSION = 1 << 1;
/**
 * XML_SCHEMAS_TYPE_DERIVATION_METHOD_RESTRICTION:
 *
 * the simple or complex type has a derivation method of "restriction".
 */
enum XML_SCHEMAS_TYPE_DERIVATION_METHOD_RESTRICTION = 1 << 2;
/**
 * XML_SCHEMAS_TYPE_GLOBAL:
 *
 * the type is global
 */
enum XML_SCHEMAS_TYPE_GLOBAL = 1 << 3;
/**
 * XML_SCHEMAS_TYPE_OWNED_ATTR_WILDCARD:
 *
 * the complexType owns an attribute wildcard, i.e.
 * it can be freed by the complexType
 */
enum XML_SCHEMAS_TYPE_OWNED_ATTR_WILDCARD = 1 << 4; /* Obsolete. */
/**
 * XML_SCHEMAS_TYPE_VARIETY_ABSENT:
 *
 * the simpleType has a variety of "absent".
 * TODO: Actually not necessary :-/, since if
 * none of the variety flags occur then it's
 * automatically absent.
 */
enum XML_SCHEMAS_TYPE_VARIETY_ABSENT = 1 << 5;
/**
 * XML_SCHEMAS_TYPE_VARIETY_LIST:
 *
 * the simpleType has a variety of "list".
 */
enum XML_SCHEMAS_TYPE_VARIETY_LIST = 1 << 6;
/**
 * XML_SCHEMAS_TYPE_VARIETY_UNION:
 *
 * the simpleType has a variety of "union".
 */
enum XML_SCHEMAS_TYPE_VARIETY_UNION = 1 << 7;
/**
 * XML_SCHEMAS_TYPE_VARIETY_ATOMIC:
 *
 * the simpleType has a variety of "union".
 */
enum XML_SCHEMAS_TYPE_VARIETY_ATOMIC = 1 << 8;
/**
 * XML_SCHEMAS_TYPE_FINAL_EXTENSION:
 *
 * the complexType has a final of "extension".
 */
enum XML_SCHEMAS_TYPE_FINAL_EXTENSION = 1 << 9;
/**
 * XML_SCHEMAS_TYPE_FINAL_RESTRICTION:
 *
 * the simpleType/complexType has a final of "restriction".
 */
enum XML_SCHEMAS_TYPE_FINAL_RESTRICTION = 1 << 10;
/**
 * XML_SCHEMAS_TYPE_FINAL_LIST:
 *
 * the simpleType has a final of "list".
 */
enum XML_SCHEMAS_TYPE_FINAL_LIST = 1 << 11;
/**
 * XML_SCHEMAS_TYPE_FINAL_UNION:
 *
 * the simpleType has a final of "union".
 */
enum XML_SCHEMAS_TYPE_FINAL_UNION = 1 << 12;
/**
 * XML_SCHEMAS_TYPE_FINAL_DEFAULT:
 *
 * the simpleType has a final of "default".
 */
enum XML_SCHEMAS_TYPE_FINAL_DEFAULT = 1 << 13;
/**
 * XML_SCHEMAS_TYPE_BUILTIN_PRIMITIVE:
 *
 * Marks the item as a builtin primitive.
 */
enum XML_SCHEMAS_TYPE_BUILTIN_PRIMITIVE = 1 << 14;
/**
 * XML_SCHEMAS_TYPE_MARKED:
 *
 * Marks the item as marked; used for circular checks.
 */
enum XML_SCHEMAS_TYPE_MARKED = 1 << 16;
/**
 * XML_SCHEMAS_TYPE_BLOCK_DEFAULT:
 *
 * the complexType did not specify 'block' so use the default of the
 * <schema> item.
 */
enum XML_SCHEMAS_TYPE_BLOCK_DEFAULT = 1 << 17;
/**
 * XML_SCHEMAS_TYPE_BLOCK_EXTENSION:
 *
 * the complexType has a 'block' of "extension".
 */
enum XML_SCHEMAS_TYPE_BLOCK_EXTENSION = 1 << 18;
/**
 * XML_SCHEMAS_TYPE_BLOCK_RESTRICTION:
 *
 * the complexType has a 'block' of "restriction".
 */
enum XML_SCHEMAS_TYPE_BLOCK_RESTRICTION = 1 << 19;
/**
 * XML_SCHEMAS_TYPE_ABSTRACT:
 *
 * the simple/complexType is abstract.
 */
enum XML_SCHEMAS_TYPE_ABSTRACT = 1 << 20;
/**
 * XML_SCHEMAS_TYPE_FACETSNEEDVALUE:
 *
 * indicates if the facets need a computed value
 */
enum XML_SCHEMAS_TYPE_FACETSNEEDVALUE = 1 << 21;
/**
 * XML_SCHEMAS_TYPE_INTERNAL_RESOLVED:
 *
 * indicates that the type was typefixed
 */
enum XML_SCHEMAS_TYPE_INTERNAL_RESOLVED = 1 << 22;
/**
 * XML_SCHEMAS_TYPE_INTERNAL_INVALID:
 *
 * indicates that the type is invalid
 */
enum XML_SCHEMAS_TYPE_INTERNAL_INVALID = 1 << 23;
/**
 * XML_SCHEMAS_TYPE_WHITESPACE_PRESERVE:
 *
 * a whitespace-facet value of "preserve"
 */
enum XML_SCHEMAS_TYPE_WHITESPACE_PRESERVE = 1 << 24;
/**
 * XML_SCHEMAS_TYPE_WHITESPACE_REPLACE:
 *
 * a whitespace-facet value of "replace"
 */
enum XML_SCHEMAS_TYPE_WHITESPACE_REPLACE = 1 << 25;
/**
 * XML_SCHEMAS_TYPE_WHITESPACE_COLLAPSE:
 *
 * a whitespace-facet value of "collapse"
 */
enum XML_SCHEMAS_TYPE_WHITESPACE_COLLAPSE = 1 << 26;
/**
 * XML_SCHEMAS_TYPE_HAS_FACETS:
 *
 * has facets
 */
enum XML_SCHEMAS_TYPE_HAS_FACETS = 1 << 27;
/**
 * XML_SCHEMAS_TYPE_NORMVALUENEEDED:
 *
 * indicates if the facets (pattern) need a normalized value
 */
enum XML_SCHEMAS_TYPE_NORMVALUENEEDED = 1 << 28;

/**
 * XML_SCHEMAS_TYPE_FIXUP_1:
 *
 * First stage of fixup was done.
 */
enum XML_SCHEMAS_TYPE_FIXUP_1 = 1 << 29;

/**
 * XML_SCHEMAS_TYPE_REDEFINED:
 *
 * The type was redefined.
 */
enum XML_SCHEMAS_TYPE_REDEFINED = 1 << 30;
/**
 * XML_SCHEMAS_TYPE_REDEFINING:
 *
 * The type redefines an other type.
 */
/* #define XML_SCHEMAS_TYPE_REDEFINING    1 << 31 */

/**
 * _xmlSchemaType:
 *
 * Schemas type definition.
 */
struct _xmlSchemaType
{
    xmlSchemaTypeType type; /* The kind of type */
    _xmlSchemaType* next; /* the next type if in a sequence ... */
    const(xmlChar)* name;
    const(xmlChar)* id; /* Deprecated; not used */
    const(xmlChar)* ref_; /* Deprecated; not used */
    const(xmlChar)* refNs; /* Deprecated; not used */
    xmlSchemaAnnotPtr annot;
    xmlSchemaTypePtr subtypes;
    xmlSchemaAttributePtr attributes; /* Deprecated; not used */
    xmlNodePtr node;
    int minOccurs; /* Deprecated; not used */
    int maxOccurs; /* Deprecated; not used */

    int flags;
    xmlSchemaContentType contentType;
    const(xmlChar)* base; /* Base type's local name */
    const(xmlChar)* baseNs; /* Base type's target namespace */
    xmlSchemaTypePtr baseType; /* The base type component */
    xmlSchemaFacetPtr facets; /* Local facets */
    _xmlSchemaType* redef; /* Deprecated; not used */
    int recurse; /* Obsolete */
    xmlSchemaAttributeLinkPtr* attributeUses; /* Deprecated; not used */
    xmlSchemaWildcardPtr attributeWildcard;
    int builtInType; /* Type of built-in types. */
    xmlSchemaTypeLinkPtr memberTypes; /* member-types if a union type. */
    xmlSchemaFacetLinkPtr facetSet; /* All facets (incl. inherited) */
    const(xmlChar)* refPrefix; /* Deprecated; not used */
    xmlSchemaTypePtr contentTypeDef; /* Used for the simple content of complex types.
       Could we use @subtypes for this? */
    xmlRegexpPtr contModel; /* Holds the automaton of the content model */
    const(xmlChar)* targetNamespace;
    void* attrUses;
}

/*
 * xmlSchemaElement:
 * An element definition.
 *
 * xmlSchemaType, xmlSchemaFacet and xmlSchemaElement start of
 * structures must be kept similar
 */
/**
 * XML_SCHEMAS_ELEM_NILLABLE:
 *
 * the element is nillable
 */
enum XML_SCHEMAS_ELEM_NILLABLE = 1 << 0;
/**
 * XML_SCHEMAS_ELEM_GLOBAL:
 *
 * the element is global
 */
enum XML_SCHEMAS_ELEM_GLOBAL = 1 << 1;
/**
 * XML_SCHEMAS_ELEM_DEFAULT:
 *
 * the element has a default value
 */
enum XML_SCHEMAS_ELEM_DEFAULT = 1 << 2;
/**
 * XML_SCHEMAS_ELEM_FIXED:
 *
 * the element has a fixed value
 */
enum XML_SCHEMAS_ELEM_FIXED = 1 << 3;
/**
 * XML_SCHEMAS_ELEM_ABSTRACT:
 *
 * the element is abstract
 */
enum XML_SCHEMAS_ELEM_ABSTRACT = 1 << 4;
/**
 * XML_SCHEMAS_ELEM_TOPLEVEL:
 *
 * the element is top level
 * obsolete: use XML_SCHEMAS_ELEM_GLOBAL instead
 */
enum XML_SCHEMAS_ELEM_TOPLEVEL = 1 << 5;
/**
 * XML_SCHEMAS_ELEM_REF:
 *
 * the element is a reference to a type
 */
enum XML_SCHEMAS_ELEM_REF = 1 << 6;
/**
 * XML_SCHEMAS_ELEM_NSDEFAULT:
 *
 * allow elements in no namespace
 * Obsolete, not used anymore.
 */
enum XML_SCHEMAS_ELEM_NSDEFAULT = 1 << 7;
/**
 * XML_SCHEMAS_ELEM_INTERNAL_RESOLVED:
 *
 * this is set when "type", "ref", "substitutionGroup"
 * references have been resolved.
 */
enum XML_SCHEMAS_ELEM_INTERNAL_RESOLVED = 1 << 8;
/**
* XML_SCHEMAS_ELEM_CIRCULAR:
*
* a helper flag for the search of circular references.
*/
enum XML_SCHEMAS_ELEM_CIRCULAR = 1 << 9;
/**
 * XML_SCHEMAS_ELEM_BLOCK_ABSENT:
 *
 * the "block" attribute is absent
 */
enum XML_SCHEMAS_ELEM_BLOCK_ABSENT = 1 << 10;
/**
 * XML_SCHEMAS_ELEM_BLOCK_EXTENSION:
 *
 * disallowed substitutions are absent
 */
enum XML_SCHEMAS_ELEM_BLOCK_EXTENSION = 1 << 11;
/**
 * XML_SCHEMAS_ELEM_BLOCK_RESTRICTION:
 *
 * disallowed substitutions: "restriction"
 */
enum XML_SCHEMAS_ELEM_BLOCK_RESTRICTION = 1 << 12;
/**
 * XML_SCHEMAS_ELEM_BLOCK_SUBSTITUTION:
 *
 * disallowed substitutions: "substitution"
 */
enum XML_SCHEMAS_ELEM_BLOCK_SUBSTITUTION = 1 << 13;
/**
 * XML_SCHEMAS_ELEM_FINAL_ABSENT:
 *
 * substitution group exclusions are absent
 */
enum XML_SCHEMAS_ELEM_FINAL_ABSENT = 1 << 14;
/**
 * XML_SCHEMAS_ELEM_FINAL_EXTENSION:
 *
 * substitution group exclusions: "extension"
 */
enum XML_SCHEMAS_ELEM_FINAL_EXTENSION = 1 << 15;
/**
 * XML_SCHEMAS_ELEM_FINAL_RESTRICTION:
 *
 * substitution group exclusions: "restriction"
 */
enum XML_SCHEMAS_ELEM_FINAL_RESTRICTION = 1 << 16;
/**
 * XML_SCHEMAS_ELEM_SUBST_GROUP_HEAD:
 *
 * the declaration is a substitution group head
 */
enum XML_SCHEMAS_ELEM_SUBST_GROUP_HEAD = 1 << 17;
/**
 * XML_SCHEMAS_ELEM_INTERNAL_CHECKED:
 *
 * this is set when the elem decl has been checked against
 * all constraints
 */
enum XML_SCHEMAS_ELEM_INTERNAL_CHECKED = 1 << 18;

alias xmlSchemaElement = _xmlSchemaElement;
alias xmlSchemaElementPtr = _xmlSchemaElement*;

struct _xmlSchemaElement
{
    xmlSchemaTypeType type; /* The kind of type */
    _xmlSchemaType* next; /* Not used? */
    const(xmlChar)* name;
    const(xmlChar)* id; /* Deprecated; not used */
    const(xmlChar)* ref_; /* Deprecated; not used */
    const(xmlChar)* refNs; /* Deprecated; not used */
    xmlSchemaAnnotPtr annot;
    xmlSchemaTypePtr subtypes; /* the type definition */
    xmlSchemaAttributePtr attributes;
    xmlNodePtr node;
    int minOccurs; /* Deprecated; not used */
    int maxOccurs; /* Deprecated; not used */

    int flags;
    const(xmlChar)* targetNamespace;
    const(xmlChar)* namedType;
    const(xmlChar)* namedTypeNs;
    const(xmlChar)* substGroup;
    const(xmlChar)* substGroupNs;
    const(xmlChar)* scope_;
    const(xmlChar)* value; /* The original value of the value constraint. */
    _xmlSchemaElement* refDecl; /* This will now be used for the
       substitution group affiliation */
    xmlRegexpPtr contModel; /* Obsolete for WXS, maybe used for RelaxNG */
    xmlSchemaContentType contentType;
    const(xmlChar)* refPrefix; /* Deprecated; not used */
    xmlSchemaValPtr defVal; /* The compiled value constraint. */
    void* idcs; /* The identity-constraint defs */
}

/*
 * XML_SCHEMAS_FACET_UNKNOWN:
 *
 * unknown facet handling
 */
enum XML_SCHEMAS_FACET_UNKNOWN = 0;
/*
 * XML_SCHEMAS_FACET_PRESERVE:
 *
 * preserve the type of the facet
 */
enum XML_SCHEMAS_FACET_PRESERVE = 1;
/*
 * XML_SCHEMAS_FACET_REPLACE:
 *
 * replace the type of the facet
 */
enum XML_SCHEMAS_FACET_REPLACE = 2;
/*
 * XML_SCHEMAS_FACET_COLLAPSE:
 *
 * collapse the types of the facet
 */
enum XML_SCHEMAS_FACET_COLLAPSE = 3;
/**
 * A facet definition.
 */
struct _xmlSchemaFacet
{
    xmlSchemaTypeType type; /* The kind of type */
    _xmlSchemaFacet* next; /* the next type if in a sequence ... */
    const(xmlChar)* value; /* The original value */
    const(xmlChar)* id; /* Obsolete */
    xmlSchemaAnnotPtr annot;
    xmlNodePtr node;
    int fixed; /* XML_SCHEMAS_FACET_PRESERVE, etc. */
    int whitespace;
    xmlSchemaValPtr val; /* The compiled value */
    xmlRegexpPtr regexp; /* The regex for patterns */
}

/**
 * A notation definition.
 */
alias xmlSchemaNotation = _xmlSchemaNotation;
alias xmlSchemaNotationPtr = _xmlSchemaNotation*;

struct _xmlSchemaNotation
{
    xmlSchemaTypeType type; /* The kind of type */
    const(xmlChar)* name;
    xmlSchemaAnnotPtr annot;
    const(xmlChar)* identifier;
    const(xmlChar)* targetNamespace;
}

/*
* TODO: Actually all those flags used for the schema should sit
* on the schema parser context, since they are used only
* during parsing an XML schema document, and not available
* on the component level as per spec.
*/
/**
 * XML_SCHEMAS_QUALIF_ELEM:
 *
 * Reflects elementFormDefault == qualified in
 * an XML schema document.
 */
enum XML_SCHEMAS_QUALIF_ELEM = 1 << 0;
/**
 * XML_SCHEMAS_QUALIF_ATTR:
 *
 * Reflects attributeFormDefault == qualified in
 * an XML schema document.
 */
enum XML_SCHEMAS_QUALIF_ATTR = 1 << 1;
/**
 * XML_SCHEMAS_FINAL_DEFAULT_EXTENSION:
 *
 * the schema has "extension" in the set of finalDefault.
 */
enum XML_SCHEMAS_FINAL_DEFAULT_EXTENSION = 1 << 2;
/**
 * XML_SCHEMAS_FINAL_DEFAULT_RESTRICTION:
 *
 * the schema has "restriction" in the set of finalDefault.
 */
enum XML_SCHEMAS_FINAL_DEFAULT_RESTRICTION = 1 << 3;
/**
 * XML_SCHEMAS_FINAL_DEFAULT_LIST:
 *
 * the schema has "list" in the set of finalDefault.
 */
enum XML_SCHEMAS_FINAL_DEFAULT_LIST = 1 << 4;
/**
 * XML_SCHEMAS_FINAL_DEFAULT_UNION:
 *
 * the schema has "union" in the set of finalDefault.
 */
enum XML_SCHEMAS_FINAL_DEFAULT_UNION = 1 << 5;
/**
 * XML_SCHEMAS_BLOCK_DEFAULT_EXTENSION:
 *
 * the schema has "extension" in the set of blockDefault.
 */
enum XML_SCHEMAS_BLOCK_DEFAULT_EXTENSION = 1 << 6;
/**
 * XML_SCHEMAS_BLOCK_DEFAULT_RESTRICTION:
 *
 * the schema has "restriction" in the set of blockDefault.
 */
enum XML_SCHEMAS_BLOCK_DEFAULT_RESTRICTION = 1 << 7;
/**
 * XML_SCHEMAS_BLOCK_DEFAULT_SUBSTITUTION:
 *
 * the schema has "substitution" in the set of blockDefault.
 */
enum XML_SCHEMAS_BLOCK_DEFAULT_SUBSTITUTION = 1 << 8;
/**
 * XML_SCHEMAS_INCLUDING_CONVERT_NS:
 *
 * the schema is currently including an other schema with
 * no target namespace.
 */
enum XML_SCHEMAS_INCLUDING_CONVERT_NS = 1 << 9;
/**
 * _xmlSchema:
 *
 * A Schemas definition
 */
struct _xmlSchema
{
    const(xmlChar)* name; /* schema name */
    const(xmlChar)* targetNamespace; /* the target namespace */
    const(xmlChar)* version_;
    const(xmlChar)* id; /* Obsolete */
    xmlDocPtr doc;
    xmlSchemaAnnotPtr annot;
    int flags;

    xmlHashTablePtr typeDecl;
    xmlHashTablePtr attrDecl;
    xmlHashTablePtr attrgrpDecl;
    xmlHashTablePtr elemDecl;
    xmlHashTablePtr notaDecl;

    xmlHashTablePtr schemasImports;

    void* _private; /* unused by the library for users or bindings */
    xmlHashTablePtr groupDecl;
    xmlDictPtr dict;
    void* includes; /* the includes, this is opaque for now */
    int preserve; /* whether to free the document */
    int counter; /* used to give anonymous components unique names */
    xmlHashTablePtr idcDef; /* All identity-constraint defs. */
    void* volatiles; /* Obsolete */
}

void xmlSchemaFreeType(xmlSchemaTypePtr type);
void xmlSchemaFreeWildcard(xmlSchemaWildcardPtr wildcard);

/* LIBXML_SCHEMAS_ENABLED */
/* __XML_SCHEMA_INTERNALS_H__ */
