#####################
#    theradcolor    #
#####################

# Set defaults
wd=$(pwd)
out=$wd/out
BUILD="/home/theradcolor/kernel/source"
ANYKERNEL_DIR=${HOME}/anykernel2
BUILD="/home/theradcolor/kernel/"
DATE=$(date +"%m-%d-%y")
BUILD_START=$(date +"%s")

echo -e "*****************************************************"
echo "                      Compile kernel                    "
echo -e "*****************************************************"

# Set kernel source workspace
cd $BUILD

# Export ARCH <arm, arm64, x86, x86_64>
export ARCH=arm64
export SUBARCH=arm64

# Set kernal configurations
export LOCALVERSION=-x1
export KBUILD_BUILD_USER=theradcolor
export KBUILD_BUILD_HOST=ILLYRIA

# Compiler String
CC=/home/theradcolor/kernel/linux-x86/clang-r353983c/bin/clang
export KBUILD_COMPILER_STRING="$(${CC} --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')"

# Make and Clean
make O=$out clean
make O=$out mrproper

# Make <defconfig>
make O=$out ARCH=arm64 device_defconfig

# Build Kernel
make O=$out ARCH=arm64 \
CC=home/theradcolor/kernel/linux-x86/clang-r353983c/bin/clang \
CLANG_TRIPLE=aarch64-linux-gnu- \
CROSS_COMPILE=/home/theradcolor/kernel/... \
-j9


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
zip -r9 kernel-$DATE.zip * -x README kernel-$DATE.zip#!/bin/bash
