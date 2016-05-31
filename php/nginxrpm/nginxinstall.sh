#!/bin/bash
rpm -ivh pcre-8.36-1.x86_64.rpm
rpm -ivh LuaJIT-2.0.3-1.x86_64.rpm

export LUAJIT_LIB=/usr/local/lib
export LUAJIT_INC=/usr/local/include/luajit-2.0
export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH

ln -s /usr/local/lib/libluajit-5.1.so.2 /lib64/libluajit-5.1.so.2
if [ `getconf WORD_BIT` = '32' ] && [ `getconf LONG_BIT` = '64' ] ; then
    ln -s /usr/local/lib/libpcre.so.1 /lib64/
fi

rpm -ivh nginx-1.7.10-1.x86_64.rpm 

if [ ! -d "/usr/local/nginx/conf/vhosts" ]; then
    mkdir /usr/local/nginx/conf/vhosts
fi

