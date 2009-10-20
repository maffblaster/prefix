# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/python-updater/python-updater-0.7.ebuild,v 1.8 2009/10/17 19:22:40 arfrever Exp $

inherit eutils multilib

DESCRIPTION="Script used to remerge python packages when changing Python version."
HOMEPAGE="http://www.gentoo.org/proj/en/Python"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc-aix ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND="!<dev-lang/python-2.3.6-r2
	>=sys-apps/portage-2.1.2"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-prefix.patch
	ebegin "Adjusting to prefix"
	sed -i \
		-e "s:@GENTOO_PORTAGE_EPREFIX@:${EPREFIX}:g" \
		-e "s:@GENTOO_PORTAGE_LIBSUFFIX@:$(get_libname):g" \
		"${PN}" || die "eprefixify failed"
	eend $?
}

src_install()
{
	dosbin ${PN} || die "dosbin failed"
	doman ${PN}.1 || die "doman failed"
	dodoc AUTHORS ChangeLog || die "dodoc failed"
}
