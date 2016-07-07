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

# install python
yum -y groupinstall python

############################################################
# install python3
# yum -y install yum-utils
# yum-builddep python
# curl -O https://www.python.org/ftp/python/3.5.0/Python-3.5.0.tgz
# tar xf Python-3.5.0.tgz
# cd Python-3.5.0
# ./config
# make && make install
#############################################################

# install ssh-server
yum -y install ssh-server

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
