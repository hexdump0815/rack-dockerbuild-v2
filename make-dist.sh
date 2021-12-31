#!/bin/bash

WORKDIR=`dirname $0`
cd $WORKDIR
WORKDIR=`pwd`

MYARCH=`uname -m`
MYUNAME=`uname`

export ZIPNAME="lin"
if [ "$MYUNAME" = "Darwin" ]; then
  MYARCH="macos"
  export ZIPNAME="mac"
else
  MYOS=`uname -o`
  if [ "$MYOS" = "Msys" ]; then
    if [ "$MSYSTEM_CARCH" = "x86_64" ]; then
      MYARCH="win64"
      export ZIPNAME="win"
    else
      MYARCH="win32"
      export ZIPNAME="win"
    fi
  fi
fi

mkdir -p dist/plugins
for i in CHANGELOG.md LICENSE-dist.md LICENSE-GPLv3.txt LICENSE.md res template.vcv Core.json; do  cp -r compile/Rack/$i dist; done
cp compile/Rack/Rack dist
cp compile/Rack/libRack.so dist
( cd dist/plugins ; for i in ../../compile/library/repos/*/dist/* ; do cp -r $i . ; done )
( cd dist/plugins ; for i in ../../compile/plugins/*/dist/* ; do cp -r $i . ; done )

mkdir -p dist/rack-sdk/dep
for i in *.mk helper.py include LICENSE-dist.md LICENSE-GPLv3.txt LICENSE.md; do
  cp -r compile/Rack/$i dist/rack-sdk
done

cp -r compile/Rack/dep/include dist/rack-sdk/dep

cp simde-ify.sh dist/rack-sdk
