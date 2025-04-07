#!/bin/bash

WORKDIR=`dirname $0`
cd $WORKDIR
WORKDIR=`pwd`

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
cp -ri compile/Rack/translations dist

cp simde-ify.sh dist/rack-sdk
