#!/bin/sh
progdir=`dirname "$0"`/network

# uncomment following line and set static ip if dhcp isn't working
#ip addr add x.x.x.x/24 dev eth0

# Bring the link up or we won't do much
ip link set dev eth0 up

# We cannot symlink on FAT32, so copy busybox network build
# to root partition and symlink as udhcpc to allow usage
if [ ! -f /usr/sbin/busybox.network ]
then
  cp $progdir/busybox /usr/sbin/busybox.network
  ln -s /usr/sbin/busybox.network /usr/sbin/udhcpc
fi

if [ ! -f /usr/sbin/sftp-server ]
then
  cp $progdir/sftp-server /usr/libexec/sftp-server
fi

# Start dhcp
/usr/sbin/udhcpc -i eth0 &  

if [ ! -f $progdir/rg35xx.key ]
then 
	$progdir/dropbearkey -t rsa -f $progdir/rg35xx.key
fi

$progdir/dropbear -r $progdir/rg35xx.key -E -m &
