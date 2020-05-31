#!/usr/bin/env bash

#Copyright (C) 2020 Shashank Baghel
#Personal kernel build script for https://github.com/theradcolor/android_kernel_xiaomi_whyred

#Set enviroment and vaiables
wd=$(pwd)
out="/home/theradcolor/whyred/out/"
BUILD="/home/theradcolor/whyred/kernel/"
ANYKERNEL_DIR_EAS="/home/shashank/whyred/anykernel-eas/"
ANYKERNEL_DIR_HMP="/home/shashank/whyred/anykernel-hmp/"
IMG="/home/theradcolor/whyred/out/arch/arm64/boot/Image.gz-dtb"
DATE=$(date +"%d-%m-%y")
BUILD_START=$(date +"%s")

red='\033[0;31m'
green='\e[0;32m'

#Export compiler dir.
CLANG_TRIPLE=aarch64-linux-gnu-
GCC64=/home/theradcolor/whyred/compilers/aarch64-linux-android-4.9/bin/aarch64-linux-android-
GCC32=/home/theradcolor/whyred/compilers/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-

#Export ARCH <arm, arm64, x86, x86_64>
export ARCH=arm64
#Export SUBARCH <arm, arm64, x86, x86_64>
export SUBARCH=arm64

#CCACHE parameters
ccache=$(which ccache)
export USE_CCACHE=1
export CCACHE_DIR="/home/theradcolor/.ccache"

#kbuild host and user
export KBUILD_BUILD_USER="shashank"
export KBUILD_BUILD_HOST="manjaro-linux"

#Compiler String
CC="${ccache} /home/theradcolor/whyred/compilers/clang-r383902/bin/clang"
export KBUILD_COMPILER_STRING="$(${CC} --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')"

function build_clang()
{
    cd $BUILD
    make O=$out clean
    make O=$out mrproper
    rm -rf $out/arch/arm64/boot
    make O=$out whyred-perf_defconfig

    make O=$out CC="${CC}" \
    CROSS_COMPILE="${GCC64}" \
    CROSS_COMPILE_ARM32="${GCC32}" \
    CLANG_TRIPLE="${CLANG_TRIPLE}" \
    -j6
    
    if [ -f $IMG ]; then
        BUILD_END=$(date +"%s")
        DIFF=$(($BUILD_END - $BUILD_START))
        echo -e $green "<< Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds. >>"
	else
		echo -e $red "<< Build failed, please fix the errors first bish! >>"
	fi
}

build_clang
