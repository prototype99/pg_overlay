# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION=""
HOMEPAGE="https://gitlab.com/gnuwget/wget2"
SRC_URI="mirror://gnu-alpha/wget/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="brotli bzip2 doc +gnutls gpgme +http2 idn lzma pcre psl test valgrind xattr zlib"

REQUIRED_USE="valgrind? ( test )"

RDEPEND="
	brotli? ( app-arch/brotli )
	bzip2? ( app-arch/bzip2 )
	!gnutls? ( dev-libs/libgcrypt )
	gnutls? ( net-libs/gnutls )
	gpgme? (
		app-crypt/gpgme
		dev-libs/libassuan
		dev-libs/libgpg-error
	)
	http2? ( net-libs/nghttp2 )
	idn? ( net-dns/libidn2 )
	lzma? ( app-arch/xz-utils )
	pcre? ( dev-libs/libpcre2 )
	psl? ( net-libs/libpsl )
	xattr? ( sys-apps/attr )
	zlib? ( sys-libs/zlib )
"

# man pages require app-text/pandoc which requires lots of haskell stuff
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
	valgrind? ( dev-util/valgrind )
"

src_configure() {
	local myeconfargs=(
		--with-plugin-support
		--without-libidn
		--without-libmicrohttpd
		$(use_enable doc)
		$(use_enable valgrind valgrind-tests)
		$(use_enable xattr)
		$(use_with brotli brotlidec)
		$(use_with bzip2)
		$(use_with gnutls)
		$(use_with gpgme)
		$(use_with http2 libnghttp2)
		$(use_with idn libidn2)
		$(use_with lzma)
		$(use_with pcre libpcre2)
		$(use_with psl libpsl)
		$(use_with zlib)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	doman "${FILESDIR}"/${PN}.1
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
	rm "${ED%/}"/usr/bin/${PN}_noinstall || die
}
