#!/bin/bash
set -ex
thisdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

rootbuilddir=$1
if [ "x$rootbuilddir" = "x" ];then
    echo "Usage: $0 <root_build_directory>"
    exit 1
fi
builddir=$rootbuilddir/toolkit

rm -rf $builddir

mkdir -p $builddir/source/megacmdpkg
git clone --recursive https://github.com/meganz/MEGAcmd.git $builddir/source/megacmdpkg/MEGAcmd

cp -r $builddir/source/megacmdpkg/MEGAcmd/build/SynologyNAS/toolkit/* $builddir/

git clone https://github.com/SynologyOpenSource/pkgscripts-ng $builddir/pkgscripts-ng

cd $builddir

ln -s $rootbuilddir/toolkit_tarballs toolkit_tarballs

./build_all_synology_packages || true

resultdir=synology_build_results

rm -f $thisdir/result
touch $thisdir/result
echo `ls -1 $resultdir/*.failed` >> $thisdir/result
echo `ls -1 $resultdir/*.built` >> $thisdir/result

rm -rf $thisdir/images
mkdir $thisdir/images
cp -r $resultdir/image-* $thisdir/images
