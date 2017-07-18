# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="false"
inherit kde5

DESCRIPTION="A data access layer handling synchronization, caching and indexing"
SRC_URI="mirror://kde/unstable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="LGPL-2+"
KEYWORDS="~amd64"
IUSE="+examples"

# qtgui is bogus but is required because something else in the deptree
# uses it as a public dependency but doesn't search for it properly
RDEPEND="
	$(add_kdeapps_dep kcontacts)
	$(add_kdeapps_dep kmime)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	dev-db/lmdb:=
	dev-libs/flatbuffers
	dev-libs/kasync
	net-libs/kdav2
	net-libs/kimap2
	sys-libs/readline:0=
"
DEPEND="${RDEPEND}
		dev-libs/libgit2"

# fails to build
RESTRICT+=" test"