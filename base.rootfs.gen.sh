#!/bin/bash

CROSS_TOOLCHAIN_LIB_DIR=/home/wyao/extend/toolchain/gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabi/arm-linux-gnueabi/libc/lib

cd ..
mkdir rootfs
cp -raf ../_install/* ./rootfs/
mkdir -p rootfs/proc/
mkdir -p rootfs/sys/
mkdir -p rootfs/tmp/
mkdir -p rootfs/root/
mkdir -p rootfs/var/
mkdir -p rootfs/mnt/
mkdir -p rootfs/mnt/disk1
mkdir -p rootfs/lib
mkdir -p rootfs/home
cp -arf $CROSS_TOOLCHAIN_LIB_DIR/* rootfs/lib/
sudo rm rootfs/lib/*.a
sudo mkdir -p rootfs/dev/

sudo mknod rootfs/dev/tty1 c 4 1
sudo mknod rootfs/dev/tty2 c 4 2
sudo mknod rootfs/dev/tty3 c 4 3
sudo mknod rootfs/dev/tty4 c 4 4
sudo mknod rootfs/dev/console c 5 1
sudo mknod rootfs/dev/null c 1 3

sudo mknod -m 666 rootfs/dev/ptmx c 5 2
sudo chmod 777 rootfs/dev/*

cd ./rootfs/
mkdir -p proc sys  etc etc/init.d
mkdir home/root
cd ..

cp ./rootfs.gen/rcS ./rootfs/etc/init.d/
cp ./rootfs.gen/fstab ./rootfs/etc/
cp ./rootfs.gen/passwd ./rootfs/etc/
cp ./rootfs.gen/group ./rootfs/etc/

cd ./rootfs/
sudo chmod +x etc/init.d/rcS
sudo chgrp -R root ./*
sudo chown -R root ./*

find . | cpio -o --format=newc | gzip > ../rootfs.img.gz
