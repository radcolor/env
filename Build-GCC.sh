############################################
#   theradcolor custom kernel build script #
############################################

# Set defaults
wd=$(pwd)
out=$wd/out
ANYKERNEL_DIR=${HOME}/anykernel2
BUILD="/home/theradcolor/kernel/"
DATE=$(date +"%m-%d-%y")
BUILD_START=$(date +"%s")

echo -e "*****************************************************"
echo "              Compiling  kernel using GCC               "
echo -e "*****************************************************"

# Set kernel source workspace
cd $BUILD

# Export ARCH <arm, arm64, x86, x86_64>
export ARCH=arm64
# Export SUBARCH <arm, arm64, x86, x86_64>
export SUBARCH=arm64

# Set kernal name
export LOCALVERSION=theradcolor
# Export Username
export KBUILD_BUILD_USER=theradcolor
# Export Machine name
export KBUILDar_BUILD_HOST=UBUNTU

# Compiler String
export CROSS_COMPILE=/home/theradcolor/toolchain/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=/home/theradcolor/toolchainX32/bin/arm-eabi-

# Make and Clean
make O=$out clean
make O=$out mrproper

# Make whyred_defconfig
make O=$out ARCH=arm64 device_defconfig

# Build Kernel
make O=$out ARCH=arm64 -j4

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
zip -r9 kernel-$DATE.zip * -x README kernel-$DATE.zip
