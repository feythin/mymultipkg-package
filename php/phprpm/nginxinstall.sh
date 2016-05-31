#!/bin/bash
rpm -ivh pcre-8.38-1.x86_64.rpm 

if [ `getconf WORD_BIT` = '32' ] && [ `getconf LONG_BIT` = '64' ] ; then
    ln -s /usr/local/lib/libpcre.so.1 /lib64/
fi

rpm -ivh nginx-1.10.0-1.x86_64.rpm 

if [ ! -d "/usr/local/nginx/conf/vhosts" ]; then
    mkdir /usr/local/nginx/conf/vhosts
fi

