#!/bin/bash

cwdir=`pwd`
rootdir=`dirname $0`
cd "$rootdir"
rootdir=`pwd`
target=linux_x86_32
prefix=$rootdir/$target
version=`cat $rootdir/version.txt`
rm -rf "$rootdir/$version"
mkdir "$rootdir/$version"
cp -rf "$rootdir/../$version/"* "$rootdir/$version"
rm -rf "$rootdir/project"
mkdir "$rootdir/project"
cd "$rootdir/project"
cmake -DBUILD64=OFF -C "$rootdir/CMakeLists.txt" -DPNG_SHARED=OFF -DPNG_TESTS=OFF -DSKIP_INSTALL_FILES=ON -DSKIP_INSTALL_EXPORT=ON -DZLIB_INCLUDE_DIR="$rootdir/../zlib/include/$target" -DZLIB_LIBRARY="$rootdir/../zlib/lib/$target/libz.a" -DM_LIBRARY="${M_LIBRARY};/usr/lib32" -DCMAKE_INSTALL_PREFIX="$prefix" "$rootdir/$version"
cmake "$rootdir/$version"
cmake --build . --target install --config Release --clean-first
rm -rf "$prefix/include/libpng16"
mkdir "$rootdir/../target/include/$target"
cp -rf "$prefix/include/"* "$rootdir/../target/include/$target"
mkdir "$rootdir/../target/lib/$target"
cp -rf "$prefix/lib/"* "$rootdir/../target/lib/$target"
cd "$cwdir"
rm -rf "$rootdir/$version"
rm -rf "$rootdir/project"
rm -rf "$prefix"
