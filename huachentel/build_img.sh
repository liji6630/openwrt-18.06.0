#!/bin/bash

WORK_PATH=`pwd`
ROOT_PATH=`pwd`/../

KERNEL_BIN="$ROOT_PATH"/build_dir/target-aarch64_generic_glibc/linux-layerscape_armv8_64b/Image
DTB104_BIN="$ROOT_PATH"/build_dir/target-aarch64_generic_glibc/linux-layerscape_armv8_64b/linux-4.9.111/arch/arm64/boot/dts/freescale/hc-ls1043a-hcen104-sdk.dtb
DTB1002_BIN="$ROOT_PATH"/build_dir/target-aarch64_generic_glibc/linux-layerscape_armv8_64b/linux-4.9.111/arch/arm64/boot/dts/freescale/hc-ls1043a-hcen1002-sdk.dtb

function generate_img()
{
	if [ ! -f "$KERNEL_BIN" ]; then
		echo "$KERNEL_BIN" not found 
		exit 0
	fi
	if [ ! -f "$DTB104_BIN" ]; then
		echo "$DTB104_BIN" not found 
		exit 0
	fi
	if [ ! -f "$DTB1002_BIN" ]; then
		echo "$DTB1002_BIN" not found 
		exit 0
	fi
	
	if [ ! -d "$WORK_PATH"/images ];then
		mkdir "$WORK_PATH"/images
		cp "$KERNEL_BIN" "$WORK_PATH"/images
		cp "$DTB104_BIN" "$WORK_PATH"/images
		cp "$DTB1002_BIN" "$WORK_PATH"/images
		cp "$WORK_PATH"/linux_arm64.its "$WORK_PATH"/images
		#generate gzip
		cd "$WORK_PATH"/images
		gzip -9 Image
		gzip -9 root.ext4
		mkimage -f linux_arm64.its lsdk_linux_arm64_tiny.itb
		mv lsdk_linux_arm64_tiny.itb "$WORK_PATH"
	fi
	
	rm -rf "$WORK_PATH"/images
}

generate_img
