# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Sys-Syslog/Sys-Syslog-0.27.ebuild,v 1.1 2008/10/11 08:17:59 tove Exp $

EAPI="prefix"

MODULE_AUTHOR=SAPER
inherit perl-module

DESCRIPTION="Provides same functionality as BSD syslog"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="dev-lang/perl"

# Tests disabled - they attempt to verify on the live system
#SRC_TEST="do"
