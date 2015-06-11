# mymultipkg-package

some multipkg package of mine

## install common compile tools
```
yum groupinstall -y "Development Tools"
```
## install openssl-devel support
```
yum install -y openssl-devel
```
## change the lang for some build date issue
```
$ LANG=C
$ cd python2 && multipkg -v .
```

