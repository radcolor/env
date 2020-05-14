#!/usr/bin/env bash

# Copyright (C) 2020 Shashank Baghel
# Personal kernel build script for https://github.com/theradcolor/android_kernel_xiaomi_whyred

# Set enviroment and vaiables
wd=$(pwd)
out=$wd/out
ANYKERNEL_DIR="/home/shashank/whyred/anykernel-test/"
BUILD="/home/shashank/whyred/msm-4.4"
DATE=$(date +"%m-%d-%y")
BUILD_START=$(date +"%s")

export CROSS_COMPILE_ARM32=/home/shashank/whyred/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
export CROSS_COMPILE=/home/shashank/whyred/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CLANG_TRIPLE=aarch64-linux-gnu-

echo -e "*****************************************************"
echo "                      Compile kernel                    "
echo -e "*****************************************************"

# Set kernel source workspace
cd $BUILD
# Export ARCH <arm, arm64, x86, x86_64>
export ARCH=arm64
# Export SUBARCH <arm, arm64, x86, x86_64>
export SUBARCH=arm64

# CCACHE parameters
ccache=$(which ccache)
export USE_CCACHE=1
export CCACHE_DIR="/home/theradcolor/.ccache"
export PATH="/usr/lib/ccache:$PATH"

# Compiler String
export KBUILD_COMPILER_STRING="$(${CC} --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')"

# Make and Clean
make O=$out clean
make O=$out mrproper

# Make whyred-perf_defconfig
make O=$out whyred-perf_defconfig

# Build Kernel
make -j12 O=$out ARCH=arm64 CC="${ccache} /home/shashank/whyred/clang-x/bin/clang"
CROSS_COMPILE="${GCC64}" CROSS_COMPILE_ARM32="${GCC32}" CLANG_TRIPLE="${GCC64_TYPE}"


BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$Yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"

echo -e "Making Flashable Template using anykernel2"

# Clean anykernel2 directory
rm -f ${ANYKERNEL_DIR}/Image.gz*
rm -f ${ANYKERNEL_DIR}/zImage*
rm -f ${ANYKERNEL_DIR}/dtb*

# Change the directory to anykernel2 directory
cd ${ANYKERNEL_DIR}
#remove all zips
rm *.zip

# Copy thhe image.gz-dtb to anykernel2 directory
cp $out/arch/arm64/boot/Image.gz-dtb ${ANYKERNEL_DIR}/

#Build a flashable zip Device using anykernel2
zip -r9 kernel-$DATE.zip * -x README.md .git
