#!/bin/sh

# yum search java
yum -y install java-1.8.0-openjdk
yum -y install java-1.8.0-openjdk-javadoc
yum -y install java-1.8.0-openjdk-devel
yum -y install java-1.8.0-openjdk-debug
yum -y install java-1.8.0-openjdk-demo
yum -y install java-1.8.0-openjdk-src

# yum web-start
yum -y install icedtea-web icedtea-web-javadoc

# locate command
yum -y install mlocate
updatedb
locate /bin/java

# install libs

#  if missing, crt1.o format wrong
#  /usr/lib64/crt* for crt1.o crti.o crtn.o
yum -y install glibc-devel.i686 glibc-devel.x86_64 gmp-devel

# yum list \*ncurses\*
yum -y install ncurses.x86_64 ncurses-libs.x86_64 ncurses-devel.x86_64


exit



# the following is for ATLAS

yum -y install vim

# rpmcompSL6
yum -y install libuuid-devel  
yum -y install  glibc.i686 glibc-devel.i686 openssl098e.i686 freetype.i686 \
libxml2.i686 libxml2-devel.i686  libaio.i686 compat-libtermcap.i686 ncurses-devel.i686 \
castor-devel.i686 castor-devel.x86_64 castor-lib.i686 castor-lib.x86_64 libstdc++.i686  \
freetype-devel.i686 libpng-devel.i686 compat-readline5.i686 mesa-libGL-devel.i686 \
mesa-libGL.i686 mesa-libGLU-devel.i686 mesa-libGLU.i686 libXext-devel.i686 \
compat-db43.i686 compat-expat1.i686 compat-expat1.x86_64  compat-openldap.i686 \
compat-openldap.x86_64 libXpm.i686 libXext.i686 libXft.i686 pam.i686 automake.noarch \
autoconf.noarch libtool.x86_64 libuuid-devel.i686 zlib.i686 zlib-devel.i686 zlib-devel.x86_64  

yum -y install openssl098e compat-libf2c-34

# https://twiki.cern.ch/twiki/bin/view/Atlas/RCEGen3PixelApplication
yum -y install cmake  libXpm libX11 libXext libSM libICE
yum -y install libXft 
# for X11 forward
yum -y install xterm.x86_64 xorg-x11-xauth.x86_64
# root pre-requeirements  https://twiki.cern.ch/twiki/bin/view/Main/MilanoTutorialHelp2015
yum -y install gcc-c++ libX11-devel libX11-xpm libXpm-devel libXft-devel libXext-devel
# geant4 http://natsci.kyokyo-u.ac.jp/~takasima/pukiwikiNew/index.php?%B8%A6%B5%E6%BC%BC2014
yum -y install libX11-devel.x86_64
yum -y install libXpm-devel libXft-devel libXext-devel openssl-devel subversion pcre-devel \
mesa-libGL-devel glew-devel ftgl-devel cfitsio-devel
yum -y install graphviz-devel avahi-compat-libdns_sd-devel
yum -y install python-devel libxml2-devel libjpeg-devel libpng-devel libGLU-devel  memcached-devel python-memcached
yum -y install gsl-static
yum -y install gcc-c++.x86_64 gcc-gfortran.x86_64


