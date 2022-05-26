#!/bin/sh
# Copyright 2006-2022 Gentoo Authors; Distributed under the GPL v2

# bash installer
#
# POSIX (?) /bin/sh which doesn't eat most of the stuff in the
# bootstrap-prefix script, among which the most important part:
# dynamic function calling.  So, we need to bootstrap bash outside the
# bootstrap script, which is the purpose of this script.

# TODO: `mktemp -d` can be used to safely create a random temp directory...

PREFIX_BOOTSTRAP_BASH_VERSION="bash-5.1" # Upstream supports bash-5.1.xxx for patch set.
PREFIX_BOOTSTRAP_BASH_BUILD_DIRECTORY="" # Declare variable for later use.

# The following URI can be used to download bash directly from upstream...
#GNU_BASH_URI="https://ftp.gnu.org/gnu/bash/${PREFIX_BOOTSTRAP_BASH_VERSION}.tar.gz"

GENTOO_MIRRORS=${GENTOO_MIRRORS:="http://distfiles.gentoo.org/distfiles"}

if [ -z "${1}" ] ; then
	echo "usage: ${0} <location>" > /dev/stderr
	exit 255
fi

PREFIX_BOOTSTRAP_BASH_BUILD_DIRECTORY="${1}"

mkdir -p "${PREFIX_BOOTSTRAP_BASH_BUILD_DIRECTORY}/bash-build" || exit 1
cd "${PREFIX_BOOTSTRAP_BASH_BUILD_DIRECTORY}" || exit 1

command_exists() {
	check_cmd="${1}"
	command -v "$check_cmd" >/dev/null 2>&1
}

same_file() {
	file1="${1}"
	file2="${2}"

	if [ "$(stat -c '%i%d' "${file1}" "${file2}" | sort -u | wc -l)" -eq 1 ]; then
		return 0
	else
		return 1
	fi
}

if [ ! -e "${PREFIX_BOOTSTRAP_BASH_VERSION}.tar.gz" ] ; then
	eerror() { echo -e "!!! ${*}" 1>&2; }
	einfo() { echo -e "* ${*}"; }

	if [ -z "${FETCH_COMMAND}" ] ; then
		# Try to find a download manager, this script only deals with wget,
		# curl, FreeBSD's fetch, and ftp...
		if command_exists wget; then
			FETCH_COMMAND="wget"
			case "$(wget -h 2>&1)" in
				*"--no-check-certificate"*)
					FETCH_COMMAND="$FETCH_COMMAND --no-check-certificate"
					;;
			esac
		elif command_exists curl; then
			einfo "WARNING: curl doesn't fail when downloading fails, please check its output carefully!"
			FETCH_COMMAND="curl -f -L -O"
		elif command_exists fetch; then
			FETCH_COMMAND="fetch"
		elif command_exists ftp; then
			FETCH_COMMAND="ftp"
			case "${CHOST}" in
				*-cygwin*)
					if same_file "$(command -v ftp)" "$(cygpath -S)/ftp"; then
						FETCH_COMMAND=''
					fi
					;;
			esac
		fi
		if [ -z "${FETCH_COMMAND}" ]; then
			eerror "No suitable download manager found (need wget, curl, fetch or ftp)."
			eerror "Could not download ${1##*/}"
			eerror "Download the file manually, and put it in ${PWD}"
			exit 1
		fi
	fi
	${FETCH_COMMAND} "${GENTOO_MIRRORS}/${PREFIX_BOOTSTRAP_BASH_VERSION}.tar.gz" < /dev/null
fi

gzip -d ${PREFIX_BOOTSTRAP_BASH_VERSION}.tar.gz
tar -xf ${PREFIX_BOOTSTRAP_BASH_VERSION}.tar
cd ${PREFIX_BOOTSTRAP_BASH_VERSION} || exit 1

./configure --prefix="${PREFIX_BOOTSTRAP_BASH_BUILD_DIRECTORY}/usr" --disable-nls
make
make install

if [ "${?}" -eq "0" ]; then
	echo
	einfo "${PREFIX_BOOTSTRAP_BASH_VERSION} compiled successfully. Run:"
	einfo "  export PATH='/var/tmp/bash/usr/bin:\${PATH}'"
	einfo "To add ${PREFIX_BOOTSTRAP_BASH_VERSION} to the shell's PATH variable."
	echo
else
	echo
	einfo "${PREFIX_BOOTSTRAP_BASH_VERSION} compilation failed."
	einfo "It may be necessary to file a bug."
	echo
fi