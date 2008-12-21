# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/popt/popt-1.13.ebuild,v 1.1 2008/01/07 06:00:49 dirtyepic Exp $

EAPI="prefix"

inherit eutils autotools

DESCRIPTION="Parse Options - Command line parser"
HOMEPAGE="http://rpm5.org/"
SRC_URI="http://rpm5.org/files/popt/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~ppc-aix ~x86-freebsd ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-1.12-scrub-lame-gettext.patch

	epatch "${FILESDIR}"/${P}-no-wchar-hack.patch # for Interix

	# Platforms that do not have iconv in libc (Darwin, Solaris, ...) will fail
	# if no -liconv is given.  This is one error, but also when nls is not in
	# USE, libiconv needs not to be available, so just make configure blind for
	# any iconv functions.
	use nls || epatch "${FILESDIR}"/${P}-no-acfunc-iconv.patch
}

src_compile() {
	econf \
		--without-included-gettext \
		$(use_enable nls) \
		|| die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc CHANGES README
}
