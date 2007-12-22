#!/bin/sh
# Copyright (c) 2006-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Contributed by Roy Marples (uberlord@gentoo.org)

# Setup our resolv.conf
# Vitally important that we use the domain entry in resolv.conf so we
# can setup the nameservers are for the domain ONLY in resolvconf if
# we're using a decent dns cache/forwarder like dnsmasq and NOT nscd/libc.
# nscd/libc users will get the VPN nameservers before their other ones
# and will use the first one that responds - maybe the LAN ones?
# non resolvconf users just the the VPN resolv.conf

# FIXME:- if we have >1 domain, then we have to use search :/
# We need to add a flag to resolvconf to say
# "these nameservers should only be used for the listed search domains
#  if other global nameservers are present on other interfaces"
# This however, will break compatibility with Debians resolvconf
# A possible workaround would be to just list multiple domain lines
# and try and let resolvconf handle it

if [ "${PEER_DNS}" != "no" ]; then
	NS=
	DOMAIN=
	SEARCH=
	i=1
	while true ; do
		eval opt=\$foreign_option_${i}
		[ -z "${opt}" ] && break
		if [ "${opt}" != "${opt#dhcp-option DOMAIN *}" ] ; then
			if [ -z "${DOMAIN}" ] ; then
				DOMAIN="${opt#dhcp-option DOMAIN *}"
			else
				SEARCH="${SEARCH:+ }${opt#dhcp-option DOMAIN *}"
			fi
		elif [ "${opt}" != "${opt#dhcp-option DNS *}" ] ; then
			NS="${NS}nameserver ${opt#dhcp-option DNS *}\n"
		fi
		i=$((${i} + 1))
	done

	if [ -n "${NS}" ] ; then
		DNS="# Generated by openvpn for interface ${dev}\n"
		if [ -n "${SEARCH}" ] ; then
			DNS="${DNS}search ${DOMAIN} ${SEARCH}\n"
		else
			DNS="${DNS}domain ${DOMAIN}\n"
		fi
		DNS="${DNS}${NS}"
		if [ -x /sbin/resolvconf ] ; then
			printf "${DNS}" | /sbin/resolvconf -a "${dev}"
		else
			# Preserve the existing resolv.conf
			if [ -e /etc/resolv.conf ] ; then
				cp /etc/resolv.conf /etc/resolv.conf-"${dev}".sv
			fi
			printf "${DNS}" > /etc/resolv.conf
			chmod 644 /etc/resolv.conf
		fi
	fi
fi

# Below section is Gentoo specific
# Quick summary - our init scripts are re-entrant and set the SVCNAME env var
# as we could have >1 openvpn service

# If we have a service specific script, run this now
if [ -x /etc/openvpn/"${SVCNAME}"-up.sh ] ; then
	/etc/openvpn/"${SVCNAME}"-up.sh "$@"
fi

# Re-enter the init script to start any dependant services
if ! /etc/init.d/"${SVCNAME}" --quiet status ; then
	export IN_BACKGROUND=true
	/etc/init.d/${SVCNAME} --quiet start
fi

exit 0

# vim: ts=4 :
