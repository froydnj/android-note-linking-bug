#!/bin/sh

if [ -z "$NDK_DIR" ]; then
    echo Please point the NDK_DIR environment variable at an NDK
    exit 1
fi

if [ ! -d "$NDK_DIR" ]; then
    echo NDK_DIR environment variable is not a directory
    exit 1
fi

if [ $# -lt 1 ]; then
    echo must provide an argument "(ld.bfd or ld.gold)"
    exit
fi

LINKER=$1

case "$LINKER" in
    ld.bfd|ld.gold)
	;;
    *)
	echo Do not understand how to use $LINKER
	exit 1
	;;
esac

${NDK_DIR}/toolchains/llvm/prebuilt/linux-x86_64/x86_64-linux-android/bin/${LINKER} \
    --sysroot=${NDK_DIR}/platforms/android-21/arch-x86_64 \
    -pie -z now -z relro --hash-style=gnu --hash-style=both --enable-new-dtags \
    --eh-frame-hdr -m elf_x86_64 -dynamic-linker /system/bin/linker64 \
    -o libplugin-container.so \
    ${NDK_DIR}/platforms/android-21/arch-x86_64/usr/lib/../lib64/crtbegin_dynamic.o \
    -L${NDK_DIR}/platforms/android-21/arch-x86_64/usr/lib \
    -L${NDK_DIR}/sources/cxx-stl/llvm-libc++/libs/x86_64 \
    -L${NDK_DIR}/toolchains/x86_64-4.9/prebuilt/linux-x86_64/lib/gcc/x86_64-linux-android/4.9.x \
    -L${NDK_DIR}/toolchains/x86_64-4.9/prebuilt/linux-x86_64/lib/gcc/x86_64-linux-android/4.9.x/../../../../x86_64-linux-android/lib/../lib64 \
    -L${NDK_DIR}/platforms/android-21/arch-x86_64/usr/lib/../lib64 \
    -L${NDK_DIR}/toolchains/x86_64-4.9/prebuilt/linux-x86_64/lib/gcc/x86_64-linux-android/4.9.x/../../../../x86_64-linux-android/lib \
    -L${NDK_DIR}/platforms/android-21/arch-x86_64/usr/lib \
    MozillaRuntimeMainAndroid.o \
    -rpath-link=${NDK_DIR}/platforms/android-21/arch-x86_64/usr/lib \
    -z noexecstack -z text -z relro -z nocopyreloc -Bsymbolic-functions --build-id=sha1 --hash-style=sysv \
    -rpath-link /usr/local/lib \
    -llog -lc++_static -lc++abi -v -lstdc++ -lm -lgcc -ldl -lc -lgcc -ldl \
    ${NDK_DIR}/platforms/android-21/arch-x86_64/usr/lib/../lib64/crtend_android.o
