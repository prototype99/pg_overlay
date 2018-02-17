# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils multilib-minimal versionator

MY_PV=$(replace_version_separator 3 '-' )

DESCRIPTION="Multi-platform library designed to allow a developer to create robust software"
HOMEPAGE="http://www.jedsoft.org/slang/"
SRC_URI="https://www.jedsoft.org/snapshots/${PN}-pre${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x86-solaris"
IUSE="cjk pcre png readline static-libs zlib"

# ncurses for ncurses5-config to get terminfo directory
RDEPEND="sys-libs/ncurses:0=
	pcre? ( >=dev-libs/libpcre-8.33-r1[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}] )
	cjk? ( >=dev-libs/oniguruma-5.9.5:=[${MULTILIB_USEDEP}] )
	readline? ( >=sys-libs/readline-6.2_p5-r1:0=[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	abi_x86_32? (
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
		!<=app-emulation/emul-linux-x86-baselibs-20140406-r1
	)"
DEPEND="${RDEPEND}"

MAKEOPTS="${MAKEOPTS} -j1"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.1-slsh-libs.patch
)

S=${WORKDIR}/${PN}-pre${MY_PV}

src_prepare() {
	default

	# avoid linking to -ltermcap race with some systems
	sed -i -e '/^TERMCAP=/s:=.*:=:' configure || die
	# we use the GNU linker also on Solaris
	sed -i -e 's/-G -fPIC/-shared -fPIC/g' \
		-e 's/-Wl,-h,/-Wl,-soname,/g' configure || die

	# slang does not support configuration from another dir
	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=slang
	use readline && myconf=gnu

	econf \
		--with-readline=${myconf} \
		$(use_with pcre) \
		$(use_with cjk onig) \
		$(use_with png) \
		$(use_with zlib z)
}

multilib_src_compile() {
	emake elf $(use static-libs && echo static)

	pushd slsh >/dev/null
	emake slsh
	popd
}

multilib_src_install() {
	emake DESTDIR="${D}" install $(use static-libs && echo install-static)
}

multilib_src_install_all() {
	rm -r "${ED}"/usr/share/doc/{slang,slsh} || die
	dodoc NEWS README *.txt doc/{,internal,text}/*.txt
	docinto html
	dodoc doc/slangdoc.html slsh/doc/html/*.html
}