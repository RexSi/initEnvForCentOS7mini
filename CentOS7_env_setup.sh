#!/usr/bin/env bash

# env for CentOs 7 mini
# Please use root run it

# "inst.stage2=hd:LABEL=CentOS\x207\x20x86_64 rd.live.check" change to "repo=hd:/dev/sdb1:/"

if [[ `whoami` != "root" ]]; then
    echo "Please use root account run it."
    exit 1
fi

# setup network
ip_address=$(ip -o -4 addr | grep -v "127.0.0.*" | awk -F ' |/' '{print $7}')
if [ -z ${ip_address} ]; then

    Eth=$(ip addr | sed -n "/^2/p" | awk -F ' |:' '{print $3}')
    if [ -z ${Eth} ]; then
        echo "No found network devices, please check it."
        exit 1
    fi
    sed -in "/ONBOOT=no/s/no/yes/" "/etc/sysconfig/network-scripts/ifcfg-${Eth}"
    service network restart
    # check ip after wait 20s.
    sleep 20
fi

if [ -z ${ip_address} ]; then
    echo "Obtion ip failed. Please check network."
    exit 1
fi

# first yum update
yum -y update

# for install desktop environment

# install extr package for Enterprise linux
# yum -y groupinstall epel_release
# for manaual install epel_release
rpm -vih http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-7.noarch.rpm
yum clean all && yum makecache

# install X Window system
yum -y groupinstall "X Window system"

# install Xfce4
yum -y groupinstall xfce

# install screensaver xlockmore
yum -y install xscreensaver xlockmore

# launch Xfce
[ $? -eq 0 ] && systemctl isolate graphical.target
# start the GUI on boot
[ $? -eq 0 ] && systemctl set-default graphical.target

# set screen size
xrandr -s 1920x1200 -r 60

# install chinese font and china input method
# install cjkuni-ukai-fonts

# install vim
yum -y install vim

# install ctags
yum -y install ctags

# install cscope
yum -y install cscope

# install git
yum -y install git

# install expect
yum -y install expect

# install ftp
yum -y install ftp

# install python (rpm -ql yum | grep "sit-packages/yum$"  for "No module named yum")
yum -y groupinstall python

# install java   export JAVA_HOME=/usr/java/jdk1.8.0_92
curl -L -O http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-linux-x64.rpm
rpm -ivh jdk-8u92-linux-x64.rpm


# install python-devel
#yum -y install python-devel

#############################################################
# install python3
# yum -y install yum-utils
# yum-builddep python
# curl -O https://www.python.org/ftp/python/3.5.0/Python-3.5.0.tgz
# tar xf Python-3.5.0.tgz
# cd Python-3.5.0
# ./config
# make && make install
#############################################################
#############################################################
#
# refer: http://toomuchdata.com/2014/02/16/how-to-install-python-on-centos/
#
# install python2.7.12
# curl -L -O https://python.org/ftp/python/2.7.12/Python-2.7.12.tar.xz
# tar -xf Python-2.7.12.tar.xz
# cd Python-2.7.12.tar.xz
# ./configure --prefix=/usr/local --enable-shared --enable-unicode=ucs4 LDFLAGS="-Wl,-rpath /usr/local/lib"
# make && make altinstall
# mv /usr/bin/python2 /usr/bin/python2.bk
# ln -s /usr/local/bin/python2 /usr/bin/python2
# mv /usr/bin/python2-config /usr/bin/pyton2-config.bk
# ln -s /usr/local/bin/python2-config /usr/bin/python2-config
#
#############################################################

# install ssh-server
yum -y install ssh-server
#
sed -i "s/^PermitRootLogin yes/PermitRootLogin no/s" /etc/ssh/sshd_config

# install cmake
yum -y install cmake

# install gcc
yum -y install gcc

# install gcc-c++
yum -y install gcc-c++

# install docker
yum -y install docker

# install asciidoc for generate html doc
yum -y install asciidoc

# install xmlto
yum -y install xmlto

# install docbook2x-texi
yum -y --enablerepo="epel" install docbook2X
ln -s /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi

# install openssl-devel
yum -y install openssl-devel

# instal perl-devel
yum -y install perl-devel

# install squashfs
yum -y install squashfs-tools

# install vnc-server
yum -y install vnc-server

# for xstartup
####################################################
# #!/bin/sh
# # Uncomment the following two lines for normal desktop:
# unset SESSION_MANAGER
# #exec /etc/X11/xinit/xinitrc
# [ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
# [ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
# xsetroot -solid grey
# vncconfig -iconic &
# vncconfig -nowin &
# # xterm -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
# # twm &
# startxfce4 &
####################################################

# vi /usr/bin/yum
# vi /usr/libexec/urlgrabber-ext-down
# change  #!usr/bin/python

# install tftp server
yum -y install tftp-server

# config tftp server
# vi /etc/xinetd.d/tftp
# change disable = yes  --> disable = no
# server_args tftp root directory

# install NFS server
yum -y install nfs-utils nfs-utils-lib

# Created the share
mkdir -p /root/nfs
chmod 777 /root/nfs

# exported fine
# For basic options of exports
# Option  Description
# rw  Allow both read and write requests on a NFS volume.
# ro  Allow only read requests on a NFS volume.
# sync    Reply to requests only after the changes have been committed to stable storage. (Default)
# async   This option allows the NFS server to violate the NFS protocol and reply to requests before any changes made by that request have been committed to stable storage.
# secure  This option requires that requests originate on an Internet port less than IPPORT_RESERVED (1024). (Default)
# insecure    This option accepts all ports.
# wdelay  Delay committing a write request to disc slightly if it suspects that another related write request may be in progress or may arrive soon. (Default)
# no_wdelay   This option has no effect if async is also set. The NFS server will normally delay committing a write request to disc slightly if it suspects that another related write request may be in progress or may arrive soon. This allows multiple write requests to be committed to disc with the one operation which can improve performance. If an NFS server received mainly small unrelated requests, this behaviour could actually reduce performance, so no_wdelay is available to turn it off.
# subtree_check   This option enables subtree checking. (Default)
# no_subtree_check    This option disables subtree checking, which has mild security implications, but can improve reliability in some circumstances.
# root_squash Map requests from uid/gid 0 to the anonymous uid/gid. Note that this does not apply to any other uids or gids that might be equally sensitive, such as user bin or group staff.
# no_root_squash  Turn off root squashing. This option is mainly useful for disk-less clients.
# all_squash  Map all uids and gids to the anonymous user. Useful for NFS exported public FTP directories, news spool directories, etc.
# no_all_squash   Turn off all squashing. (Default)
# anonuid=UID These options explicitly set the uid and gid of the anonymous account. This option is primarily useful for PC/NFS clients, where you might want all requests appear to be from one user. As an example, consider the export entry for /home/joe in the example section below, which maps all requests to uid 150.
# anongid=GID Read above (anonuid=UID)

echo "/root/nfs clientip/24 (ro)" > /etc/exported

# Enable/start services
systemctl enable/start rpcbind
systemctl enable/start nfs-server
systemctl enable/start nfs-lock
systemctl enable/start nfs-idmap

firewall-cmd --add-service=nfs --permanen
firewall-cmd --reload
