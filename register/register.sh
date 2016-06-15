#!/bin/sh

QEMU_BIN_DIR=${QEMU_BIN_DIR:-/usr/bin}


if [ ! -d /proc/sys/fs/binfmt_misc ]; then
    echo "No binfmt support in the kernel."
    echo "  Try: '/sbin/modprobe binfmt_misc' from the host"
    exit 1
fi


if [ ! -f /proc/sys/fs/binfmt_misc/register ]; then
    mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
fi


if [ "${1}" = "--reset" ]; then
    (
	cd /proc/sys/fs/binfmt_misc
	for file in *; do
	    case "${file}" in
		status|register)
		    ;;
		*)
		    echo -1 > "${file}"
		    ;;
	    esac
	done
    )
fi


# probe cpu type
cpu=`uname -m`
case "$cpu" in
    i386|i486|i586|i686|i86pc|BePC|x86_64)
        cpu="i386"
        ;;
    m68k)
        cpu="m68k"
        ;;
    mips*)
        cpu="mips"
        ;;
    "Power Macintosh"|ppc|ppc64*)
        cpu="ppc"
        ;;
    armv[4-9]*)
        cpu="arm"
        ;;
esac


# register the interpreter for each cpu except for the native one
if [ $cpu != "i386" ] ; then
    echo ':i386:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03\x00:\xff\xff\xff\xff\xff\xfe\xfe\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:'${QEMU_BIN_DIR}'/qemu-i386-static:' > /proc/sys/fs/binfmt_misc/register
    echo ':i486:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x06\x00:\xff\xff\xff\xff\xff\xfe\xfe\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:'${QEMU_BIN_DIR}'/qemu-i386-static:' > /proc/sys/fs/binfmt_misc/register
fi
if [ $cpu != "alpha" ] ; then
    echo ':alpha:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x26\x90:\xff\xff\xff\xff\xff\xfe\xfe\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:'${QEMU_BIN_DIR}'/qemu-alpha-static:' > /proc/sys/fs/binfmt_misc/register
fi
if [ $cpu != "arm" ] ; then
    echo   ':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:'${QEMU_BIN_DIR}'/qemu-arm-static:' > /proc/sys/fs/binfmt_misc/register
    echo   ':armeb:M::\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:'${QEMU_BIN_DIR}'/qemu-armeb-static:' > /proc/sys/fs/binfmt_misc/register
fi
if [ $cpu != "aarch64" ] ; then
    echo ':aarch64:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:'${QEMU_BIN_DIR}'/qemu-aarch64-static:' > /proc/sys/fs/binfmt_misc/register
fi
if [ $cpu != "sparc" ] ; then
    echo   ':sparc:M::\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x02:\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:'${QEMU_BIN_DIR}'/qemu-sparc-static:' > /proc/sys/fs/binfmt_misc/register
fi
if [ $cpu != "ppc" ] ; then
    echo   ':ppc:M::\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x14:\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:'${QEMU_BIN_DIR}'/qemu-ppc-static:' > /proc/sys/fs/binfmt_misc/register
    echo   ':ppc64le:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x15\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\x00:'${QEMU_BIN_DIR}'/qemu-ppc64le-static:' > /proc/sys/fs/binfmt_misc/register
fi
if [ $cpu != "m68k" ] ; then
    echo   ':m68k:M::\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x04:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:'${QEMU_BIN_DIR}'/qemu-m68k-static:' > /proc/sys/fs/binfmt_misc/register
fi
if [ $cpu != "mips" ] ; then
    # FIXME: We could use the other endianness on a MIPS host.
    echo   ':mips:M::\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:'${QEMU_BIN_DIR}'/qemu-mips-static:' > /proc/sys/fs/binfmt_misc/register
    echo   ':mipsel:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:'${QEMU_BIN_DIR}'/qemu-mipsel-static:' > /proc/sys/fs/binfmt_misc/register
    echo   ':mipsn32:M::\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:'${QEMU_BIN_DIR}'/qemu-mipsn32-static:' > /proc/sys/fs/binfmt_misc/register
    echo   ':mipsn32el:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:'${QEMU_BIN_DIR}'/qemu-mipsn32el-static:' > /proc/sys/fs/binfmt_misc/register
    echo   ':mips64:M::\x7fELF\x02\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:'${QEMU_BIN_DIR}'/qemu-mips64-static:' > /proc/sys/fs/binfmt_misc/register
    echo   ':mips64el:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:'${QEMU_BIN_DIR}'/qemu-mips64el-static:' > /proc/sys/fs/binfmt_misc/register
fi
if [ $cpu != "sh" ] ; then
    echo    ':sh4:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x2a\x00:\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:'${QEMU_BIN_DIR}'/qemu-sh4-static:' > /proc/sys/fs/binfmt_misc/register
    echo    ':sh4eb:M::\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x2a:\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:'${QEMU_BIN_DIR}'/qemu-sh4eb-static:' > /proc/sys/fs/binfmt_misc/register
fi
if [ $cpu != "s390x" ] ; then
    echo   ':s390x:M::\x7fELF\x02\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x16:\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:'${QEMU_BIN_DIR}'/qemu-s390x-static:' > /proc/sys/fs/binfmt_misc/register
fi
