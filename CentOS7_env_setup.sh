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
