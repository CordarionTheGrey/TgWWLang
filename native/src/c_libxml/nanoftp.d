module c_libxml.nanoftp;

import c_libxml.xmlversion;

/*
 * Summary: minimal FTP implementation
 * Description: minimal FTP implementation allowing to fetch resources
 *              like external subset.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

extern (C) nothrow @system:

/* Needed for portability to Windows 64 bits */

/**
 * SOCKET:
 *
 * macro used to provide portability of code to windows sockets
 */

/**
 * INVALID_SOCKET:
 *
 * macro used to provide portability of code to windows sockets
 * the value to be used when the socket is not valid
 */

/**
 * ftpListCallback:
 * @userData:  user provided data for the callback
 * @filename:  the file name (including "->" when links are shown)
 * @attrib:  the attribute string
 * @owner:  the owner string
 * @group:  the group string
 * @size:  the file size
 * @links:  the link count
 * @year:  the year
 * @month:  the month
 * @day:  the day
 * @hour:  the hour
 * @minute:  the minute
 *
 * A callback for the xmlNanoFTPList command.
 * Note that only one of year and day:minute are specified.
 */

/**
 * ftpDataCallback:
 * @userData: the user provided context
 * @data: the data received
 * @len: its size in bytes
 *
 * A callback for the xmlNanoFTPGet command.
 */

/*
 * Init
 */

/*
 * Creating/freeing contexts.
 */

/*
 * Opening/closing session connections.
 */

/*
 * Rather internal commands.
 */

/*
 * CD/DIR/GET handlers.
 */

/* LIBXML_FTP_ENABLED */
/* __NANO_FTP_H__ */
