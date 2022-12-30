#!/bin/bash

WORKDIR=`dirname $0`
cd $WORKDIR
WORKDIR=`pwd`

MYARCH=`uname -m`

mkdir -p dist
for i in CHANGELOG.md LICENSE-dist.md LICENSE-GPLv3.txt LICENSE.md res template.vcv Core.json; do  cp -r compile/Rack/$i dist; done
cp compile/Rack/Rack dist
cp compile/Rack/libRack.so dist

mkdir -p dist/plugins
( cd dist/plugins ; for i in ../../compile/library/repos/*/dist/*.vcvplugin ; do cp -ri $i . ; done )
( cd dist/plugins ; for i in ../../compile/plugins/*/dist/*.vcvplugin ; do cp -ri $i . ; done )

# mkdir -p dist/plugins-beta
# ( cd dist/plugins-beta ; for i in ../../compile/plugins/*-beta/dist/*.vcvplugin ; do cp -ri $i . ; done )

mkdir -p dist/rack-sdk/dep
for i in *.mk helper.py include LICENSE-dist.md LICENSE-GPLv3.txt LICENSE.md; do
  cp -ri compile/Rack/$i dist/rack-sdk
done

cp -ri compile/Rack/dep/include dist/rack-sdk/dep

cp simde-ify.sh dist/rack-sdk

# this is for the dbRackCsound extra plugin: it brings its own libraries with
# it, but only for linux x86_64, so the idea is to install the system
# libraries instead and link against them to not having to build them by hand
# for that we bundle the shared csound lib used to compile the module in dist
cp -a compile/plugins/dbRackCsound/lib/linux/lib*.so* dist
