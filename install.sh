#!/bin/sh

function install-sunxi-tools {
	_DESTDIR="$1"
	_BINDIR="/bin"
	_SBINDIR="$_BINDIR"
	_MANDIR="/man"

	mkdir -p "$_DESTDIR"

	echo "Installing sunxi-tools"

	mkdir -p sources
	cd sources
	git clone http://github.com/linux-sunxi/sunxi-tools

	cd sunxi-tools
	make && make install DESTDIR="$_DESTDIR" BINDIR="$_BINDIR" SBINDIR="$_SBINDIR" MANDIR="$_MANDIR" && make install-misc DESTDIR="$_DESTDIR" BINDIR="$_BINDIR" SBINDIR="$_SBINDIR" MANDIR="$_MANDIR" 
	cd ../..

	echo "Linking sunxi-fel to fel"
	ln -s $_DESTDIR$_BINDIR/sunxi-fel $_DESTDIR$_BINDIR/fel
}

function install-chip-mtd-utils {
	_DESTDIR="$1"
	_BINDIR="/bin"
	_SBINDIR="$_BINDIR"
	_MANDIR="/man"

	mkdir -p "$_DESTDIR"

	mkdir -p sources
	cd sources
	git clone http://github.com/nextthingco/chip-mtd-utils
	cd chip-mtd-utils
	git checkout by/1.5.2/next-mlc-debian

	echo "Installing chip-mtd-utils.."
	cd chip-mtd-utils
	make && make install DESTDIR="$_DESTDIR" BINDIR="$_BINDIR" SBINDIR="$_SBINDIR" MANDIR="$_MANDIR" 
	cd ../..
}

function install-img2simg {
	_DESTDIR="$1"
	_BINDIR="/bin"
	_SBINDIR="$_BINDIR"
	_MANDIR="/man"

	mkdir -p "$_DESTDIR"

	mkdir -p sources
	cd sources
	git clone https://android.googlesource.com/platform/system/core img2simg
	cd img2simg/libsparse
	git checkout android-7.1.2_r11
	gcc -o img2simg -Iinclude img2simg.c sparse_crc32.c backed_block.c output_file.c sparse.c sparse_err.c sparse_read.c -lz
	ln -s $(pwd)/img2simg $_DESTDIR$_BINDIR/img2simg
	cd ../..
}

function install-tools {
	install-sunxi-tools "$1"
	install-chip-mtd-utils "$1"
	install-img2simg "$1"

	echo "PATH=$1/bin:$PATH"
}

install-tools "$1"
