/*
 * Copyright (c) 2004-2011, 2015-2018, 2021 Apple Inc. All rights reserved.
 *
 * @APPLE_LICENSE_HEADER_START@
 *
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 *
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 *
 * @APPLE_LICENSE_HEADER_END@
 */

#ifndef _SCNETWORKCONFIGURATION_H
#define _SCNETWORKCONFIGURATION_H

#include <os/availability.h>
#include <TargetConditionals.h>
#include <sys/cdefs.h>
#include <CoreFoundation/CoreFoundation.h>
#include <SystemConfiguration/SystemConfiguration.h>

CF_IMPLICIT_BRIDGING_ENABLED
CF_ASSUME_NONNULL_BEGIN


//  其实就是网络额控制，  这个类看看能不能使用
//  监控流量，感觉这个是控制连接，，我们统计流量还是得控制很多其他东西的
/*!
	@header SCNetworkConfiguration
	@discussion The SCNetworkConfiguration API provides access to the
		stored network configuration.  The functions include
		providing access to the network capable devices on the
		system, the network sets, network services, and network
		protocols.

		Note: When using the SCNetworkConfiguration APIs you must
		keep in mind that in order for any of your changes to be
		committed to permanent storage a call must be made to the
		SCPreferencesCommitChanges function.
 */


/*!
	@group Interface configuration
 */

#pragma mark -
#pragma mark SCNetworkInterface configuration (typedefs, consts)

/*!
	@typedef SCNetworkInterfaceRef
	@discussion This is the type of a reference to an object that represents
		a network interface.
 */
typedef const struct CF_BRIDGED_TYPE(id) __SCNetworkInterface * SCNetworkInterfaceRef;

/*!
	@const kSCNetworkInterfaceType6to4
 */
extern const CFStringRef kSCNetworkInterfaceType6to4						API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCNetworkInterfaceTypeBluetooth
 */
extern const CFStringRef kSCNetworkInterfaceTypeBluetooth					API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCNetworkInterfaceTypeBond
 */
extern const CFStringRef kSCNetworkInterfaceTypeBond						API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCNetworkInterfaceTypeEthernet
 */
extern const CFStringRef kSCNetworkInterfaceTypeEthernet					API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCNetworkInterfaceTypeFireWire
 */
extern const CFStringRef kSCNetworkInterfaceTypeFireWire					API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCNetworkInterfaceTypeIEEE80211
 */
extern const CFStringRef kSCNetworkInterfaceTypeIEEE80211					API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);	// IEEE 802.11, AirPort

/*!
	@const kSCNetworkInterfaceTypeIPSec
 */
extern const CFStringRef kSCNetworkInterfaceTypeIPSec						API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCNetworkInterfaceTypeIrDA
 */
extern const CFStringRef kSCNetworkInterfaceTypeIrDA						API_DEPRECATED("No longer supported", macos(10.4,12.0))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCNetworkInterfaceTypeL2TP
 */
extern const CFStringRef kSCNetworkInterfaceTypeL2TP						API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCNetworkInterfaceTypeModem
 */
extern const CFStringRef kSCNetworkInterfaceTypeModem						API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCNetworkInterfaceTypePPP
 */
extern const CFStringRef kSCNetworkInterfaceTypePPP						API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCNetworkInterfaceTypePPTP
 */
extern const CFStringRef kSCNetworkInterfaceTypePPTP						API_DEPRECATED("No longer supported", macos(10.4,10.12))
												API_UNAVAILABLE(ios, tvos, watchos);


/*!
	@const kSCNetworkInterfaceTypeSerial
 */
extern const CFStringRef kSCNetworkInterfaceTypeSerial						API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCNetworkInterfaceTypeVLAN
 */
extern const CFStringRef kSCNetworkInterfaceTypeVLAN						API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCNetworkInterfaceTypeWWAN
 */
extern const CFStringRef kSCNetworkInterfaceTypeWWAN						API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/* special network interfaces (and types) */

/*!
	@const kSCNetworkInterfaceTypeIPv4
 */
extern const CFStringRef kSCNetworkInterfaceTypeIPv4						API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCNetworkInterfaceIPv4
	@discussion A network interface that can used for layering other
		interfaces (e.g. 6to4, IPSec, PPTP, L2TP) over an existing
		IPv4 network.
 */
extern const SCNetworkInterfaceRef kSCNetworkInterfaceIPv4					API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@group Interface configuration (Bond)
 */

#pragma mark -

/*!
	@typedef SCBondInterfaceRef
	@discussion This is the type of a reference to an object that represents
		an Ethernet Bond interface.
 */
typedef SCNetworkInterfaceRef SCBondInterfaceRef;

/*!
	@typedef SCBondStatusRef
	@discussion This is the type of a reference to an object that represents
		the status of an Ethernet Bond interface.
 */
typedef const struct CF_BRIDGED_TYPE(id) __SCBondStatus *		SCBondStatusRef;

/*!
	@enum Ethernet Bond Aggregation Status (kSCBondStatusDeviceAggregationStatus) codes
	@discussion Returned status codes.
	@constant kSCBondStatusOK		Enabled, active, running, ...
	@constant kSCBondStatusLinkInvalid	The link state was not valid (i.e. down, half-duplex, wrong speed)
	@constant kSCBondStatusNoPartner	The port on the switch that the device is connected doesn't seem to have 802.3ad Link Aggregation enabled
	@constant kSCBondStatusNotInActiveGroup	We're talking to a partner, but the link aggregation group is different from the one that's active
	@constant kSCBondStatusUnknown		Non-specific failure
 */
enum {
	kSCBondStatusOK			= 0,	/* enabled, active, running, ... */
	kSCBondStatusLinkInvalid	= 1,	/* The link state was not valid (i.e. down, half-duplex, wrong speed) */
	kSCBondStatusNoPartner		= 2,	/* The port on the switch that the device is connected doesn't seem to have 802.3ad Link Aggregation enabled */
	kSCBondStatusNotInActiveGroup	= 3,	/* We're talking to a partner, but the link aggregation group is different from the one that's active */
	kSCBondStatusUnknown		= 999	/* Non-specific failure */
};

/*!
	@const kSCBondStatusDeviceAggregationStatus
 */
extern const CFStringRef kSCBondStatusDeviceAggregationStatus	/* CFNumber */			API_AVAILABLE(macos(10.4)) API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCBondStatusDeviceCollecting
 */
extern const CFStringRef kSCBondStatusDeviceCollecting		/* CFNumber (0 or 1) */		API_AVAILABLE(macos(10.4)) API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCBondStatusDeviceDistributing
 */
extern const CFStringRef kSCBondStatusDeviceDistributing	/* CFNumber (0 or 1) */		API_AVAILABLE(macos(10.4)) API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@group Interface configuration (VLAN)
 */

#pragma mark -

/*!
	@typedef SCVLANInterfaceRef
	@discussion This is the type of a reference to an object that represents
		a Virtual LAN (VLAN) interface.
 */
typedef SCNetworkInterfaceRef SCVLANInterfaceRef;


/*!
	@group Protocol configuration
 */

#pragma mark -
#pragma mark SCNetworkProtocol configuration (typedefs, consts)

/*!
	@typedef SCNetworkProtocolRef
	@discussion This is the type of a reference to an object that represents
		a network protocol.
 */
typedef const struct CF_BRIDGED_TYPE(id) __SCNetworkProtocol * SCNetworkProtocolRef;

/* network "protocol" types */

/*!
	@const kSCNetworkProtocolTypeDNS
 */
extern const CFStringRef kSCNetworkProtocolTypeDNS						API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCNetworkProtocolTypeIPv4
 */
extern const CFStringRef kSCNetworkProtocolTypeIPv4						API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCNetworkProtocolTypeIPv6
 */
extern const CFStringRef kSCNetworkProtocolTypeIPv6						API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCNetworkProtocolTypeProxies
 */
extern const CFStringRef kSCNetworkProtocolTypeProxies						API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@const kSCNetworkProtocolTypeSMB
 */
extern const CFStringRef kSCNetworkProtocolTypeSMB						API_AVAILABLE(macos(10.5)) API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@group Service configuration
 */

#pragma mark -
#pragma mark SCNetworkService configuration (typedefs, consts)

/*!
	@typedef SCNetworkServiceRef
	@discussion This is the type of a reference to an object that represents
		a network service.
 */
typedef const struct CF_BRIDGED_TYPE(id) __SCNetworkService * SCNetworkServiceRef;


/*!
	@group Set configuration
 */

#pragma mark -
#pragma mark SCNetworkSet configuration (typedefs, consts)

/*!
	@typedef SCNetworkSetRef
	@discussion This is the type of a reference to an object that represents
		a network set.
 */
typedef const struct CF_BRIDGED_TYPE(id) __SCNetworkSet	* SCNetworkSetRef;


__BEGIN_DECLS


/* --------------------------------------------------------------------------------
 * INTERFACES
 * -------------------------------------------------------------------------------- */

/*!
	@group Interface configuration
 */

#pragma mark -
#pragma mark SCNetworkInterface configuration (APIs)

/*!
	@function SCNetworkInterfaceGetTypeID
	@discussion Returns the type identifier of all SCNetworkInterface instances.
 */
CFTypeID
SCNetworkInterfaceGetTypeID			(void)						API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceCopyAll
	@discussion Returns all network capable interfaces on the system.
	@result The list of interfaces on the system.
		You must release the returned value.
 */
CFArrayRef /* of SCNetworkInterfaceRef's */
SCNetworkInterfaceCopyAll			(void)						API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceGetSupportedInterfaceTypes
	@discussion Identify all of the network interface types (e.g. PPP) that
		can be layered on top of this interface.
	@param interface The network interface.
	@result The list of SCNetworkInterface types supported by the interface;
		NULL if no interface types are supported.
 */
CFArrayRef /* of kSCNetworkInterfaceTypeXXX CFStringRef's */ __nullable
SCNetworkInterfaceGetSupportedInterfaceTypes	(SCNetworkInterfaceRef		interface)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceGetSupportedProtocolTypes
	@discussion Identify all of the network protocol types (e.g. IPv4, IPv6) that
		can be layered on top of this interface.
	@param interface The network interface.
	@result The list of SCNetworkProtocol types supported by the interface;
		NULL if no protocol types are supported.
 */
CFArrayRef /* of kSCNetworkProtocolTypeXXX CFStringRef's */ __nullable
SCNetworkInterfaceGetSupportedProtocolTypes	(SCNetworkInterfaceRef		interface)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceCreateWithInterface
	@discussion Create a new network interface layered on top of another.  For
		example, this function would be used to create a "PPP" interface
		on top of a "modem".
	@param interface The network interface.
	@param interfaceType The type of SCNetworkInterface to be layered on
		top of the provided interface.
	@result A reference to the new SCNetworkInterface.
		You must release the returned value.
 */
SCNetworkInterfaceRef __nullable
SCNetworkInterfaceCreateWithInterface		(SCNetworkInterfaceRef		interface,
						 CFStringRef			interfaceType)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceGetBSDName
	@discussion Returns the BSD interface (en0) or device name (modem)
		for the interface.
	@param interface The network interface.
	@result The BSD name associated with the interface (e.g. "en0");
		NULL if no BSD name is available.
 */
CFStringRef __nullable
SCNetworkInterfaceGetBSDName			(SCNetworkInterfaceRef		interface)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceGetConfiguration
	@discussion Returns the configuration settings associated with a interface.
	@param interface The network interface.
	@result The configuration settings associated with the interface;
		NULL if no configuration settings are associated with the interface
		or an error was encountered.
 */
CFDictionaryRef __nullable
SCNetworkInterfaceGetConfiguration		(SCNetworkInterfaceRef		interface)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceGetExtendedConfiguration
	@discussion Returns the configuration settings associated with a interface.
	@param interface The network interface.
	@param extendedType A string representing the type of extended information (e.g. EAPOL).
	@result The configuration settings associated with the interface;
		NULL if no configuration settings are associated with the interface
		or an error was encountered.
 */
CFDictionaryRef __nullable
SCNetworkInterfaceGetExtendedConfiguration	(SCNetworkInterfaceRef		interface,
						 CFStringRef			extendedType)	API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceGetHardwareAddressString
	@discussion Returns a displayable link layer address for the interface.
	@param interface The network interface.
	@result A string representing the hardware (MAC) address for the interface.
 */
CFStringRef __nullable
SCNetworkInterfaceGetHardwareAddressString	(SCNetworkInterfaceRef		interface)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceGetInterface
	@discussion For layered network interfaces, return the underlying interface.
	@param interface The network interface.
	@result The underlying network interface;
		NULL if this is a leaf interface.
 */
SCNetworkInterfaceRef __nullable
SCNetworkInterfaceGetInterface			(SCNetworkInterfaceRef		interface)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceGetInterfaceType
	@discussion Returns the associated network interface type.
	@param interface The network interface.
	@result The interface type.
 */
CFStringRef __nullable
SCNetworkInterfaceGetInterfaceType		(SCNetworkInterfaceRef		interface)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceGetLocalizedDisplayName
	@discussion Returns the localized name (e.g. "Ethernet", "FireWire") for
		the interface.
	@param interface The network interface.
	@result A localized, display name for the interface;
		NULL if no name is available.
 */
CFStringRef __nullable
SCNetworkInterfaceGetLocalizedDisplayName	(SCNetworkInterfaceRef		interface)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceSetConfiguration
	@discussion Stores the configuration settings for the interface.
	@param interface The network interface.
	@param config The configuration settings to associate with this interface.
	@result TRUE if the configuration was stored; FALSE if an error was encountered.
 */
Boolean
SCNetworkInterfaceSetConfiguration		(SCNetworkInterfaceRef		interface,
						 CFDictionaryRef __nullable	config)		API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceSetExtendedConfiguration
	@discussion Stores the configuration settings for the interface.
	@param interface The network interface.
	@param config The configuration settings to associate with this interface.
	@result TRUE if the configuration was stored; FALSE if an error was encountered.
 */
Boolean
SCNetworkInterfaceSetExtendedConfiguration	(SCNetworkInterfaceRef		interface,
						 CFStringRef			extendedType,
						 CFDictionaryRef __nullable	config)		API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

#pragma mark -

/*!
	@function SCNetworkInterfaceCopyMediaOptions
	@discussion For the specified network interface, returns information
		about the currently requested media options, the active media
		options, and the media options which are available.
	@param interface The desired network interface.
	@param current A pointer to memory that will be filled with a CFDictionaryRef
		representing the currently requested media options (subtype, options).
		If NULL, the current options will not be returned.
	@param active A pointer to memory that will be filled with a CFDictionaryRef
		representing the active media options (subtype, options).
		If NULL, the active options will not be returned.
	@param available A pointer to memory that will be filled with a CFArrayRef
		representing the possible media options (subtype, options).
		If NULL, the available options will not be returned.
	@param filter A boolean indicating whether the available options should be
		filtered to exclude those options which would not normally be
		requested by a user/admin (e.g. hw-loopback).
	@result TRUE if requested information has been returned.
 */
Boolean
SCNetworkInterfaceCopyMediaOptions		(SCNetworkInterfaceRef						interface,
						 CFDictionaryRef		__nullable	* __nullable	current,
						 CFDictionaryRef		__nullable	* __nullable	active,
						 CFArrayRef			__nullable	* __nullable	available,
						 Boolean					filter)		API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceCopyMediaSubTypes
	@discussion For the provided interface configuration options, return a list
		of available media subtypes.
	@param available The available options as returned by the
		SCNetworkInterfaceCopyMediaOptions function.
	@result An array of available media subtypes CFString's (e.g. 10BaseT/UTP,
		100baseTX, etc).  NULL if no subtypes are available.
 */
CFArrayRef __nullable
SCNetworkInterfaceCopyMediaSubTypes		(CFArrayRef			available)	API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceCopyMediaSubTypeOptions
	@discussion For the provided interface configuration options and specific
		subtype, return a list of available media options.
	@param available The available options as returned by the
		SCNetworkInterfaceCopyMediaOptions function.
	@param subType The subtype
	@result An array of available media options.  Each of the available options
		is returned as an array of CFString's (e.g. <half-duplex>,
		<full-duplex,flow-control>).  NULL if no options are available.
 */
CFArrayRef __nullable
SCNetworkInterfaceCopyMediaSubTypeOptions	(CFArrayRef			available,
						 CFStringRef			subType)	API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceCopyMTU
	@discussion For the specified network interface, returns information
		about the currently MTU setting and the range of allowable
		values.
	@param interface The desired network interface.
	@param mtu_cur A pointer to memory that will be filled with the current
		MTU setting for the interface.
	@param mtu_min A pointer to memory that will be filled with the minimum
		MTU setting for the interface.  If negative, the minimum setting
		could not be determined.
	@param mtu_max A pointer to memory that will be filled with the maximum
		MTU setting for the interface.  If negative, the maximum setting
		could not be determined.
	@result TRUE if requested information has been returned.
 */
Boolean
SCNetworkInterfaceCopyMTU			(SCNetworkInterfaceRef			interface,
						 int			* __nullable	mtu_cur,
						 int			* __nullable	mtu_min,
						 int			* __nullable	mtu_max)	API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceSetMediaOptions
	@discussion For the specified network interface, sets the requested
		media subtype and options.
	@param interface The desired network interface.
	@param subtype The desired media subtype (e.g. "autoselect", "100baseTX", ...).
		If NULL, no specific media subtype will be requested.
	@param options The desired media options (e.g. "half-duplex", "full-duplex", ...).
		If NULL, no specific media options will be requested.
	@result TRUE if the configuration was updated; FALSE if an error was encountered.
 */
Boolean
SCNetworkInterfaceSetMediaOptions		(SCNetworkInterfaceRef			interface,
						 CFStringRef		__nullable	subtype,
						 CFArrayRef		__nullable	options)	API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceSetMTU
	@discussion For the specified network interface, sets the
		requested MTU setting.
	@param interface The desired network interface.
	@param mtu The desired MTU setting for the interface.
		If zero, the interface will use the default MTU setting.
	@result TRUE if the configuration was updated; FALSE if an error was encountered.
 */
Boolean
SCNetworkInterfaceSetMTU			(SCNetworkInterfaceRef		interface,
						 int				mtu)		API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkInterfaceForceConfigurationRefresh
	@discussion Sends a notification to interested network configuration
		agents to immediately retry their configuration. For example,
		calling this function will cause the DHCP client to contact
		the DHCP server immediately rather than waiting until its
		timeout has expired.  The utility of this function is to
		allow the caller to give a hint to the system that the
		network infrastructure or configuration has changed.

		Note: This function requires root (euid==0) privilege or,
		alternatively, you may pass an SCNetworkInterface which
		is derived from a sequence of calls to :

			SCPreferencesCreateWithAuthorization
			SCNetworkSetCopy...
			SCNetworkServiceGetInterface
	@param interface The desired network interface.
	@result Returns TRUE if the notification was sent; FALSE otherwise.
 */
Boolean
SCNetworkInterfaceForceConfigurationRefresh	(SCNetworkInterfaceRef		interface)	API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@group Interface configuration (Bond)
 */

#pragma mark -
#pragma mark SCBondInterface configuration (APIs)

/*!
	@function SCBondInterfaceCopyAll
	@discussion Returns all Ethernet Bond interfaces on the system.
	@param prefs The "preferences" session.
	@result The list of Ethernet Bond interfaces on the system.
		You must release the returned value.
 */
CFArrayRef /* of SCBondInterfaceRef's */
SCBondInterfaceCopyAll				(SCPreferencesRef		prefs)		API_AVAILABLE(macos(10.5)) API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCBondInterfaceCopyAvailableMemberInterfaces
	@discussion Returns all network capable devices on the system
		that can be added to an Ethernet Bond interface.
	@param prefs The "preferences" session.
	@result The list of interfaces.
		You must release the returned value.
 */
CFArrayRef /* of SCNetworkInterfaceRef's */
SCBondInterfaceCopyAvailableMemberInterfaces	(SCPreferencesRef		prefs)		API_AVAILABLE(macos(10.5)) API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCBondInterfaceCreate
	@discussion Create a new SCBondInterface interface.
	@param prefs The "preferences" session.
	@result A reference to the new SCBondInterface.
		You must release the returned value.
 */
SCBondInterfaceRef __nullable
SCBondInterfaceCreate				(SCPreferencesRef		prefs)		API_AVAILABLE(macos(10.5)) API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCBondInterfaceRemove
	@discussion Removes the SCBondInterface from the configuration.
	@param bond The SCBondInterface interface.
	@result TRUE if the interface was removed; FALSE if an error was encountered.
 */
Boolean
SCBondInterfaceRemove				(SCBondInterfaceRef		bond)		API_AVAILABLE(macos(10.5)) API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCBondInterfaceGetMemberInterfaces
	@discussion Returns the member interfaces for the specified Ethernet Bond interface.
	@param bond The SCBondInterface interface.
	@result The list of interfaces.
 */
CFArrayRef /* of SCNetworkInterfaceRef's */ __nullable
SCBondInterfaceGetMemberInterfaces		(SCBondInterfaceRef		bond)		API_AVAILABLE(macos(10.5)) API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCBondInterfaceGetOptions
	@discussion Returns the configuration settings associated with a Ethernet Bond interface.
	@param bond The SCBondInterface interface.
	@result The configuration settings associated with the Ethernet Bond interface;
		NULL if no changes to the default configuration have been saved.
 */
CFDictionaryRef __nullable
SCBondInterfaceGetOptions			(SCBondInterfaceRef		bond)		API_AVAILABLE(macos(10.5)) API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCBondInterfaceSetMemberInterfaces
	@discussion Sets the member interfaces for the specified Ethernet Bond interface.
	@param bond The SCBondInterface interface.
	@param members The desired member interfaces.
	@result TRUE if the configuration was stored; FALSE if an error was encountered.
 */
Boolean
SCBondInterfaceSetMemberInterfaces		(SCBondInterfaceRef		bond,
						 CFArrayRef			members) /* of SCNetworkInterfaceRef's */
												API_AVAILABLE(macos(10.5)) API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCBondInterfaceSetLocalizedDisplayName
	@discussion Sets the localized display name for the specified Ethernet Bond interface.
	@param bond The SCBondInterface interface.
	@param newName The new display name.
	@result TRUE if the configuration was stored; FALSE if an error was encountered.
 */
Boolean
SCBondInterfaceSetLocalizedDisplayName		(SCBondInterfaceRef		bond,
						 CFStringRef			newName)	API_AVAILABLE(macos(10.5)) API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCBondInterfaceSetOptions
	@discussion Sets the configuration settings for the specified Ethernet Bond interface.
	@param bond The SCBondInterface interface.
	@param newOptions The new configuration settings.
	@result TRUE if the configuration was stored; FALSE if an error was encountered.
 */
Boolean
SCBondInterfaceSetOptions			(SCBondInterfaceRef		bond,
						 CFDictionaryRef		newOptions)	API_AVAILABLE(macos(10.5)) API_UNAVAILABLE(ios, tvos, watchos);

#pragma mark -

/*!
	@function SCBondInterfaceCopyStatus
	@discussion Returns the status of the specified Ethernet Bond interface.
	@param bond The SCBondInterface interface.
	@result The status associated with the interface.
		You must release the returned value.
 */
SCBondStatusRef __nullable
SCBondInterfaceCopyStatus			(SCBondInterfaceRef	bond)			API_AVAILABLE(macos(10.5)) API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCBondStatusGetTypeID
	@discussion Returns the type identifier of all SCBondStatus instances.
 */
CFTypeID
SCBondStatusGetTypeID				(void)						API_AVAILABLE(macos(10.5)) API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCBondStatusGetMemberInterfaces
	@discussion Returns the member interfaces that are represented with the
		Ethernet Bond interface.
	@param bondStatus The Ethernet Bond status.
	@result The list of interfaces.
 */
CFArrayRef __nullable /* of SCNetworkInterfaceRef's */
SCBondStatusGetMemberInterfaces			(SCBondStatusRef	bondStatus)		API_AVAILABLE(macos(10.5)) API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCBondStatusGetInterfaceStatus
	@discussion Returns the status of a specific member interface of an
		Ethernet Bond or the status of the bond as a whole.
	@param bondStatus The Ethernet Bond status.
	@param interface The specific member interface; NULL if you want the
		status of the Ethernet Bond.
	@result The interface status.

	Note: at present, no information about the status of the Ethernet
	      Bond is returned.  As long as one member interface is active
	      then the bond should be operational.
 */
CFDictionaryRef __nullable
SCBondStatusGetInterfaceStatus			(SCBondStatusRef			bondStatus,
						 SCNetworkInterfaceRef	__nullable	interface)	API_AVAILABLE(macos(10.5)) API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@group Interface configuration (VLAN)
 */

#pragma mark -
#pragma mark SCVLANInterface configuration (APIs)

/*!
	@function SCVLANInterfaceCopyAll
	@discussion Returns all VLAN interfaces on the system.
	@result The list of VLAN interfaces on the system.
		You must release the returned value.
 */
CFArrayRef /* of SCVLANInterfaceRef's */
SCVLANInterfaceCopyAll				(SCPreferencesRef		prefs)		API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCVLANInterfaceCopyAvailablePhysicalInterfaces
	@discussion Returns the network capable devices on the system
		that can be associated with a VLAN interface.
	@result The list of interfaces.
		You must release the returned value.
 */
CFArrayRef /* of SCNetworkInterfaceRef's */
SCVLANInterfaceCopyAvailablePhysicalInterfaces	(void)						API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCVLANInterfaceCreate
	@discussion Create a new SCVLANInterface interface.
	@param prefs The "preferences" session.
	@param physical The physical interface to associate with the VLAN.
	@param tag The tag to associate with the VLAN.
	@result A reference to the new SCVLANInterface.
		You must release the returned value.

	Note: the tag must be in the range (1 <= tag <= 4094)
 */
SCVLANInterfaceRef __nullable
SCVLANInterfaceCreate				(SCPreferencesRef		prefs,
						 SCNetworkInterfaceRef		physical,
						 CFNumberRef			tag)		API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCVLANInterfaceRemove
	@discussion Removes the SCVLANInterface from the configuration.
	@param vlan The SCVLANInterface interface.
	@result TRUE if the interface was removed; FALSE if an error was encountered.
 */
Boolean
SCVLANInterfaceRemove				(SCVLANInterfaceRef		vlan)		API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCVLANInterfaceGetPhysicalInterface
	@discussion Returns the physical interface for the specified VLAN interface.
	@param vlan The SCVLANInterface interface.
	@result The list of interfaces.
 */
SCNetworkInterfaceRef __nullable
SCVLANInterfaceGetPhysicalInterface		(SCVLANInterfaceRef		vlan)		API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCVLANInterfaceGetTag
	@discussion Returns the tag for the specified VLAN interface.
	@param vlan The SCVLANInterface interface.
	@result The tag.
 */
CFNumberRef __nullable
SCVLANInterfaceGetTag				(SCVLANInterfaceRef		vlan)		API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCVLANInterfaceGetOptions
	@discussion Returns the configuration settings associated with the VLAN interface.
	@param vlan The SCVLANInterface interface.
	@result The configuration settings associated with the VLAN interface;
		NULL if no changes to the default configuration have been saved.
 */
CFDictionaryRef __nullable
SCVLANInterfaceGetOptions			(SCVLANInterfaceRef		vlan)		API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCVLANInterfaceSetPhysicalInterfaceAndTag
	@discussion Updates the specified VLAN interface.
	@param vlan The SCVLANInterface interface.
	@param physical The physical interface to associate with the VLAN.
	@param tag The tag to associate with the VLAN.
	@result TRUE if the configuration was stored; FALSE if an error was encountered.

	Note: the tag must be in the range (1 <= tag <= 4094)
 */
Boolean
SCVLANInterfaceSetPhysicalInterfaceAndTag	(SCVLANInterfaceRef		vlan,
						 SCNetworkInterfaceRef		physical,
						 CFNumberRef			tag)		API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCVLANInterfaceSetLocalizedDisplayName
	@discussion Sets the localized display name for the specified VLAN interface.
	@param vlan The SCVLANInterface interface.
	@param newName The new display name.
	@result TRUE if the configuration was stored; FALSE if an error was encountered.
 */
Boolean
SCVLANInterfaceSetLocalizedDisplayName		(SCVLANInterfaceRef		vlan,
						 CFStringRef			newName)	API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCVLANInterfaceSetOptions
	@discussion Sets the configuration settings for the specified VLAN interface.
	@param vlan The SCVLANInterface interface.
	@param newOptions The new configuration settings.
	@result TRUE if the configuration was stored; FALSE if an error was encountered.
 */
Boolean
SCVLANInterfaceSetOptions			(SCVLANInterfaceRef		vlan,
						 CFDictionaryRef		newOptions)	API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);


/* --------------------------------------------------------------------------------
 * PROTOCOLS
 * -------------------------------------------------------------------------------- */

/*!
	@group Protocol configuration
 */

#pragma mark -
#pragma mark SCNetworkProtocol configuration (APIs)

/*!
	@function SCNetworkProtocolGetTypeID
	@discussion Returns the type identifier of all SCNetworkProtocol instances.
 */
CFTypeID
SCNetworkProtocolGetTypeID			(void)						API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkProtocolGetConfiguration
	@discussion Returns the configuration settings associated with the protocol.
	@param protocol The network protocol.
	@result The configuration settings associated with the protocol;
		NULL if no configuration settings are associated with the protocol
		or an error was encountered.
 */
CFDictionaryRef __nullable
SCNetworkProtocolGetConfiguration		(SCNetworkProtocolRef		protocol)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkProtocolGetEnabled
	@discussion Returns whether this protocol has been enabled.
	@param protocol The network protocol.
	@result TRUE if the protocol is enabled.
 */
Boolean
SCNetworkProtocolGetEnabled			(SCNetworkProtocolRef		protocol)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkProtocolGetProtocolType
	@discussion Returns the associated network protocol type.
	@param protocol The network protocol.
	@result The protocol type.
 */
CFStringRef __nullable
SCNetworkProtocolGetProtocolType		(SCNetworkProtocolRef		protocol)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkProtocolSetConfiguration
	@discussion Stores the configuration settings for the protocol.
	@param protocol The network protocol.
	@param config The configuration settings to associate with this protocol.
	@result TRUE if the configuration was stored; FALSE if an error was encountered.
 */
Boolean
SCNetworkProtocolSetConfiguration		(SCNetworkProtocolRef		protocol,
						 CFDictionaryRef __nullable	config)		API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkProtocolSetEnabled
	@discussion Enables or disables the protocol.
	@param protocol The network protocol.
	@param enabled TRUE if the protocol should be enabled.
	@result TRUE if the enabled status was saved; FALSE if an error was encountered.
 */
Boolean
SCNetworkProtocolSetEnabled			(SCNetworkProtocolRef		protocol,
						 Boolean			enabled)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/* --------------------------------------------------------------------------------
 * SERVICES
 * -------------------------------------------------------------------------------- */

/*!
	@group Service configuration
 */

#pragma mark -
#pragma mark SCNetworkService configuration (APIs)

/*!
	@function SCNetworkServiceGetTypeID
	@discussion Returns the type identifier of all SCNetworkService instances.
 */
CFTypeID
SCNetworkServiceGetTypeID			(void)						API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkServiceAddProtocolType
	@discussion Adds a network protocol of the specified type to the
		service.  The protocal configuration is set to default values
		that are appropriate for the interface associated with the
		service.
	@param service The network service.
	@param protocolType The type of SCNetworkProtocol to be added to the service.
	@result TRUE if the protocol was added to the service; FALSE if the
		protocol was already present or an error was encountered.
 */
Boolean
SCNetworkServiceAddProtocolType			(SCNetworkServiceRef		service,
						 CFStringRef			protocolType)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkServiceCopyAll
	@discussion Returns all available network services for the specified preferences.
	@param prefs The "preferences" session.
	@result The list of SCNetworkService services associated with the preferences.
		You must release the returned value.
 */
CFArrayRef /* of SCNetworkServiceRef's */ __nullable
SCNetworkServiceCopyAll				(SCPreferencesRef		prefs)		API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkServiceCopyProtocols
	@discussion Returns all network protocols associated with the service.
	@param service The network service.
	@result The list of SCNetworkProtocol protocols associated with the service.
		You must release the returned value.
 */
CFArrayRef /* of SCNetworkProtocolRef's */ __nullable
SCNetworkServiceCopyProtocols			(SCNetworkServiceRef		service)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkServiceCreate
	@discussion Create a new network service for the specified interface in the
		configuration.
	@param prefs The "preferences" session.
	@result A reference to the new SCNetworkService.
		You must release the returned value.
 */
SCNetworkServiceRef __nullable
SCNetworkServiceCreate				(SCPreferencesRef		prefs,
						 SCNetworkInterfaceRef		interface)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkServiceCopy
	@discussion Returns the network service with the specified identifier.
	@param prefs The "preferences" session.
	@param serviceID The unique identifier for the service.
	@result A reference to the SCNetworkService from the associated preferences;
		NULL if the serviceID does not exist in the preferences or if an
		error was encountered.
		You must release the returned value.
 */
SCNetworkServiceRef __nullable
SCNetworkServiceCopy				(SCPreferencesRef		prefs,
						 CFStringRef			serviceID)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkServiceEstablishDefaultConfiguration
	@discussion Establishes the "default" configuration for a network
		service.  This configuration includes the addition of
		network protocols for the service (with "default"
		configuration options).
	@param service The network service.
	@result TRUE if the configuration was updated; FALSE if an error was encountered.
*/
Boolean
SCNetworkServiceEstablishDefaultConfiguration	(SCNetworkServiceRef		service)	API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkServiceGetEnabled
	@discussion Returns whether this service has been enabled.
	@param service The network service.
	@result TRUE if the service is enabled.
 */
Boolean
SCNetworkServiceGetEnabled			(SCNetworkServiceRef		service)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkServiceGetInterface
	@discussion Returns the network interface associated with the service.
	@param service The network service.
	@result A reference to the SCNetworkInterface associated with the service;
		NULL if an error was encountered.
 */
SCNetworkInterfaceRef __nullable
SCNetworkServiceGetInterface			(SCNetworkServiceRef		service)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkServiceGetName
	@discussion Returns the [user specified] name associated with the service.
	@param service The network service.
	@result The [user specified] name.
 */
CFStringRef __nullable
SCNetworkServiceGetName				(SCNetworkServiceRef		service)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkServiceCopyProtocol
	@discussion Returns the network protocol of the specified type for
		the service.
	@param service The network service.
	@result A reference to the SCNetworkProtocol associated with the service;
		NULL if this protocol has not been added or if an error was encountered.
		You must release the returned value.
 */
SCNetworkProtocolRef __nullable
SCNetworkServiceCopyProtocol			(SCNetworkServiceRef		service,
						 CFStringRef			protocolType)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkServiceGetServiceID
	@discussion Returns the identifier for the service.
	@param service The network service.
	@result The service identifier.
 */
CFStringRef __nullable
SCNetworkServiceGetServiceID			(SCNetworkServiceRef		service)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkServiceRemove
	@discussion Removes the network service from the configuration.
	@param service The network service.
	@result TRUE if the service was removed; FALSE if an error was encountered.
 */
Boolean
SCNetworkServiceRemove				(SCNetworkServiceRef		service)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkServiceRemoveProtocolType
	@discussion Removes the network protocol of the specified type from the service.
	@param service The network service.
	@param protocolType The type of SCNetworkProtocol to be removed from the service.
	@result TRUE if the protocol was removed to the service; FALSE if the
		protocol was not configured or an error was encountered.
 */
Boolean
SCNetworkServiceRemoveProtocolType		(SCNetworkServiceRef		service,
						 CFStringRef			protocolType)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkServiceSetEnabled
	@discussion Enables or disables the service.
	@param service The network service.
	@param enabled TRUE if the service should be enabled.
	@result TRUE if the enabled status was saved; FALSE if an error was encountered.
 */
Boolean
SCNetworkServiceSetEnabled			(SCNetworkServiceRef		service,
						 Boolean			enabled)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkServiceSetName
	@discussion Stores the [user specified] name for the service.
	@param service The network service.
	@param name The [user defined] name to associate with the service.
	@result TRUE if the name was saved; FALSE if an error was encountered.

	Note: although not technically required, the [user specified] names
	for all services within any given set should be unique.  As such, an
	error will be returned if you attemp to name two services with the
	same string.
 */
Boolean
SCNetworkServiceSetName				(SCNetworkServiceRef		service,
						 CFStringRef __nullable		name)		API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);


/* --------------------------------------------------------------------------------
 * SETS
 * -------------------------------------------------------------------------------- */

/*!
	@group Set configuration
 */

#pragma mark -
#pragma mark SCNetworkSet configuration (APIs)

/*!
	@function SCNetworkSetGetTypeID
	@discussion Returns the type identifier of all SCNetworkSet instances.
 */
CFTypeID
SCNetworkSetGetTypeID				(void)						API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkSetAddService
	@discussion Adds the network service to the set.
	@param set The network set.
	@param service The service to be added.
	@result TRUE if the service was added to the set; FALSE if the
		service was already present or an error was encountered.

	Note: prior to Mac OS X 10.5, the Network Preferences UI
	did not support having a single service being a member of
	more than one set.  An error will be returned if you attempt
	to add a service to more than one set on a pre-10.5 system.
 */
Boolean
SCNetworkSetAddService				(SCNetworkSetRef		set,
						 SCNetworkServiceRef		service)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkSetContainsInterface
	@discussion Checks if an interface is represented by at least one
		network service in the specified set.
	@param set The network set.
	@param interface The network interface.
	@result TRUE if the interface is represented in the set; FALSE if not.
 */
Boolean
SCNetworkSetContainsInterface			(SCNetworkSetRef		set,
						 SCNetworkInterfaceRef		interface)	API_AVAILABLE(macos(10.5))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkSetCopyAll
	@discussion Returns all available sets for the specified preferences.
	@param prefs The "preferences" session.
	@result The list of SCNetworkSet sets associated with the preferences.
		You must release the returned value.
 */
CFArrayRef /* of SCNetworkSetRef's */ __nullable
SCNetworkSetCopyAll				(SCPreferencesRef		prefs)		API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkSetCopyCurrent
	@discussion Returns the "current" set.
	@param prefs The "preferences" session.
	@result The current set; NULL if no current set has been defined.
 */
SCNetworkSetRef __nullable
SCNetworkSetCopyCurrent				(SCPreferencesRef		prefs)		API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkSetCopyServices
	@discussion Returns all network services associated with the set.
	@param set The network set.
	@result The list of SCNetworkService services associated with the set.
		You must release the returned value.
 */
CFArrayRef /* of SCNetworkServiceRef's */ __nullable
SCNetworkSetCopyServices			(SCNetworkSetRef		set)		API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkSetCreate
	@discussion Create a new set in the configuration.
	@param prefs The "preferences" session.
	@result A reference to the new SCNetworkSet.
		You must release the returned value.
 */
SCNetworkSetRef __nullable
SCNetworkSetCreate				(SCPreferencesRef		prefs)		API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkSetCopy
	@discussion Returns the set with the specified identifier.
	@param prefs The "preferences" session.
	@param setID The unique identifier for the set.
	@result A reference to the SCNetworkSet from the associated preferences;
		NULL if the setID does not exist in the preferences or if an
		error was encountered.
		You must release the returned value.
 */
SCNetworkSetRef __nullable
SCNetworkSetCopy				(SCPreferencesRef		prefs,
						 CFStringRef			setID)		API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkSetGetName
	@discussion Returns the [user specified] name associated with the set.
	@param set The network set.
	@result The [user specified] name.
 */
CFStringRef __nullable
SCNetworkSetGetName				(SCNetworkSetRef		set)		API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkSetGetSetID
	@discussion Returns the identifier for the set.
	@param set The network set.
	@result The set identifier.
 */
CFStringRef __nullable
SCNetworkSetGetSetID				(SCNetworkSetRef		set)		API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkSetGetServiceOrder
	@discussion Returns the [user specified] ordering of network services
		within the set.
	@param set The network set.
	@result The ordered list of CFStringRef service identifiers associated
		with the set;
		NULL if no service order has been specified or if an error
		was encountered.
 */
CFArrayRef /* of serviceID CFStringRef's */ __nullable
SCNetworkSetGetServiceOrder			(SCNetworkSetRef		set)		API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkSetRemove
	@discussion Removes the set from the configuration.
	@param set The network set.
	@result TRUE if the set was removed; FALSE if an error was encountered.
 */
Boolean
SCNetworkSetRemove				(SCNetworkSetRef		set)		API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkSetRemoveService
	@discussion Removes the network service from the set.
	@param set The network set.
	@param service The service to be removed.
	@result TRUE if the service was removed from the set; FALSE if the
		service was not already present or an error was encountered.
 */
Boolean
SCNetworkSetRemoveService			(SCNetworkSetRef		set,
						 SCNetworkServiceRef		service)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkSetSetCurrent
	@discussion Specifies the set that should be the "current" set.
	@param set The network set.
	@result TRUE if the current set was updated;
		FALSE if an error was encountered.
 */
Boolean
SCNetworkSetSetCurrent				(SCNetworkSetRef		set)		API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkSetSetName
	@discussion Stores the [user specified] name for the set.
	@param set The network set.
	@param name The [user defined] name to associate with the set.
	@result TRUE if the name was saved; FALSE if an error was encountered.

	Note: although not technically required, the [user specified] names
	for all set should be unique.  As such, an error will be returned if
	you attemp to name two sets with the same string.
 */
Boolean
SCNetworkSetSetName				(SCNetworkSetRef		set,
						 CFStringRef __nullable		name)		API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);

/*!
	@function SCNetworkSetSetServiceOrder
	@discussion Stores the [user specified] ordering of network services for the set.
	@param set The network set.
	@param newOrder The ordered list of CFStringRef service identifiers for the set.
	@result TRUE if the new service order was saved; FALSE if an error was encountered.
 */
Boolean
SCNetworkSetSetServiceOrder			(SCNetworkSetRef		set,
						 CFArrayRef			newOrder)	API_AVAILABLE(macos(10.4))
												API_UNAVAILABLE(ios, tvos, watchos);	/* serviceID CFStringRef's */


__END_DECLS

CF_ASSUME_NONNULL_END
CF_IMPLICIT_BRIDGING_DISABLED

#endif	/* _SCNETWORKCONFIGURATION_H */
/*
 * Copyright (c) 2003-2006, 2008-2010, 2015, 2017, 2018, 2021 Apple Inc. All rights reserved.
 *
 * @APPLE_LICENSE_HEADER_START@
 *
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 *
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 *
 * @APPLE_LICENSE_HEADER_END@
 */

#ifndef _SCNETWORKCONNECTION_H
#define _SCNETWORKCONNECTION_H

#include <os/availability.h>
#include <TargetConditionals.h>
#include <sys/cdefs.h>
#include <dispatch/dispatch.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <CoreFoundation/CoreFoundation.h>
#include <SystemConfiguration/SystemConfiguration.h>

CF_IMPLICIT_BRIDGING_ENABLED
CF_ASSUME_NONNULL_BEGIN

/*!
	@header SCNetworkConnection
	@discussion The SCNetworkConnection API contains functions that allow
		an application to control connection-oriented services defined
		in the system and get connection-status information.

		The functions in the SCNetworkConnection API allow you to
		control and get information about existing services only.
		If you need to create, change, or remove services, you
		should use the SCNetworkConfiguration API instead.

		Note: Currently, only PPP services can be controlled.
 */


/*!
	@typedef SCNetworkConnectionRef
	@discussion This is the handle to manage a connection-oriented service.
 */
typedef const struct CF_BRIDGED_TYPE(id) __SCNetworkConnection * SCNetworkConnectionRef;


/*!
	@typedef SCNetworkConnectionContext
	@discussion Structure containing user-specified data and callbacks
		for a SCNetworkConnection.
	@field version The version number of the structure type being passed
		in as a parameter to the SCNetworkConnectionCreateWithServiceID
		function.  This structure is version 0.
	@field info A C pointer to a user-specified block of data.
	@field retain The callback used to add a retain for the info field.
		If this parameter is not a pointer to a function of the correct
		prototype, the behavior is undefined.  The value may be NULL.
	@field release The calllback used to remove a retain previously added
		for the info field.  If this parameter is not a pointer to a
		function of the correct prototype, the behavior is undefined.
		The value may be NULL.
	@field copyDescription The callback used to provide a description of
		the info field.
 */
typedef struct {
	CFIndex         version;
	void *          __nullable info;
	const void      * __nonnull (* __nullable retain)(const void *info);
	void            (* __nullable release)(const void *info);
	CFStringRef     __nonnull (* __nullable copyDescription)(const void *info);
} SCNetworkConnectionContext;



/*!
	@enum SCNetworkConnectionStatus
	@discussion Status of the network connection.
		This status is intended to be generic and high level.
		An extended status, specific to the type of network
		connection is also available for applications that
		need additonal information.
	@constant kSCNetworkConnectionInvalid
		The network connection refers to an invalid service.
	@constant kSCNetworkConnectionDisconnected
		The network connection is disconnected.
	@constant kSCNetworkConnectionConnecting
		The network connection is connecting.
	@constant kSCNetworkConnectionConnected
		The network connection is connected.
	@constant kSCNetworkConnectionDisconnecting
		The network connection is disconnecting.
 */
typedef CF_ENUM(int32_t, SCNetworkConnectionStatus) {
	kSCNetworkConnectionInvalid		=  -1,
	kSCNetworkConnectionDisconnected	=  0,
	kSCNetworkConnectionConnecting		=  1,
	kSCNetworkConnectionConnected		=  2,
	kSCNetworkConnectionDisconnecting	=  3
};


/*!
	@enum SCNetworkConnectionPPPStatus
	@discussion PPP-specific status of the network connection.
		This status is returned as part of the extended information
		for a PPP service.
		Note: additional status might be returned in the future.
		Your application should be prepared to receive an unknown value.
	@constant kSCNetworkConnectionPPPDisconnected
		PPP is disconnected.
	@constant kSCNetworkConnectionPPPInitializing
		PPP is initializing.
	@constant kSCNetworkConnectionPPPConnectingLink
		PPP is connecting the lower connection layer (for example,
		the modem is dialing out).
	@constant kSCNetworkConnectionPPPDialOnTraffic
		PPP is waiting for networking traffic to automatically
		establish the connection.
	@constant kSCNetworkConnectionPPPNegotiatingLink
		The PPP lower layer is connected and PPP is negotiating the
		link layer (LCP protocol).
	@constant kSCNetworkConnectionPPPAuthenticating
		PPP is authenticating to the server (PAP, CHAP, MS-CHAP or
		EAP protocols).
	@constant kSCNetworkConnectionPPPWaitingForCallBack
		PPP is waiting for the server to call back.
	@constant kSCNetworkConnectionPPPNegotiatingNetwork
		PPP is now authenticated and negotiating the networking
		layer (IPCP or IPv6CP protocols)
	@constant kSCNetworkConnectionPPPConnected
		PPP is now fully connected for at least one networking layer.
		Additional networking protocol might still be negotiating.
	@constant kSCNetworkConnectionPPPTerminating
		PPP networking and link protocols are terminating.
	@constant kSCNetworkConnectionPPPDisconnectingLink
		PPP is disconnecting the lower level (for example, the modem
		is hanging up).
	@constant kSCNetworkConnectionPPPHoldingLinkOff
		PPP is disconnected and maintaining the link temporarily off.
	@constant kSCNetworkConnectionPPPSuspended
		PPP is suspended as a result of the suspend command (for
		example, when a V.92 Modem is On Hold).
	@constant kSCNetworkConnectionPPPWaitingForRedial
		PPP has found a busy server and is waiting for redial.
 */
//   网络连接状态
typedef CF_ENUM(int32_t, SCNetworkConnectionPPPStatus) {
	kSCNetworkConnectionPPPDisconnected		=  0,
	kSCNetworkConnectionPPPInitializing		=  1,
	kSCNetworkConnectionPPPConnectingLink		=  2,
	kSCNetworkConnectionPPPDialOnTraffic		=  3,
	kSCNetworkConnectionPPPNegotiatingLink		=  4,
	kSCNetworkConnectionPPPAuthenticating		=  5,
	kSCNetworkConnectionPPPWaitingForCallBack	=  6,
	kSCNetworkConnectionPPPNegotiatingNetwork	=  7,
	kSCNetworkConnectionPPPConnected		=  8,
	kSCNetworkConnectionPPPTerminating		=  9,
	kSCNetworkConnectionPPPDisconnectingLink	=  10,
	kSCNetworkConnectionPPPHoldingLinkOff		=  11,
	kSCNetworkConnectionPPPSuspended		=  12,
	kSCNetworkConnectionPPPWaitingForRedial		=  13
};

/*!
	@typedef SCNetworkConnectionCallBack
	@discussion Type of the callback function used when a
		status event is delivered.
	@param status The connection status.
	@param connection The connection reference.
	@param info Application-specific information.
 */
typedef void (*SCNetworkConnectionCallBack)	(
						SCNetworkConnectionRef				connection,
						SCNetworkConnectionStatus			status,
						void			    *	__nullable	info
						);



/*
    Keys for the statistics dictionary
*/

#define kSCNetworkConnectionBytesIn		CFSTR("BytesIn")		/* CFNumber */
#define kSCNetworkConnectionBytesOut		CFSTR("BytesOut")		/* CFNumber */
#define kSCNetworkConnectionPacketsIn		CFSTR("PacketsIn")		/* CFNumber */
#define kSCNetworkConnectionPacketsOut		CFSTR("PacketsOut")		/* CFNumber */
#define kSCNetworkConnectionErrorsIn		CFSTR("ErrorsIn")		/* CFNumber */
#define kSCNetworkConnectionErrorsOut		CFSTR("ErrorsOut")		/* CFNumber */


/*
 Keys for the SCNetworkConnectionCopyUserPreferences() "selectionOptions"
 dictionary
 */

/*!
	@define kSCNetworkConnectionSelectionOptionOnDemandHostName
	@discussion A host name that will be used to select the
		"best" SCNetworkConnection.
 */
#define kSCNetworkConnectionSelectionOptionOnDemandHostName	CFSTR("OnDemandHostName")	// CFString
												// API_AVAILABLE(macos(10.4))
												

/*!
	@define kSCNetworkConnectionSelectionOptionOnDemandRetry
	@discussion A boolean value used to indicate whether a DNS query has
		already been issued for the specified OnDemand host name.
 */
#define kSCNetworkConnectionSelectionOptionOnDemandRetry	CFSTR("OnDemandRetry")		// CFBoolean
												// API_AVAILABLE(macos(10.4))
												

__BEGIN_DECLS

/*!
	@function SCNetworkConnectionGetTypeID
	@discussion Returns the type identifier of all SCNetworkConnection
		instances.
 */
CFTypeID
SCNetworkConnectionGetTypeID			(void)			API_AVAILABLE(macos(10.3)) API_UNAVAILABLE(ios, tvos, watchos);


/*!
	@function SCNetworkConnectionCopyUserPreferences
	@discussion Provides the default service ID and a dictionary of user
		options for the connection.  Applications can use the
		returned serviceID and userOptions values to open a
		connection on the fly.
	@param selectionOptions Currently unimplemented. Pass NULL for this
		version.
	@param serviceID Reference to the default serviceID for starting
		connections, this value will be returned by the function.
	@param userOptions Reference to default userOptions for starting
		connections, this will be returned by the function.
	@result Returns TRUE if there is a valid service to dial;
		FALSE if the function was unable to retrieve a service to dial.
 */
Boolean
SCNetworkConnectionCopyUserPreferences		(
						CFDictionaryRef				  __nullable	selectionOptions,
						CFStringRef		__nonnull	* __nullable	serviceID,
						CFDictionaryRef		__nonnull	* __nullable	userOptions
						)			API_AVAILABLE(macos(10.3)) API_UNAVAILABLE(ios, tvos, watchos);


/*!
	@function SCNetworkConnectionCreateWithServiceID
	@discussion Creates a new connection reference to use for getting
		the status or for connecting or disconnecting the associated
		service.
	@param allocator The CFAllocator that should be used to allocate
		memory for the connection structure.  This parameter may be
		NULL in which case the current default CFAllocator is used.
		If this reference is not a valid CFAllocator, the behavior
		is undefined.
	@param serviceID A string that defines the service identifier
		of the connection.  Service identifiers uniquely identify
		services in the system configuration database.
	@param callout The function to be called when the status
		of the connection changes.  If this parameter is NULL, the
		application will not receive notifications of status change
		and will need to poll for updates.
	@param context The SCNetworkConnectionContext associated with the
		callout.
	@result Returns a reference to the new SCNetworkConnection.
 */
SCNetworkConnectionRef __nullable
SCNetworkConnectionCreateWithServiceID		(
						CFAllocatorRef			__nullable	allocator,
						CFStringRef					serviceID,
						SCNetworkConnectionCallBack	__nullable	callout,
						SCNetworkConnectionContext	* __nullable	context
						)			API_AVAILABLE(macos(10.3)) API_UNAVAILABLE(ios, tvos, watchos);


/*!
	@function SCNetworkConnectionCopyServiceID
	@discussion Returns the service ID associated with the SCNetworkConnection.
	@param connection The SCNetworkConnection to obtain status from.
	@result Returns the service ID associated with the SCNetworkConnection.
 */
CFStringRef __nullable
SCNetworkConnectionCopyServiceID		(
						SCNetworkConnectionRef		connection
						)			API_AVAILABLE(macos(10.3)) API_UNAVAILABLE(ios, tvos, watchos);


/*!
	@function SCNetworkConnectionGetStatus
	@discussion Returns the status of the SCNetworkConnection.
		A status is one of the following values:
<pre>
@textblock
&#32
	kSCNetworkConnectionInvalid
	kSCNetworkConnectionDisconnected
	kSCNetworkConnectionConnecting
	kSCNetworkConnectionDisconnecting
	kSCNetworkConnectionConnected
@/textblock
</pre>
	@param connection The SCNetworkConnection to obtain status from.
	@result Returns the status value.
*/
SCNetworkConnectionStatus
SCNetworkConnectionGetStatus			(
						SCNetworkConnectionRef		connection
						)			API_AVAILABLE(macos(10.3)) API_UNAVAILABLE(ios, tvos, watchos);


/*!
	@function SCNetworkConnectionCopyExtendedStatus
	@discussion Returns the extended status of the connection.
		An extended status dictionary contains specific dictionaries
		describing the status for each subcomponent of the service.

		For example, a status dictionary will contain the following
		sub-dictionaries, keys, and values:
<pre>
@textblock
&#32
	IPv4  : Addresses      : the assigned IP address.
&#32
	PPP   : Status         : the PPP-specific status of type
				 SCNetworkConnectionPPPStatus.
&#32
		LastCause      : Available when the status is "Disconnected"
				 and contains the last error associated with
				 connecting or disconnecting.
&#32
		ConnectTime    : the time when the connection was
				 established.
&#32
	Modem : ConnectSpeed   : the speed of the modem connection
				 in bits/second.
&#32
	IPSec : Status         : the IPSec-specific status of type
				 SCNetworkConnectionIPSecStatus
&#32
		ConnectTime    : the time when the connection was
				 established.

@/textblock
</pre>
		Other dictionaries could be present for PPPoE, PPTP, and L2TP.

		The status dictionary may be extended in the future to contain
		additional information.
	@param connection The SCNetworkConnection to obtain status from.
	@result Returns the status dictionary.
		If NULL is returned, the error can be retrieved using the SCError function.
 */
CFDictionaryRef __nullable
SCNetworkConnectionCopyExtendedStatus		(
						SCNetworkConnectionRef		connection
						)			API_AVAILABLE(macos(10.3)) API_UNAVAILABLE(ios, tvos, watchos);


/*!
	@function SCNetworkConnectionCopyStatistics
	@discussion Returns the statistics of the SCNetworkConnection.
		A statistic dictionary contains specific dictionaries
		with statistics for each subcomponent of the service.

		For example, a statistics dictionary will contain the following
		sub-dictionaries, keys, and values:
<pre>
@textblock
&#32
	PPP : BytesIn    :
	PPP : BytesOut   : Contains the number of bytes going up into
			   (or coming out of) the network stack for
			   any networking protocol without the PPP
			   headers and trailers.
&#32
	PPP : PacketsIn  :
	PPP : PacketsOut : Contains the number of packets going up into
			   (or coming out of) the network stack for
			   any networking protocol without the PPP
			   headers and trailers.
&#32
	PPP : ErrorsIn   :
	PPP : ErrorsOut  : Contains the number of errors going up into
			   (or coming out of) the network stack for
			   any networking protocol without the PPP
			   headers and trailers.
@/textblock
</pre>
		The statistics dictionary may be extended in the future to
		contain additional information.
	@param connection The SCNetworkConnection to obtained statistics from.
	@result Returns the statistics dictionary.
		If NULL is returned, the error can be retrieved using the SCError function.
 */
CFDictionaryRef __nullable
SCNetworkConnectionCopyStatistics		(
						SCNetworkConnectionRef		connection
						)			API_AVAILABLE(macos(10.3)) API_UNAVAILABLE(ios, tvos, watchos);


/*!
	@function SCNetworkConnectionStart
	@discussion Starts the connection for the SCNetworkConnection.
		The connection process is asynchronous and the function will
		return immediately.  The connection status can be obtained
		by polling or by callback.  The connection is made with the
		default settings from the administrator.  Some of the settings
		can be overridden for the duration of the connection.  These
		are specified in an options dictionary.  The options dictionary
		uses the same format as a network service defined in the system
		configuration preferences schema.

		Note: Starting and stopping of connections is implicitly
		arbitrated.  Calling SCNetworkConnectionStart on a connection
		already started will indicate that the application has
		interest in the connection and it shouldn't be stopped by
		anyone else.
	@param connection The SCNetworkConnection to start.
	@param userOptions The options dictionary to start the connection with.
		If userOptions is NULL, the default settings will be used.
		If userOptions are specified, they must be in the same format
		as network services stored in the system configuration
		preferences schema.  The options will override the default
		settings defined for the service.

		For security reasons, not all options can be overridden; the
		appropriate merging of all settings will be done before the
		connection is established, and inappropriate options will be
		ignored.
	@param linger This parameter indicates whether or not the connection
		can stay around when the application no longer has interest
		in it.  A typical application should pass FALSE, and the
		connection will be automatically stopped when the reference
		is released or if the application quits.  If the application
		passes TRUE, the application can release the reference or
		exit and the connection will be maintained until a timeout
		event, until a specific stop request occurs, or until an
		error is encountered.
	@result Returns TRUE if the connection was correctly started (the
		actual connection is not established yet, and the connection
		status needs to be periodically checked); FALSE if the
		connection request was not started.  The error must be
		retrieved from the SCError function.
 */
Boolean
SCNetworkConnectionStart			(
						SCNetworkConnectionRef				connection,
						CFDictionaryRef			__nullable	userOptions,
						Boolean						linger
						)			API_AVAILABLE(macos(10.3)) API_UNAVAILABLE(ios, tvos, watchos);


/*!
	@function SCNetworkConnectionStop
	@discussion Stops the connection for the SCNetworkConnection.
		The disconnection process is asynchronous and the function
		will return immediately.  The connection status can be
		obtained by polling or by callback.  This function performs
		an arbitrated stop of the connection.  If several applications
		have marked their interest in the connection, by calling
		SCNetworkConnectionStart, the call will succeed but the
		actual connection will be maintained until the last interested
		application calls SCNetworkConnectionStop.

		In certain cases, you might want to stop the connection anyway.
		In these cases, you set the forceDisconnect argument to TRUE.
	@param connection The SCNetworkConnection to stop.
	@result Returns TRUE if the disconnection request succeeded;
		FALSE if the disconnection request failed.
		The error must be retrieved from the SCError function.
 */
Boolean
SCNetworkConnectionStop				(
						SCNetworkConnectionRef		connection,
						Boolean				forceDisconnect
						)			API_AVAILABLE(macos(10.3)) API_UNAVAILABLE(ios, tvos, watchos);


/*!
	@function SCNetworkConnectionCopyUserOptions
	@discussion Copies the user options used to start the connection.
		This is a mechanism a client can use to retrieve the user options
		previously passed to the SCNetworkConnectionStart function.
	@param connection The SCNetworkConnection to obtain options from.
	@result Returns the service dictionary containing the connection options.
		The dictionary can be empty if no user options were used.
		If NULL is returned, the error can be retrieved using the SCError function.
 */
CFDictionaryRef __nullable
SCNetworkConnectionCopyUserOptions		(
						SCNetworkConnectionRef		connection
						)			API_AVAILABLE(macos(10.3)) API_UNAVAILABLE(ios, tvos, watchos);


/*!
	@function SCNetworkConnectionScheduleWithRunLoop
	@discussion Schedules a connection with the run loop.
	@param connection The SCNetworkConnection to schedule.
	@param runLoop The run loop to schedule with.
	@param runLoopMode The run loop mode.
	@result Returns TRUE if the connection is scheduled successfully;
		FALSE if the scheduling failed.
		The error can be retrieved using the SCError function.
 */
Boolean
SCNetworkConnectionScheduleWithRunLoop		(
						SCNetworkConnectionRef		connection,
						CFRunLoopRef			runLoop,
						CFStringRef			runLoopMode
						)			API_AVAILABLE(macos(10.3)) API_UNAVAILABLE(ios, tvos, watchos);


/*!
	@function SCNetworkConnectionUnscheduleFromRunLoop
	@discussion Unschedules a connection from the run loop.
	@param connection The SCNetworkConnection to unschedule.
	@param runLoop The run loop to unschedule from.
	@param runLoopMode The run loop mode.
	@result Returns TRUE if the connection is unscheduled successfully;
		FALSE if the unscheduling failed.
		The error can be retrieved using the SCError function.
 */
Boolean
SCNetworkConnectionUnscheduleFromRunLoop	(
						SCNetworkConnectionRef		connection,
						CFRunLoopRef			runLoop,
						CFStringRef			runLoopMode
						)			API_AVAILABLE(macos(10.3)) API_UNAVAILABLE(ios, tvos, watchos);


/*!
	 @function SCNetworkConnectionSetDispatchQueue
	 @discussion Caller provides a dispatch queue on which the callback contained in connection will run.
	 @param connection The SCNetworkConnection to notify.
	 @param queue The libdispatch queue to run the callback on.
		Pass NULL to disable notifications, and release queue.
	 @result Returns TRUE if the notifications have been enabled/disabled as desired;
		 FALSE if not.
		 The error can be retrieved using the SCError function.
 */
Boolean
SCNetworkConnectionSetDispatchQueue		(
						 SCNetworkConnectionRef				connection,
						 dispatch_queue_t		__nullable	queue
						 )			API_AVAILABLE(macos(10.6)) API_UNAVAILABLE(ios, tvos, watchos);

__END_DECLS

CF_ASSUME_NONNULL_END
CF_IMPLICIT_BRIDGING_DISABLED

#endif	/* _SCNETWORKCONNECTION_H */
