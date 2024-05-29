#! /usr/bin/env sh

FOLDER=linux

set -e

cd ..

if [ ! -f src/linux/Makefile ]; then
	git config --global --add safe.directory /lux-kernel
    	git submodule init
	git submodule update --depth=1
fi


cp -v src/config src/$FOLDER/.config

# Apply patches
PATCH_LIST=$(ls patches | grep .patch)
cd src/$FOLDER



# commit hash of v6.6.18: d8a27ea2c98685cdaa5fa66c809c7069a4ff394b
git reset --hard d8a27ea2c98685cdaa5fa66c809c7069a4ff394b
for patch in ${PATCH_LIST}; do
   check=$(git apply --check "../../patches/$patch")
   if [ -n ${check} ]; then
       echo "[\e[1;34m  OK \e[1;37m ] $patch"
       git am --quiet < "../../patches/$patch" 
    else
       echo "[\e[1;31m  ERROR \e[1;37m ] $patch not compatible"
       exit 1
    fi
done

#custom kernel name
sed  -i 's/^EXTRAVERSION.*/EXTRAVERSION = -lux/'  Makefile

#builds package

make bindeb-pkg -j"$(nproc)" DEBFULLNAME="Lux Dev Team" DEBEMAIL="lux@lenovo.com" LOCALVERSION=-"$(dpkg --print-architecture)" KDEB_PKGVERSION="$(make kernelversion)-1"
