#!/bin/bash
yum -y install yum-fastestmirror
yum -y update

######install base tools ##########
yum install -y curl lrzsz
yum install -y wget
yum install -y iputils net-tools telnet
##################################
echo 'PS1="\[\e[0;31m\][\u@\H \w]\\$ \[\e[m\]"' >> /etc/bashrc
echo 'export TERM=xterm ' >> /etc/profile
echo 'export LANG="en_US.UTF-8" ' >> /etc/profle
echo 'export LC_ALL="en_US.UTF-8"' >> /etc/profile

############ install php require lib ##############

yum -y install libxml2 libxml2-devel zlib-devel
yum -y install openssl openssl-devel
yum -y install curl curl-devel
yum -y install libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel
yum -y install openldap openldap-devel cyrus-sasl-devel
yum -y install bzip2 bzip2-devel
yum -y install libxslt libxslt-devel
yum -y install ImageMagick ImageMagick-devel
yum -y install net-snmp-devel
yum -y install readline-devel
yum -y install libmcrypt-devel mhash-devel gd-devel
yum -y install pcre-devel
# for memcached
yum -y install libevent libevent-devel
rpm -ivh autoconf-2.69-1.x86_64.rpm
rpm -ivh libiconv-1.14-2.x86_64.rpm
rpm -ivh mhash-0.9.9.9-2.x86_64.rpm
rpm -ivh libmcrypt-2.5.8-1.x86_64.rpm
rpm -ivh mcrypt-2.6.8-1.x86_64.rpm

if [ `getconf WORD_BIT` = '32' ] && [ `getconf LONG_BIT` = '64' ] ; then
    ln -s /usr/lib64/libpng.* /usr/lib/
    ln -s /usr/lib64/libjpeg.* /usr/lib/
    ln -sv /usr/lib64/libldap* /usr/lib/
fi

if [ ! `grep -l "/lib"    '/etc/ld.so.conf'` ]; then
    echo "/lib" >> /etc/ld.so.conf
fi

if [ ! `grep -l '/usr/lib'    '/etc/ld.so.conf'` ]; then
    echo "/usr/lib" >> /etc/ld.so.conf
fi

if [ -d "/usr/lib64" ] && [ ! `grep -l '/usr/lib64'    '/etc/ld.so.conf'` ]; then
    echo "/usr/lib64" >> /etc/ld.so.conf
fi

if [ ! `grep -l '/usr/local/lib'    '/etc/ld.so.conf'` ]; then
    echo "/usr/local/lib" >> /etc/ld.so.conf
fi

ldconfig

rpm -ivh php-5.6.21-1.x86_64.rpm 

rpm -ivh libmemcached-1.0.18-1.x86_64.rpm
rpm -ivh memcached-2.2.0-1.x86_64.rpm
rpm -ivh mongo-1.6.5-1.x86_64.rpm
rpm -ivh imagick-3.4.1-1.x86_64.rpm
rpm -ivh redis-2.2.7-1.x86_64.rpm
rpm -ivh icu-53.1-1.x86_64.rpm
rpm -ivh intl-3.0.0-1.x86_64.rpm 

phpexten=$(/usr/local/php/bin/php-config --extension-dir)
cat > $phpexten/ext-memcached.ini<<EOF
[memcached]
extension = "memcached.so"
EOF

cat > $phpexten/ext-imagick.ini<<EOF
[imagick]
extension = "imagick.so"
EOF

cat > $phpexten/ext-redis.ini<<EOF
[redis]
extension = "redis.so"
EOF

cat > $phpexten/ext-mongo.ini<<EOF
[mongodb]
extension = "mongo.so"
EOF

cat > $phpexten/ext-intl.ini<<EOF
[mongodb]
extension = "intl.so"
EOF


if [ ! -d "/usr/local/php/etc/conf.d" ]; then
    mkdir /usr/local/php/etc/conf.d
fi
if [ ! -d "/usr/local/php/var/run/" ]; then
    mkdir -p /usr/local/php/var/run/
fi

############install s6 #############
rpm -ivh skalibs-2.3.6.1-1.x86_64.rpm
rpm -ivh --fileconflicts execline-2.1.3.1-1.x86_64.rpm
rpm -ivh s6-2.2.0.1-1.x86_64.rpm 

mkdir -p /service/.s6-svscan
mkdir -p /service/php
cat << \EOF > /service/.s6-svscan/finish
#!/bin/bash
for file in /service/*/finish; do
   $file
done
for service in /service/* ; do
   s6-svwait -d $service
done
EOF
chmod +x  /service/.s6-svscan/finish
yum clean all
