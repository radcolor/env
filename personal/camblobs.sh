#!/usr/bin/env bash

#Copyright (C) 2020 Shashank Baghel
#To change camera blobs campability in kernel https://github.com/theradcolor/android_kernel_xiaomi_whyred

#Configure kernel source directory here
KERNEL_SOURCE=/home/theradcolor/whyred/kernel

green='\e[0;32m'
white='\033[0m'
CAMERA="$(grep 'BLOBS' $KERNEL_SOURCE/arch/arm64/configs/whyred-perf_defconfig)"
if [ $CAMERA == "CONFIG_XIAOMI_NEW_CAMERA_BLOBS=y" ]; then
        PATCH="CONFIG_XIAOMI_NEW_CAMERA_BLOBS=n"
elif [ $CAMERA == "CONFIG_XIAOMI_NEW_CAMERA_BLOBS=n" ]; then
        PATCH="CONFIG_XIAOMI_NEW_CAMERA_BLOBS=y"
fi

#Change the compability
sed -i 's/'"$CAMERA"/"$PATCH"'/g' $KERNEL_SOURCE/arch/arm64/configs/whyred-perf_defconfig

AFTER_PATCH="$(grep 'BLOBS' $KERNEL_SOURCE/arch/arm64/configs/whyred-perf_defconfig)"
if [ $AFTER_PATCH == "CONFIG_XIAOMI_NEW_CAMERA_BLOBS=y" ]; then
        echo -e $green"Changed compability for NEW camera blobs!"$white
elif [ $AFTER_PATCH == "CONFIG_XIAOMI_NEW_CAMERA_BLOBS=n" ]; then
        echo -e $green"Changed compability for OLD camera blobs!"$white
fi