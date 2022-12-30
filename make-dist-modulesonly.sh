#!/bin/bash

WORKDIR=`dirname $0`
cd $WORKDIR
WORKDIR=`pwd`

mkdir -p dist/plugins
( cd dist/plugins ; for i in ../../compile/library/repos/*/dist/*.vcvplugin ; do cp -r $i . ; done )
( cd dist/plugins ; for i in ../../compile/plugins/*/dist/*.vcvplugin ; do cp -r $i . ; done )

# this is for the dbRackCsound extra plugin: it brings its own libraries with
# it, but only for linux x86_64, so the idea is to install the system
# libraries instead and link against them to not having to build them by hand
# for that we bundle the shared csound lib used to compile the module in dist
cp -a compile/plugins/dbRackCsound/lib/linux/lib*.so* dist
