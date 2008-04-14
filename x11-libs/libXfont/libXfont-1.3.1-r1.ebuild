# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXfont/libXfont-1.3.1-r1.ebuild,v 1.9 2008/04/13 22:50:49 vapier Exp $

EAPI="prefix"

# Must be before x-modular eclass is inherited
# SNAPSHOT="yes"

inherit x-modular flag-o-matic autotools

DESCRIPTION="X.Org Xfont library"

KEYWORDS="~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="ipv6"

RDEPEND="x11-libs/xtrans
	x11-libs/libfontenc
	x11-proto/xproto
	x11-proto/fontsproto
	>=media-libs/freetype-2"
DEPEND="${RDEPEND}
	x11-proto/fontcacheproto"

CONFIGURE_OPTIONS="$(use_enable ipv6)
	--with-encodingsdir=/usr/share/fonts/encodings"

PATCHES="
	${FILESDIR}/0001-Fix-for-CVE-2008-0006-PCF-Font-parser-buffer-overf.patch
	"

src_unpack() {
	x-modular_src_unpack
	eautoreconf # need new libtool for interix
}

src_compile() {
	[[ ${CHOST} == *-interix* ]] && append-flags "-D_ALL_SOURCE"
	x-modular_src_compile
}

pkg_setup() {
	# No such function yet
	# x-modular_pkg_setup

	# (#125465) Broken with Bdirect support
	filter-flags -Wl,-Bdirect
	filter-ldflags -Bdirect
	filter-ldflags -Wl,-Bdirect
}
