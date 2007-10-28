# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/python-updater/python-updater-0.2.ebuild,v 1.18 2007/10/26 09:37:48 hawking Exp $

EAPI="prefix"

inherit eutils

DESCRIPTION="Script used to remerge python packages when changing Python version."
HOMEPAGE="http://dev.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc-aix ~ppc-macos ~sparc-solaris ~x86 ~x86-fbsd ~x86-macos ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND="!<dev-lang/python-2.3.6-r2
	|| ( >=sys-apps/portage-2.1.2 sys-apps/pkgcore sys-apps/paludis )"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-prefix.patch
	eprefixify ${P}
}

src_install()
{
	cd "${WORKDIR}"
	newsbin ${P} ${PN}
}
