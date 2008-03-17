# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-SAX/XML-SAX-0.16.ebuild,v 1.9 2007/11/19 02:53:11 kumba Exp $

EAPI="prefix"

inherit perl-module eutils

DESCRIPTION="Perl module for using and building Perl SAX2 XML parsers, filters, and drivers"
SRC_URI="mirror://cpan/authors/id/G/GR/GRANTM/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~grantm/"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

DEPEND=">=dev-perl/XML-NamespaceSupport-1.04
	>=dev-libs/libxml2-2.4.1
	>=sys-apps/sed-4
	dev-lang/perl"

SRC_TEST="do"

src_unpack() {
	local installvendorlib
	eval $(perl '-V:installvendorlib')
	unpack ${A}
	cd "${S}"
	sed -i \
		-e 's/if (\$write_ini_ok)/if (0 \&\& $write_ini_ok)/' \
		Makefile.PL || die
	epatch "${FILESDIR}"/encodings.patch
}

pkg_postinst() {
	perl-module_pkg_postinst
	perl -MXML::SAX \
		-e "XML::SAX->add_parser(q(XML::SAX::PurePerl))->save_parsers()" \
		|| die "error adding parser"
}
