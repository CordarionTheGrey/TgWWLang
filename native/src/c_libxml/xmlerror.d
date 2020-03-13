module c_libxml.xmlerror;

import c_libxml.tree;

/*
 * Summary: error handling
 * Description: the API used to report errors
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C) nothrow:

/**
 * xmlErrorLevel:
 *
 * Indicates the level of an error
 */
enum xmlErrorLevel
{
    none = 0,
    warning = 1, /* A simple warning */
    error = 2, /* A recoverable error */
    fatal = 3 /* A fatal error */
}

/**
 * xmlErrorDomain:
 *
 * Indicates where an error may have come from
 */
enum xmlErrorDomain
{
    none = 0,
    parser = 1, /* The XML parser */
    tree = 2, /* The tree module */
    namespace = 3, /* The XML Namespace module */
    dtd = 4, /* The XML DTD validation with parser context*/
    html = 5, /* The HTML parser */
    memory = 6, /* The memory allocator */
    output = 7, /* The serialization code */
    io = 8, /* The Input/Output stack */
    ftp = 9, /* The FTP module */
    http = 10, /* The HTTP module */
    xinclude = 11, /* The XInclude processing */
    xpath = 12, /* The XPath module */
    xpointer = 13, /* The XPointer module */
    regexp = 14, /* The regular expressions module */
    datatype = 15, /* The W3C XML Schemas Datatype module */
    schemasp = 16, /* The W3C XML Schemas parser module */
    schemasv = 17, /* The W3C XML Schemas validation module */
    relaxngp = 18, /* The Relax-NG parser module */
    relaxngv = 19, /* The Relax-NG validator module */
    catalog = 20, /* The Catalog module */
    c14n = 21, /* The Canonicalization module */
    xslt = 22, /* The XSLT engine from libxslt */
    valid = 23, /* The XML DTD validation with valid context */
    check = 24, /* The error checking module */
    writer = 25, /* The xmlwriter module */
    module_ = 26, /* The dynamically loaded module module*/
    i18n = 27, /* The module handling character conversion */
    schematronv = 28, /* The Schematron validator module */
    buffer = 29, /* The buffers module */
    uri = 30 /* The URI module */
}

/**
 * xmlError:
 *
 * An XML Error instance.
 */

alias xmlError = _xmlError;
alias xmlErrorPtr = _xmlError*;

struct _xmlError
{
    int domain; /* What part of the library raised this error */
    int code; /* The error code, e.g. an xmlParserError */
    char* message; /* human-readable informative error message */
    xmlErrorLevel level; /* how consequent is the error */
    char* file; /* the filename */
    int line; /* the line number if available */
    char* str1; /* extra string information */
    char* str2; /* extra string information */
    char* str3; /* extra string information */
    int int1; /* extra number information */
    int int2; /* error column # or 0 if N/A (todo: rename field when we would brk ABI) */
    void* ctxt; /* the parser context if available */
    void* node; /* the node in the tree */
}

/**
 * xmlParserError:
 *
 * This is an error that the XML (or HTML) parser can generate
 */
enum xmlParserErrors
{
    errOk = 0,
    errInternalError = 1, /* 1 */
    errNoMemory = 2, /* 2 */
    errDocumentStart = 3, /* 3 */
    errDocumentEmpty = 4, /* 4 */
    errDocumentEnd = 5, /* 5 */
    errInvalidHexCharref = 6, /* 6 */
    errInvalidDecCharref = 7, /* 7 */
    errInvalidCharref = 8, /* 8 */
    errInvalidChar = 9, /* 9 */
    errCharrefAtEof = 10, /* 10 */
    errCharrefInProlog = 11, /* 11 */
    errCharrefInEpilog = 12, /* 12 */
    errCharrefInDtd = 13, /* 13 */
    errEntityrefAtEof = 14, /* 14 */
    errEntityrefInProlog = 15, /* 15 */
    errEntityrefInEpilog = 16, /* 16 */
    errEntityrefInDtd = 17, /* 17 */
    errPerefAtEof = 18, /* 18 */
    errPerefInProlog = 19, /* 19 */
    errPerefInEpilog = 20, /* 20 */
    errPerefInIntSubset = 21, /* 21 */
    errEntityrefNoName = 22, /* 22 */
    errEntityrefSemicolMissing = 23, /* 23 */
    errPerefNoName = 24, /* 24 */
    errPerefSemicolMissing = 25, /* 25 */
    errUndeclaredEntity = 26, /* 26 */
    warUndeclaredEntity = 27, /* 27 */
    errUnparsedEntity = 28, /* 28 */
    errEntityIsExternal = 29, /* 29 */
    errEntityIsParameter = 30, /* 30 */
    errUnknownEncoding = 31, /* 31 */
    errUnsupportedEncoding = 32, /* 32 */
    errStringNotStarted = 33, /* 33 */
    errStringNotClosed = 34, /* 34 */
    errNsDeclError = 35, /* 35 */
    errEntityNotStarted = 36, /* 36 */
    errEntityNotFinished = 37, /* 37 */
    errLtInAttribute = 38, /* 38 */
    errAttributeNotStarted = 39, /* 39 */
    errAttributeNotFinished = 40, /* 40 */
    errAttributeWithoutValue = 41, /* 41 */
    errAttributeRedefined = 42, /* 42 */
    errLiteralNotStarted = 43, /* 43 */
    errLiteralNotFinished = 44, /* 44 */
    errCommentNotFinished = 45, /* 45 */
    errPiNotStarted = 46, /* 46 */
    errPiNotFinished = 47, /* 47 */
    errNotationNotStarted = 48, /* 48 */
    errNotationNotFinished = 49, /* 49 */
    errAttlistNotStarted = 50, /* 50 */
    errAttlistNotFinished = 51, /* 51 */
    errMixedNotStarted = 52, /* 52 */
    errMixedNotFinished = 53, /* 53 */
    errElemcontentNotStarted = 54, /* 54 */
    errElemcontentNotFinished = 55, /* 55 */
    errXmldeclNotStarted = 56, /* 56 */
    errXmldeclNotFinished = 57, /* 57 */
    errCondsecNotStarted = 58, /* 58 */
    errCondsecNotFinished = 59, /* 59 */
    errExtSubsetNotFinished = 60, /* 60 */
    errDoctypeNotFinished = 61, /* 61 */
    errMisplacedCdataEnd = 62, /* 62 */
    errCdataNotFinished = 63, /* 63 */
    errReservedXmlName = 64, /* 64 */
    errSpaceRequired = 65, /* 65 */
    errSeparatorRequired = 66, /* 66 */
    errNmtokenRequired = 67, /* 67 */
    errNameRequired = 68, /* 68 */
    errPcdataRequired = 69, /* 69 */
    errUriRequired = 70, /* 70 */
    errPubidRequired = 71, /* 71 */
    errLtRequired = 72, /* 72 */
    errGtRequired = 73, /* 73 */
    errLtslashRequired = 74, /* 74 */
    errEqualRequired = 75, /* 75 */
    errTagNameMismatch = 76, /* 76 */
    errTagNotFinished = 77, /* 77 */
    errStandaloneValue = 78, /* 78 */
    errEncodingName = 79, /* 79 */
    errHyphenInComment = 80, /* 80 */
    errInvalidEncoding = 81, /* 81 */
    errExtEntityStandalone = 82, /* 82 */
    errCondsecInvalid = 83, /* 83 */
    errValueRequired = 84, /* 84 */
    errNotWellBalanced = 85, /* 85 */
    errExtraContent = 86, /* 86 */
    errEntityCharError = 87, /* 87 */
    errEntityPeInternal = 88, /* 88 */
    errEntityLoop = 89, /* 89 */
    errEntityBoundary = 90, /* 90 */
    errInvalidUri = 91, /* 91 */
    errUriFragment = 92, /* 92 */
    warCatalogPi = 93, /* 93 */
    errNoDtd = 94, /* 94 */
    errCondsecInvalidKeyword = 95, /* 95 */
    errVersionMissing = 96, /* 96 */
    warUnknownVersion = 97, /* 97 */
    warLangValue = 98, /* 98 */
    warNsUri = 99, /* 99 */
    warNsUriRelative = 100, /* 100 */
    errMissingEncoding = 101, /* 101 */
    warSpaceValue = 102, /* 102 */
    errNotStandalone = 103, /* 103 */
    errEntityProcessing = 104, /* 104 */
    errNotationProcessing = 105, /* 105 */
    warNsColumn = 106, /* 106 */
    warEntityRedefined = 107, /* 107 */
    errUnknownVersion = 108, /* 108 */
    errVersionMismatch = 109, /* 109 */
    errNameTooLong = 110, /* 110 */
    errUserStop = 111, /* 111 */
    nsErrXmlNamespace = 200,
    nsErrUndefinedNamespace = 201, /* 201 */
    nsErrQname = 202, /* 202 */
    nsErrAttributeRedefined = 203, /* 203 */
    nsErrEmpty = 204, /* 204 */
    nsErrColon = 205, /* 205 */
    dtdAttributeDefault = 500,
    dtdAttributeRedefined = 501, /* 501 */
    dtdAttributeValue = 502, /* 502 */
    dtdContentError = 503, /* 503 */
    dtdContentModel = 504, /* 504 */
    dtdContentNotDeterminist = 505, /* 505 */
    dtdDifferentPrefix = 506, /* 506 */
    dtdElemDefaultNamespace = 507, /* 507 */
    dtdElemNamespace = 508, /* 508 */
    dtdElemRedefined = 509, /* 509 */
    dtdEmptyNotation = 510, /* 510 */
    dtdEntityType = 511, /* 511 */
    dtdIdFixed = 512, /* 512 */
    dtdIdRedefined = 513, /* 513 */
    dtdIdSubset = 514, /* 514 */
    dtdInvalidChild = 515, /* 515 */
    dtdInvalidDefault = 516, /* 516 */
    dtdLoadError = 517, /* 517 */
    dtdMissingAttribute = 518, /* 518 */
    dtdMixedCorrupt = 519, /* 519 */
    dtdMultipleId = 520, /* 520 */
    dtdNoDoc = 521, /* 521 */
    dtdNoDtd = 522, /* 522 */
    dtdNoElemName = 523, /* 523 */
    dtdNoPrefix = 524, /* 524 */
    dtdNoRoot = 525, /* 525 */
    dtdNotationRedefined = 526, /* 526 */
    dtdNotationValue = 527, /* 527 */
    dtdNotEmpty = 528, /* 528 */
    dtdNotPcdata = 529, /* 529 */
    dtdNotStandalone = 530, /* 530 */
    dtdRootName = 531, /* 531 */
    dtdStandaloneWhiteSpace = 532, /* 532 */
    dtdUnknownAttribute = 533, /* 533 */
    dtdUnknownElem = 534, /* 534 */
    dtdUnknownEntity = 535, /* 535 */
    dtdUnknownId = 536, /* 536 */
    dtdUnknownNotation = 537, /* 537 */
    dtdStandaloneDefaulted = 538, /* 538 */
    dtdXmlidValue = 539, /* 539 */
    dtdXmlidType = 540, /* 540 */
    dtdDupToken = 541, /* 541 */
    htmlStrucureError = 800,
    htmlUnknownTag = 801, /* 801 */
    rngpAnynameAttrAncestor = 1000,
    rngpAttrConflict = 1001, /* 1001 */
    rngpAttributeChildren = 1002, /* 1002 */
    rngpAttributeContent = 1003, /* 1003 */
    rngpAttributeEmpty = 1004, /* 1004 */
    rngpAttributeNoop = 1005, /* 1005 */
    rngpChoiceContent = 1006, /* 1006 */
    rngpChoiceEmpty = 1007, /* 1007 */
    rngpCreateFailure = 1008, /* 1008 */
    rngpDataContent = 1009, /* 1009 */
    rngpDefChoiceAndInterleave = 1010, /* 1010 */
    rngpDefineCreateFailed = 1011, /* 1011 */
    rngpDefineEmpty = 1012, /* 1012 */
    rngpDefineMissing = 1013, /* 1013 */
    rngpDefineNameMissing = 1014, /* 1014 */
    rngpElemContentEmpty = 1015, /* 1015 */
    rngpElemContentError = 1016, /* 1016 */
    rngpElementEmpty = 1017, /* 1017 */
    rngpElementContent = 1018, /* 1018 */
    rngpElementName = 1019, /* 1019 */
    rngpElementNoContent = 1020, /* 1020 */
    rngpElemTextConflict = 1021, /* 1021 */
    rngpEmpty = 1022, /* 1022 */
    rngpEmptyConstruct = 1023, /* 1023 */
    rngpEmptyContent = 1024, /* 1024 */
    rngpEmptyNotEmpty = 1025, /* 1025 */
    rngpErrorTypeLib = 1026, /* 1026 */
    rngpExceptEmpty = 1027, /* 1027 */
    rngpExceptMissing = 1028, /* 1028 */
    rngpExceptMultiple = 1029, /* 1029 */
    rngpExceptNoContent = 1030, /* 1030 */
    rngpExternalrefEmtpy = 1031, /* 1031 */
    rngpExternalRefFailure = 1032, /* 1032 */
    rngpExternalrefRecurse = 1033, /* 1033 */
    rngpForbiddenAttribute = 1034, /* 1034 */
    rngpForeignElement = 1035, /* 1035 */
    rngpGrammarContent = 1036, /* 1036 */
    rngpGrammarEmpty = 1037, /* 1037 */
    rngpGrammarMissing = 1038, /* 1038 */
    rngpGrammarNoStart = 1039, /* 1039 */
    rngpGroupAttrConflict = 1040, /* 1040 */
    rngpHrefError = 1041, /* 1041 */
    rngpIncludeEmpty = 1042, /* 1042 */
    rngpIncludeFailure = 1043, /* 1043 */
    rngpIncludeRecurse = 1044, /* 1044 */
    rngpInterleaveAdd = 1045, /* 1045 */
    rngpInterleaveCreateFailed = 1046, /* 1046 */
    rngpInterleaveEmpty = 1047, /* 1047 */
    rngpInterleaveNoContent = 1048, /* 1048 */
    rngpInvalidDefineName = 1049, /* 1049 */
    rngpInvalidUri = 1050, /* 1050 */
    rngpInvalidValue = 1051, /* 1051 */
    rngpMissingHref = 1052, /* 1052 */
    rngpNameMissing = 1053, /* 1053 */
    rngpNeedCombine = 1054, /* 1054 */
    rngpNotallowedNotEmpty = 1055, /* 1055 */
    rngpNsnameAttrAncestor = 1056, /* 1056 */
    rngpNsnameNoNs = 1057, /* 1057 */
    rngpParamForbidden = 1058, /* 1058 */
    rngpParamNameMissing = 1059, /* 1059 */
    rngpParentrefCreateFailed = 1060, /* 1060 */
    rngpParentrefNameInvalid = 1061, /* 1061 */
    rngpParentrefNoName = 1062, /* 1062 */
    rngpParentrefNoParent = 1063, /* 1063 */
    rngpParentrefNotEmpty = 1064, /* 1064 */
    rngpParseError = 1065, /* 1065 */
    rngpPatAnynameExceptAnyname = 1066, /* 1066 */
    rngpPatAttrAttr = 1067, /* 1067 */
    rngpPatAttrElem = 1068, /* 1068 */
    rngpPatDataExceptAttr = 1069, /* 1069 */
    rngpPatDataExceptElem = 1070, /* 1070 */
    rngpPatDataExceptEmpty = 1071, /* 1071 */
    rngpPatDataExceptGroup = 1072, /* 1072 */
    rngpPatDataExceptInterleave = 1073, /* 1073 */
    rngpPatDataExceptList = 1074, /* 1074 */
    rngpPatDataExceptOnemore = 1075, /* 1075 */
    rngpPatDataExceptRef = 1076, /* 1076 */
    rngpPatDataExceptText = 1077, /* 1077 */
    rngpPatListAttr = 1078, /* 1078 */
    rngpPatListElem = 1079, /* 1079 */
    rngpPatListInterleave = 1080, /* 1080 */
    rngpPatListList = 1081, /* 1081 */
    rngpPatListRef = 1082, /* 1082 */
    rngpPatListText = 1083, /* 1083 */
    rngpPatNsnameExceptAnyname = 1084, /* 1084 */
    rngpPatNsnameExceptNsname = 1085, /* 1085 */
    rngpPatOnemoreGroupAttr = 1086, /* 1086 */
    rngpPatOnemoreInterleaveAttr = 1087, /* 1087 */
    rngpPatStartAttr = 1088, /* 1088 */
    rngpPatStartData = 1089, /* 1089 */
    rngpPatStartEmpty = 1090, /* 1090 */
    rngpPatStartGroup = 1091, /* 1091 */
    rngpPatStartInterleave = 1092, /* 1092 */
    rngpPatStartList = 1093, /* 1093 */
    rngpPatStartOnemore = 1094, /* 1094 */
    rngpPatStartText = 1095, /* 1095 */
    rngpPatStartValue = 1096, /* 1096 */
    rngpPrefixUndefined = 1097, /* 1097 */
    rngpRefCreateFailed = 1098, /* 1098 */
    rngpRefCycle = 1099, /* 1099 */
    rngpRefNameInvalid = 1100, /* 1100 */
    rngpRefNoDef = 1101, /* 1101 */
    rngpRefNoName = 1102, /* 1102 */
    rngpRefNotEmpty = 1103, /* 1103 */
    rngpStartChoiceAndInterleave = 1104, /* 1104 */
    rngpStartContent = 1105, /* 1105 */
    rngpStartEmpty = 1106, /* 1106 */
    rngpStartMissing = 1107, /* 1107 */
    rngpTextExpected = 1108, /* 1108 */
    rngpTextHasChild = 1109, /* 1109 */
    rngpTypeMissing = 1110, /* 1110 */
    rngpTypeNotFound = 1111, /* 1111 */
    rngpTypeValue = 1112, /* 1112 */
    rngpUnknownAttribute = 1113, /* 1113 */
    rngpUnknownCombine = 1114, /* 1114 */
    rngpUnknownConstruct = 1115, /* 1115 */
    rngpUnknownTypeLib = 1116, /* 1116 */
    rngpUriFragment = 1117, /* 1117 */
    rngpUriNotAbsolute = 1118, /* 1118 */
    rngpValueEmpty = 1119, /* 1119 */
    rngpValueNoContent = 1120, /* 1120 */
    rngpXmlnsName = 1121, /* 1121 */
    rngpXmlNs = 1122, /* 1122 */
    xpathExpressionOk = 1200,
    xpathNumberError = 1201, /* 1201 */
    xpathUnfinishedLiteralError = 1202, /* 1202 */
    xpathStartLiteralError = 1203, /* 1203 */
    xpathVariableRefError = 1204, /* 1204 */
    xpathUndefVariableError = 1205, /* 1205 */
    xpathInvalidPredicateError = 1206, /* 1206 */
    xpathExprError = 1207, /* 1207 */
    xpathUnclosedError = 1208, /* 1208 */
    xpathUnknownFuncError = 1209, /* 1209 */
    xpathInvalidOperand = 1210, /* 1210 */
    xpathInvalidType = 1211, /* 1211 */
    xpathInvalidArity = 1212, /* 1212 */
    xpathInvalidCtxtSize = 1213, /* 1213 */
    xpathInvalidCtxtPosition = 1214, /* 1214 */
    xpathMemoryError = 1215, /* 1215 */
    xptrSyntaxError = 1216, /* 1216 */
    xptrResourceError = 1217, /* 1217 */
    xptrSubResourceError = 1218, /* 1218 */
    xpathUndefPrefixError = 1219, /* 1219 */
    xpathEncodingError = 1220, /* 1220 */
    xpathInvalidCharError = 1221, /* 1221 */
    treeInvalidHex = 1300,
    treeInvalidDec = 1301, /* 1301 */
    treeUnterminatedEntity = 1302, /* 1302 */
    treeNotUtf8 = 1303, /* 1303 */
    saveNotUtf8 = 1400,
    saveCharInvalid = 1401, /* 1401 */
    saveNoDoctype = 1402, /* 1402 */
    saveUnknownEncoding = 1403, /* 1403 */
    regexpCompileError = 1450,
    ioUnknown = 1500,
    ioEacces = 1501, /* 1501 */
    ioEagain = 1502, /* 1502 */
    ioEbadf = 1503, /* 1503 */
    ioEbadmsg = 1504, /* 1504 */
    ioEbusy = 1505, /* 1505 */
    ioEcanceled = 1506, /* 1506 */
    ioEchild = 1507, /* 1507 */
    ioEdeadlk = 1508, /* 1508 */
    ioEdom = 1509, /* 1509 */
    ioEexist = 1510, /* 1510 */
    ioEfault = 1511, /* 1511 */
    ioEfbig = 1512, /* 1512 */
    ioEinprogress = 1513, /* 1513 */
    ioEintr = 1514, /* 1514 */
    ioEinval = 1515, /* 1515 */
    ioEio = 1516, /* 1516 */
    ioEisdir = 1517, /* 1517 */
    ioEmfile = 1518, /* 1518 */
    ioEmlink = 1519, /* 1519 */
    ioEmsgsize = 1520, /* 1520 */
    ioEnametoolong = 1521, /* 1521 */
    ioEnfile = 1522, /* 1522 */
    ioEnodev = 1523, /* 1523 */
    ioEnoent = 1524, /* 1524 */
    ioEnoexec = 1525, /* 1525 */
    ioEnolck = 1526, /* 1526 */
    ioEnomem = 1527, /* 1527 */
    ioEnospc = 1528, /* 1528 */
    ioEnosys = 1529, /* 1529 */
    ioEnotdir = 1530, /* 1530 */
    ioEnotempty = 1531, /* 1531 */
    ioEnotsup = 1532, /* 1532 */
    ioEnotty = 1533, /* 1533 */
    ioEnxio = 1534, /* 1534 */
    ioEperm = 1535, /* 1535 */
    ioEpipe = 1536, /* 1536 */
    ioErange = 1537, /* 1537 */
    ioErofs = 1538, /* 1538 */
    ioEspipe = 1539, /* 1539 */
    ioEsrch = 1540, /* 1540 */
    ioEtimedout = 1541, /* 1541 */
    ioExdev = 1542, /* 1542 */
    ioNetworkAttempt = 1543, /* 1543 */
    ioEncoder = 1544, /* 1544 */
    ioFlush = 1545, /* 1545 */
    ioWrite = 1546, /* 1546 */
    ioNoInput = 1547, /* 1547 */
    ioBufferFull = 1548, /* 1548 */
    ioLoadError = 1549, /* 1549 */
    ioEnotsock = 1550, /* 1550 */
    ioEisconn = 1551, /* 1551 */
    ioEconnrefused = 1552, /* 1552 */
    ioEnetunreach = 1553, /* 1553 */
    ioEaddrinuse = 1554, /* 1554 */
    ioEalready = 1555, /* 1555 */
    ioEafnosupport = 1556, /* 1556 */
    xincludeRecursion = 1600,
    xincludeParseValue = 1601, /* 1601 */
    xincludeEntityDefMismatch = 1602, /* 1602 */
    xincludeNoHref = 1603, /* 1603 */
    xincludeNoFallback = 1604, /* 1604 */
    xincludeHrefUri = 1605, /* 1605 */
    xincludeTextFragment = 1606, /* 1606 */
    xincludeTextDocument = 1607, /* 1607 */
    xincludeInvalidChar = 1608, /* 1608 */
    xincludeBuildFailed = 1609, /* 1609 */
    xincludeUnknownEncoding = 1610, /* 1610 */
    xincludeMultipleRoot = 1611, /* 1611 */
    xincludeXptrFailed = 1612, /* 1612 */
    xincludeXptrResult = 1613, /* 1613 */
    xincludeIncludeInInclude = 1614, /* 1614 */
    xincludeFallbacksInInclude = 1615, /* 1615 */
    xincludeFallbackNotInInclude = 1616, /* 1616 */
    xincludeDeprecatedNs = 1617, /* 1617 */
    xincludeFragmentId = 1618, /* 1618 */
    catalogMissingAttr = 1650,
    catalogEntryBroken = 1651, /* 1651 */
    catalogPreferValue = 1652, /* 1652 */
    catalogNotCatalog = 1653, /* 1653 */
    catalogRecursion = 1654, /* 1654 */
    schemapPrefixUndefined = 1700,
    schemapAttrformdefaultValue = 1701, /* 1701 */
    schemapAttrgrpNonameNoref = 1702, /* 1702 */
    schemapAttrNonameNoref = 1703, /* 1703 */
    schemapComplextypeNonameNoref = 1704, /* 1704 */
    schemapElemformdefaultValue = 1705, /* 1705 */
    schemapElemNonameNoref = 1706, /* 1706 */
    schemapExtensionNoBase = 1707, /* 1707 */
    schemapFacetNoValue = 1708, /* 1708 */
    schemapFailedBuildImport = 1709, /* 1709 */
    schemapGroupNonameNoref = 1710, /* 1710 */
    schemapImportNamespaceNotUri = 1711, /* 1711 */
    schemapImportRedefineNsname = 1712, /* 1712 */
    schemapImportSchemaNotUri = 1713, /* 1713 */
    schemapInvalidBoolean = 1714, /* 1714 */
    schemapInvalidEnum = 1715, /* 1715 */
    schemapInvalidFacet = 1716, /* 1716 */
    schemapInvalidFacetValue = 1717, /* 1717 */
    schemapInvalidMaxoccurs = 1718, /* 1718 */
    schemapInvalidMinoccurs = 1719, /* 1719 */
    schemapInvalidRefAndSubtype = 1720, /* 1720 */
    schemapInvalidWhiteSpace = 1721, /* 1721 */
    schemapNoattrNoref = 1722, /* 1722 */
    schemapNotationNoName = 1723, /* 1723 */
    schemapNotypeNoref = 1724, /* 1724 */
    schemapRefAndSubtype = 1725, /* 1725 */
    schemapRestrictionNonameNoref = 1726, /* 1726 */
    schemapSimpletypeNoname = 1727, /* 1727 */
    schemapTypeAndSubtype = 1728, /* 1728 */
    schemapUnknownAllChild = 1729, /* 1729 */
    schemapUnknownAnyattributeChild = 1730, /* 1730 */
    schemapUnknownAttrChild = 1731, /* 1731 */
    schemapUnknownAttrgrpChild = 1732, /* 1732 */
    schemapUnknownAttributeGroup = 1733, /* 1733 */
    schemapUnknownBaseType = 1734, /* 1734 */
    schemapUnknownChoiceChild = 1735, /* 1735 */
    schemapUnknownComplexcontentChild = 1736, /* 1736 */
    schemapUnknownComplextypeChild = 1737, /* 1737 */
    schemapUnknownElemChild = 1738, /* 1738 */
    schemapUnknownExtensionChild = 1739, /* 1739 */
    schemapUnknownFacetChild = 1740, /* 1740 */
    schemapUnknownFacetType = 1741, /* 1741 */
    schemapUnknownGroupChild = 1742, /* 1742 */
    schemapUnknownImportChild = 1743, /* 1743 */
    schemapUnknownListChild = 1744, /* 1744 */
    schemapUnknownNotationChild = 1745, /* 1745 */
    schemapUnknownProcesscontentChild = 1746, /* 1746 */
    schemapUnknownRef = 1747, /* 1747 */
    schemapUnknownRestrictionChild = 1748, /* 1748 */
    schemapUnknownSchemasChild = 1749, /* 1749 */
    schemapUnknownSequenceChild = 1750, /* 1750 */
    schemapUnknownSimplecontentChild = 1751, /* 1751 */
    schemapUnknownSimpletypeChild = 1752, /* 1752 */
    schemapUnknownType = 1753, /* 1753 */
    schemapUnknownUnionChild = 1754, /* 1754 */
    schemapElemDefaultFixed = 1755, /* 1755 */
    schemapRegexpInvalid = 1756, /* 1756 */
    schemapFailedLoad = 1757, /* 1757 */
    schemapNothingToParse = 1758, /* 1758 */
    schemapNoroot = 1759, /* 1759 */
    schemapRedefinedGroup = 1760, /* 1760 */
    schemapRedefinedType = 1761, /* 1761 */
    schemapRedefinedElement = 1762, /* 1762 */
    schemapRedefinedAttrgroup = 1763, /* 1763 */
    schemapRedefinedAttr = 1764, /* 1764 */
    schemapRedefinedNotation = 1765, /* 1765 */
    schemapFailedParse = 1766, /* 1766 */
    schemapUnknownPrefix = 1767, /* 1767 */
    schemapDefAndPrefix = 1768, /* 1768 */
    schemapUnknownIncludeChild = 1769, /* 1769 */
    schemapIncludeSchemaNotUri = 1770, /* 1770 */
    schemapIncludeSchemaNoUri = 1771, /* 1771 */
    schemapNotSchema = 1772, /* 1772 */
    schemapUnknownMemberType = 1773, /* 1773 */
    schemapInvalidAttrUse = 1774, /* 1774 */
    schemapRecursive = 1775, /* 1775 */
    schemapSupernumerousListItemType = 1776, /* 1776 */
    schemapInvalidAttrCombination = 1777, /* 1777 */
    schemapInvalidAttrInlineCombination = 1778, /* 1778 */
    schemapMissingSimpletypeChild = 1779, /* 1779 */
    schemapInvalidAttrName = 1780, /* 1780 */
    schemapRefAndContent = 1781, /* 1781 */
    schemapCtPropsCorrect1 = 1782, /* 1782 */
    schemapCtPropsCorrect2 = 1783, /* 1783 */
    schemapCtPropsCorrect3 = 1784, /* 1784 */
    schemapCtPropsCorrect4 = 1785, /* 1785 */
    schemapCtPropsCorrect5 = 1786, /* 1786 */
    schemapDerivationOkRestriction1 = 1787, /* 1787 */
    schemapDerivationOkRestriction211 = 1788, /* 1788 */
    schemapDerivationOkRestriction212 = 1789, /* 1789 */
    schemapDerivationOkRestriction22 = 1790, /* 1790 */
    schemapDerivationOkRestriction3 = 1791, /* 1791 */
    schemapWildcardInvalidNsMember = 1792, /* 1792 */
    schemapIntersectionNotExpressible = 1793, /* 1793 */
    schemapUnionNotExpressible = 1794, /* 1794 */
    schemapSrcImport31 = 1795, /* 1795 */
    schemapSrcImport32 = 1796, /* 1796 */
    schemapDerivationOkRestriction41 = 1797, /* 1797 */
    schemapDerivationOkRestriction42 = 1798, /* 1798 */
    schemapDerivationOkRestriction43 = 1799, /* 1799 */
    schemapCosCtExtends13 = 1800, /* 1800 */
    schemavNoroot = 1801,
    schemavUndeclaredelem = 1802, /* 1802 */
    schemavNottoplevel = 1803, /* 1803 */
    schemavMissing = 1804, /* 1804 */
    schemavWrongelem = 1805, /* 1805 */
    schemavNotype = 1806, /* 1806 */
    schemavNorollback = 1807, /* 1807 */
    schemavIsabstract = 1808, /* 1808 */
    schemavNotempty = 1809, /* 1809 */
    schemavElemcont = 1810, /* 1810 */
    schemavHavedefault = 1811, /* 1811 */
    schemavNotnillable = 1812, /* 1812 */
    schemavExtracontent = 1813, /* 1813 */
    schemavInvalidattr = 1814, /* 1814 */
    schemavInvalidelem = 1815, /* 1815 */
    schemavNotdeterminist = 1816, /* 1816 */
    schemavConstruct = 1817, /* 1817 */
    schemavInternal = 1818, /* 1818 */
    schemavNotsimple = 1819, /* 1819 */
    schemavAttrunknown = 1820, /* 1820 */
    schemavAttrinvalid = 1821, /* 1821 */
    schemavValue = 1822, /* 1822 */
    schemavFacet = 1823, /* 1823 */
    schemavCvcDatatypeValid121 = 1824, /* 1824 */
    schemavCvcDatatypeValid122 = 1825, /* 1825 */
    schemavCvcDatatypeValid123 = 1826, /* 1826 */
    schemavCvcType311 = 1827, /* 1827 */
    schemavCvcType312 = 1828, /* 1828 */
    schemavCvcFacetValid = 1829, /* 1829 */
    schemavCvcLengthValid = 1830, /* 1830 */
    schemavCvcMinlengthValid = 1831, /* 1831 */
    schemavCvcMaxlengthValid = 1832, /* 1832 */
    schemavCvcMininclusiveValid = 1833, /* 1833 */
    schemavCvcMaxinclusiveValid = 1834, /* 1834 */
    schemavCvcMinexclusiveValid = 1835, /* 1835 */
    schemavCvcMaxexclusiveValid = 1836, /* 1836 */
    schemavCvcTotaldigitsValid = 1837, /* 1837 */
    schemavCvcFractiondigitsValid = 1838, /* 1838 */
    schemavCvcPatternValid = 1839, /* 1839 */
    schemavCvcEnumerationValid = 1840, /* 1840 */
    schemavCvcComplexType21 = 1841, /* 1841 */
    schemavCvcComplexType22 = 1842, /* 1842 */
    schemavCvcComplexType23 = 1843, /* 1843 */
    schemavCvcComplexType24 = 1844, /* 1844 */
    schemavCvcElt1 = 1845, /* 1845 */
    schemavCvcElt2 = 1846, /* 1846 */
    schemavCvcElt31 = 1847, /* 1847 */
    schemavCvcElt321 = 1848, /* 1848 */
    schemavCvcElt322 = 1849, /* 1849 */
    schemavCvcElt41 = 1850, /* 1850 */
    schemavCvcElt42 = 1851, /* 1851 */
    schemavCvcElt43 = 1852, /* 1852 */
    schemavCvcElt511 = 1853, /* 1853 */
    schemavCvcElt512 = 1854, /* 1854 */
    schemavCvcElt521 = 1855, /* 1855 */
    schemavCvcElt5221 = 1856, /* 1856 */
    schemavCvcElt52221 = 1857, /* 1857 */
    schemavCvcElt52222 = 1858, /* 1858 */
    schemavCvcElt6 = 1859, /* 1859 */
    schemavCvcElt7 = 1860, /* 1860 */
    schemavCvcAttribute1 = 1861, /* 1861 */
    schemavCvcAttribute2 = 1862, /* 1862 */
    schemavCvcAttribute3 = 1863, /* 1863 */
    schemavCvcAttribute4 = 1864, /* 1864 */
    schemavCvcComplexType31 = 1865, /* 1865 */
    schemavCvcComplexType321 = 1866, /* 1866 */
    schemavCvcComplexType322 = 1867, /* 1867 */
    schemavCvcComplexType4 = 1868, /* 1868 */
    schemavCvcComplexType51 = 1869, /* 1869 */
    schemavCvcComplexType52 = 1870, /* 1870 */
    schemavElementContent = 1871, /* 1871 */
    schemavDocumentElementMissing = 1872, /* 1872 */
    schemavCvcComplexType1 = 1873, /* 1873 */
    schemavCvcAu = 1874, /* 1874 */
    schemavCvcType1 = 1875, /* 1875 */
    schemavCvcType2 = 1876, /* 1876 */
    schemavCvcIdc = 1877, /* 1877 */
    schemavCvcWildcard = 1878, /* 1878 */
    schemavMisc = 1879, /* 1879 */
    xptrUnknownScheme = 1900,
    xptrChildseqStart = 1901, /* 1901 */
    xptrEvalFailed = 1902, /* 1902 */
    xptrExtraObjects = 1903, /* 1903 */
    c14nCreateCtxt = 1950,
    c14nRequiresUtf8 = 1951, /* 1951 */
    c14nCreateStack = 1952, /* 1952 */
    c14nInvalidNode = 1953, /* 1953 */
    c14nUnknowNode = 1954, /* 1954 */
    c14nRelativeNamespace = 1955, /* 1955 */
    ftpPasvAnswer = 2000,
    ftpEpsvAnswer = 2001, /* 2001 */
    ftpAccnt = 2002, /* 2002 */
    ftpUrlSyntax = 2003, /* 2003 */
    httpUrlSyntax = 2020,
    httpUseIp = 2021, /* 2021 */
    httpUnknownHost = 2022, /* 2022 */
    schemapSrcSimpleType1 = 3000,
    schemapSrcSimpleType2 = 3001, /* 3001 */
    schemapSrcSimpleType3 = 3002, /* 3002 */
    schemapSrcSimpleType4 = 3003, /* 3003 */
    schemapSrcResolve = 3004, /* 3004 */
    schemapSrcRestrictionBaseOrSimpletype = 3005, /* 3005 */
    schemapSrcListItemtypeOrSimpletype = 3006, /* 3006 */
    schemapSrcUnionMembertypesOrSimpletypes = 3007, /* 3007 */
    schemapStPropsCorrect1 = 3008, /* 3008 */
    schemapStPropsCorrect2 = 3009, /* 3009 */
    schemapStPropsCorrect3 = 3010, /* 3010 */
    schemapCosStRestricts11 = 3011, /* 3011 */
    schemapCosStRestricts12 = 3012, /* 3012 */
    schemapCosStRestricts131 = 3013, /* 3013 */
    schemapCosStRestricts132 = 3014, /* 3014 */
    schemapCosStRestricts21 = 3015, /* 3015 */
    schemapCosStRestricts2311 = 3016, /* 3016 */
    schemapCosStRestricts2312 = 3017, /* 3017 */
    schemapCosStRestricts2321 = 3018, /* 3018 */
    schemapCosStRestricts2322 = 3019, /* 3019 */
    schemapCosStRestricts2323 = 3020, /* 3020 */
    schemapCosStRestricts2324 = 3021, /* 3021 */
    schemapCosStRestricts2325 = 3022, /* 3022 */
    schemapCosStRestricts31 = 3023, /* 3023 */
    schemapCosStRestricts331 = 3024, /* 3024 */
    schemapCosStRestricts3312 = 3025, /* 3025 */
    schemapCosStRestricts3322 = 3026, /* 3026 */
    schemapCosStRestricts3321 = 3027, /* 3027 */
    schemapCosStRestricts3323 = 3028, /* 3028 */
    schemapCosStRestricts3324 = 3029, /* 3029 */
    schemapCosStRestricts3325 = 3030, /* 3030 */
    schemapCosStDerivedOk21 = 3031, /* 3031 */
    schemapCosStDerivedOk22 = 3032, /* 3032 */
    schemapS4sElemNotAllowed = 3033, /* 3033 */
    schemapS4sElemMissing = 3034, /* 3034 */
    schemapS4sAttrNotAllowed = 3035, /* 3035 */
    schemapS4sAttrMissing = 3036, /* 3036 */
    schemapS4sAttrInvalidValue = 3037, /* 3037 */
    schemapSrcElement1 = 3038, /* 3038 */
    schemapSrcElement21 = 3039, /* 3039 */
    schemapSrcElement22 = 3040, /* 3040 */
    schemapSrcElement3 = 3041, /* 3041 */
    schemapPPropsCorrect1 = 3042, /* 3042 */
    schemapPPropsCorrect21 = 3043, /* 3043 */
    schemapPPropsCorrect22 = 3044, /* 3044 */
    schemapEPropsCorrect2 = 3045, /* 3045 */
    schemapEPropsCorrect3 = 3046, /* 3046 */
    schemapEPropsCorrect4 = 3047, /* 3047 */
    schemapEPropsCorrect5 = 3048, /* 3048 */
    schemapEPropsCorrect6 = 3049, /* 3049 */
    schemapSrcInclude = 3050, /* 3050 */
    schemapSrcAttribute1 = 3051, /* 3051 */
    schemapSrcAttribute2 = 3052, /* 3052 */
    schemapSrcAttribute31 = 3053, /* 3053 */
    schemapSrcAttribute32 = 3054, /* 3054 */
    schemapSrcAttribute4 = 3055, /* 3055 */
    schemapNoXmlns = 3056, /* 3056 */
    schemapNoXsi = 3057, /* 3057 */
    schemapCosValidDefault1 = 3058, /* 3058 */
    schemapCosValidDefault21 = 3059, /* 3059 */
    schemapCosValidDefault221 = 3060, /* 3060 */
    schemapCosValidDefault222 = 3061, /* 3061 */
    schemapCvcSimpleType = 3062, /* 3062 */
    schemapCosCtExtends11 = 3063, /* 3063 */
    schemapSrcImport11 = 3064, /* 3064 */
    schemapSrcImport12 = 3065, /* 3065 */
    schemapSrcImport2 = 3066, /* 3066 */
    schemapSrcImport21 = 3067, /* 3067 */
    schemapSrcImport22 = 3068, /* 3068 */
    schemapInternal = 3069, /* 3069 non-W3C */
    schemapNotDeterministic = 3070, /* 3070 non-W3C */
    schemapSrcAttributeGroup1 = 3071, /* 3071 */
    schemapSrcAttributeGroup2 = 3072, /* 3072 */
    schemapSrcAttributeGroup3 = 3073, /* 3073 */
    schemapMgPropsCorrect1 = 3074, /* 3074 */
    schemapMgPropsCorrect2 = 3075, /* 3075 */
    schemapSrcCt1 = 3076, /* 3076 */
    schemapDerivationOkRestriction213 = 3077, /* 3077 */
    schemapAuPropsCorrect2 = 3078, /* 3078 */
    schemapAPropsCorrect2 = 3079, /* 3079 */
    schemapCPropsCorrect = 3080, /* 3080 */
    schemapSrcRedefine = 3081, /* 3081 */
    schemapSrcImport = 3082, /* 3082 */
    schemapWarnSkipSchema = 3083, /* 3083 */
    schemapWarnUnlocatedSchema = 3084, /* 3084 */
    schemapWarnAttrRedeclProh = 3085, /* 3085 */
    schemapWarnAttrPointlessProh = 3086, /* 3085 */
    schemapAgPropsCorrect = 3087, /* 3086 */
    schemapCosCtExtends12 = 3088, /* 3087 */
    schemapAuPropsCorrect = 3089, /* 3088 */
    schemapAPropsCorrect3 = 3090, /* 3089 */
    schemapCosAllLimited = 3091, /* 3090 */
    schematronvAssert = 4000, /* 4000 */
    schematronvReport = 4001,
    moduleOpen = 4900, /* 4900 */
    moduleClose = 4901, /* 4901 */
    checkFoundElement = 5000,
    checkFoundAttribute = 5001, /* 5001 */
    checkFoundText = 5002, /* 5002 */
    checkFoundCdata = 5003, /* 5003 */
    checkFoundEntityref = 5004, /* 5004 */
    checkFoundEntity = 5005, /* 5005 */
    checkFoundPi = 5006, /* 5006 */
    checkFoundComment = 5007, /* 5007 */
    checkFoundDoctype = 5008, /* 5008 */
    checkFoundFragment = 5009, /* 5009 */
    checkFoundNotation = 5010, /* 5010 */
    checkUnknownNode = 5011, /* 5011 */
    checkEntityType = 5012, /* 5012 */
    checkNoParent = 5013, /* 5013 */
    checkNoDoc = 5014, /* 5014 */
    checkNoName = 5015, /* 5015 */
    checkNoElem = 5016, /* 5016 */
    checkWrongDoc = 5017, /* 5017 */
    checkNoPrev = 5018, /* 5018 */
    checkWrongPrev = 5019, /* 5019 */
    checkNoNext = 5020, /* 5020 */
    checkWrongNext = 5021, /* 5021 */
    checkNotDtd = 5022, /* 5022 */
    checkNotAttr = 5023, /* 5023 */
    checkNotAttrDecl = 5024, /* 5024 */
    checkNotElemDecl = 5025, /* 5025 */
    checkNotEntityDecl = 5026, /* 5026 */
    checkNotNsDecl = 5027, /* 5027 */
    checkNoHref = 5028, /* 5028 */
    checkWrongParent = 5029, /* 5029 */
    checkNsScope = 5030, /* 5030 */
    checkNsAncestor = 5031, /* 5031 */
    checkNotUtf8 = 5032, /* 5032 */
    checkNoDict = 5033, /* 5033 */
    checkNotNcname = 5034, /* 5034 */
    checkOutsideDict = 5035, /* 5035 */
    checkWrongName = 5036, /* 5036 */
    checkNameNotNull = 5037, /* 5037 */
    i18nNoName = 6000,
    i18nNoHandler = 6001, /* 6001 */
    i18nExcessHandler = 6002, /* 6002 */
    i18nConvFailed = 6003, /* 6003 */
    i18nNoOutput = 6004, /* 6004 */
    bufOverflow = 7000
}

/**
 * xmlGenericErrorFunc:
 * @ctx:  a parsing context
 * @msg:  the message
 * @...:  the extra arguments of the varargs to format the message
 *
 * Signature of the function to use when there is an error and
 * no parsing or validity context available .
 */
alias xmlGenericErrorFunc = void function(void* ctx, const(char)* msg, ...);
/**
 * xmlStructuredErrorFunc:
 * @userData:  user provided data for the error callback
 * @error:  the error being raised.
 *
 * Signature of the function to use when there is an error and
 * the module handles the new error reporting mechanism.
 */
alias xmlStructuredErrorFunc = void function(void* userData, xmlErrorPtr error);

/*
 * Use the following function to reset the two global variables
 * xmlGenericError and xmlGenericErrorContext.
 */
void xmlSetGenericErrorFunc(void* ctx, xmlGenericErrorFunc handler);
void initGenericErrorDefaultFunc(xmlGenericErrorFunc* handler);

void xmlSetStructuredErrorFunc(void* ctx, xmlStructuredErrorFunc handler);
/*
 * Default message routines used by SAX and Valid context for error
 * and warning reporting.
 */
void xmlParserError(void* ctx, const(char)* msg, ...);
void xmlParserWarning(void* ctx, const(char)* msg, ...);
void xmlParserValidityError(void* ctx, const(char)* msg, ...);
void xmlParserValidityWarning(void* ctx, const(char)* msg, ...);
void xmlParserPrintFileInfo(xmlParserInputPtr input);
void xmlParserPrintFileContext(xmlParserInputPtr input);

/*
 * Extended error information routines
 */
xmlErrorPtr xmlGetLastError();
void xmlResetLastError();
xmlErrorPtr xmlCtxtGetLastError(void* ctx);
void xmlCtxtResetLastError(void* ctx);
void xmlResetError(xmlErrorPtr err);
int xmlCopyError(xmlErrorPtr from, xmlErrorPtr to);

/*
 * Internal callback reporting routine
 */

/* __XML_ERROR_H__ */
