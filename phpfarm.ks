%packages
make
wget
gcc
mod_fcgid
tar
bzip2
autoconf
libxml2-devel
libcurl-devel
postgresql-devel
openssl-devel
libssh2-devel
openldap-devel
turbojpeg-devel
libjpeg-turbo-devel
libpng-devel
libicu-devel
libmcrypt-devel
ImageMagick-devel
librabbitmq-devel
gcc-c++
%end
 
%post --erroronfail
git clone --depth=1 https://github.com/fpoirotte/phpfarm.git /opt/phpfarm
mkdir -p /opt/phpfarm/custom
%end

%post --erroronfail
touch /opt/phpfarm/custom/options.sh
cat > /opt/phpfarm/custom/options.sh <<EOF
#!/usr/bin/env bash

configoptions="
--enable-exif
--with-zlib 
--enable-soap 
--with-mcrypt 
--enable-sockets 
--with-curl 
--enable-intl 
--with-openssl 
--with-pdo-mysql
--with-pdo-pgsql 
--with-pgsql 
--enable-mbstring 
--with-mysql 
--with-libdir=lib64 
--with-mysqli 
--with-jpeg-dir=/usr 
--with-gd
--enable-gd-native-ttf
--with-freetype-dir
--enable-zip 
--enable-bcmath 
--enable-calendar 
--with-gettext 
--with-ldap 
--enable-sysvmsg 
--enable-sysvsem 
--enable-sysvshm 
--enable-pcntl
"
EOF


touch /opt/phpfarm/custom/php.ini
cat > /opt/phpfarm/custom/php.ini <<EOF
date.timezone=Europe/Prague
include_path=".:\$install_dir/pear/php/"

memory_limit=3G
xdebug.max_nesting_level = 500
short_open_tag = On

extension=ssh2.so
extension=xhprof.so
extension=redis.so
extension=imagick.so
extension=spl_types.so
extension=amqp.so

zend_extension=\$ext_dir/xdebug.so
xdebug.remote_enable=On;
xdebug.remote_handler="dbgp";
xdebug.idekey=netbeans-xdebug
xdebug.default_enable=0

upload_max_filesize = 1G
post_max_size = 1G
EOF

cat > /opt/phpfarm/custom/php-5.4.ini <<EOF
extension=apc.so
EOF


touch /opt/phpfarm/custom/post-install.sh
cat > /opt/phpfarm/custom/post-install.sh <<EOF
#!/usr/bin/env bash

set -e

MAJOR=\$(cut -d '.' -f1 <<<\$1)
MINOR=\$(cut -d '.' -f2 <<<\$1)

INSTALLATION_DIR="\$(readlink -f \$(dirname \$0))/.."
EXTENSIONS_DIR=extensions-\$1
PHPIZE_LOCATION="\${INSTALLATION_DIR}/inst/bin/phpize-\${1}"
PHPCONFIG_LOCATION="\${INSTALLATION_DIR}/inst/bin/php-config-\${1}"

function install_extension {
    cd \$1
    \$PHPIZE_LOCATION
    ./configure --with-php-config=\${PHPCONFIG_LOCATION}
    make clean
    make
    make install
    cd ../
}

cp "\${INSTALLATION_DIR}/inst/php-\${1}/etc/php.ini" "\${INSTALLATION_DIR}/inst/php-\${1}/lib/"
mkdir -p \$EXTENSIONS_DIR
cd \$EXTENSIONS_DIR

\${INSTALLATION_DIR}/inst/php-\${1}/bin/pecl install amqp

if [[ \${MAJOR} -le 5 && \${MINOR} -le 4 ]]; then
    if [[ ! -d './APC-3.1.13' ]]; then
        wget http://pecl.php.net/get/APC-3.1.13.tgz
        tar -xf ./APC-3.1.13.tgz
    fi
    install_extension APC-3.1.13
fi

if [[ ! -d './SPL_Types-0.4.0' ]]; then
    wget http://pecl.php.net/get/SPL_Types-0.4.0.tgz
    tar -xf ./SPL_Types-0.4.0.tgz
fi
install_extension SPL_Types-0.4.0

if [[ ! -d './xhprof-0.9.4' ]]; then
    wget http://pecl.php.net/get/xhprof-0.9.4.tgz
    tar -xf ./xhprof-0.9.4.tgz
    cp -R ./xhprof-0.9.4/extension/* ./xhprof-0.9.4
fi
install_extension xhprof-0.9.4

if [[ ! -d './xdebug-2.2.4' ]]; then
    wget http://pecl.php.net/get/xdebug-2.2.4.tgz
    tar -xf ./xdebug-2.2.4.tgz
fi
install_extension xdebug-2.2.4

if [[ ! -d "./phpredis" ]]; then
    git clone https://github.com/nicolasff/phpredis.git phpredis
fi
install_extension phpredis

if [[ ! -d './ssh2-0.12' ]]; then
    wget http://pecl.php.net/get/ssh2-0.12.tgz
    tar -xf ./ssh2-0.12.tgz
fi
install_extension ssh2-0.12

if [[ ! -d "./MagickWandForPHP-1.0.9-2" ]]; then
    wget http://www.magickwand.org/download/php/MagickWandForPHP-1.0.9-2.tar.gz
    tar -xf ./MagickWandForPHP-1.0.9-2.tar.gz
fi
install_extension MagickWandForPHP-1.0.9

if [[ ! -d "./imagick-3.1.2" ]]; then
    wget http://pecl.php.net/get/imagick-3.1.2.tgz
    tar -xf ./imagick-3.1.2.tgz
fi
install_extension imagick-3.1.2

cp "\${INSTALLATION_DIR}/inst/php-\${1}/bin/php-cgi" /var/www/cgi-bin/php-cgi-\${1}
EOF
%end

%post --erroronfail
cd /opt/phpfarm
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/opt/phpfarm/inst/current/bin:/opt/phpfarm/inst/bin ./src/main.sh 5.6.4-pear
./inst/bin/switch-phpfarm 5.6.4

cat > /etc/profile.d/path.sh <<EOF
export PATH=\$PATH:/opt/phpfarm/inst/current/bin

EOF
%end

