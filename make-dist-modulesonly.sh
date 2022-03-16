#!/bin/bash

WORKDIR=`dirname $0`
cd $WORKDIR
WORKDIR=`pwd`

mkdir -p dist/plugins
( cd dist/plugins ; for i in ../../compile/library/repos/*/dist/*.vcvplugin ; do cp -r $i . ; done )
( cd dist/plugins ; for i in ../../compile/plugins/*/dist/*.vcvplugin ; do cp -r $i . ; done )
