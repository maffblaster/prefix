# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-LibXML-Common/XML-LibXML-Common-0.13.ebuild,v 1.21 2007/01/19 17:31:08 mcummings Exp $

EAPI="prefix"

inherit perl-module

DESCRIPTION="Routines and Constants common for XML::LibXML and XML::GDOME"
HOMEPAGE="http://search.cpan.org/~phish/"
SRC_URI="mirror://cpan/authors/id/P/PH/PHISH/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~mips ~x86"
IUSE=""

DEPEND=">=dev-libs/libxml2-2.4.1
	dev-lang/perl"
