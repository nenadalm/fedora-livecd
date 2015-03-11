#!/usr/bin/env bash

set -e

MAJOR=$(cut -d '.' -f1 <<<$1)
MINOR=$(cut -d '.' -f2 <<<$1)

INSTALLATION_DIR="$(readlink -f $(dirname $0))/.."
EXTENSIONS_DIR=extensions-$1
PHPIZE_LOCATION="${INSTALLATION_DIR}/inst/bin/phpize-${1}"
PHPCONFIG_LOCATION="${INSTALLATION_DIR}/inst/bin/php-config-${1}"

function install_extension {
    cd $1
    $PHPIZE_LOCATION
    ./configure --with-php-config=${PHPCONFIG_LOCATION}
    make clean
    make
    make install
    cd ../
}

cp "${INSTALLATION_DIR}/inst/php-${1}/etc/php.ini" "${INSTALLATION_DIR}/inst/php-${1}/lib/"
mkdir -p $EXTENSIONS_DIR
cd $EXTENSIONS_DIR

${INSTALLATION_DIR}/inst/php-${1}/bin/pecl install amqp

if [[ ${MAJOR} -le 5 && ${MINOR} -le 4 ]]; then
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

cp "${INSTALLATION_DIR}/inst/php-${1}/bin/php-cgi" /srv/cgi-bin/php-cgi-${1}

