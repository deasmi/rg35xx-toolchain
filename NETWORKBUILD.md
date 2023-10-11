These notes are how to build networking tools for the rg35xx.
-------------------------------------------------------------

This assumes you have a working usb ethernet connected, to check run simple term and type
# ip addr
If you see an eth0 then you are good, if you don't then you are not.
*Plug in the ethernet port after boot*

This will provide
. dhcp - busybox dhcpc
. dropbear - ssh server
. sftp-server - sftp-command from openssh


Prep

```
mkdir -p install/network
cp network.sh install

apt update
apt install ncurses-dev
apt install bzip2
``


*dropbear*
./configure --host=arm-miyoo-linux-uclibcgnueabi
make
cp dropbear dropbearconvert dropbearkey  ../install/network

*dhcpc*
copy config.networking into busybox dir
```
make ARCH=arm CROSS_COMPILE=/opt/miyoo/bin/arm-miyoo-linux-uclibcgnueabi- defconfig
make menuconfig
```
load config.networking custom config
( this disables everything except networking )
( + enable USE_ASH_GLOBS under shells ) 
exit and save config
```
make ARCH=arm CROSS_COMPILE=/opt/miyoo/bin/arm-miyoo-linux-uclibcgnueabi-
make install
```
in _install you want bin/busybox, copy to install dir
```
cp _install/bin/busybox ../install/network
```


*sftp-server*
Unpack openssh ( not the BSD version )
```
./configure --host=arm-miyoo-linux-uclibcgnueabi --without-openssl
make sftp-server
cp sftp-server ../install/network
```
