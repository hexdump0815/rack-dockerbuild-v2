#!/bin/bash

# exit on errors
set -e

WORKDIR=`dirname $0`
cd $WORKDIR

MYARCH=`uname -m`
MYUNAME=`uname`

if [ "$MYUNAME" = "Darwin" ]; then
  MYARCH="macos"
else
  MYOS=`uname -o`
  if [ "$MYOS" = "Msys" ]; then
    if [ "$MSYSTEM_CARCH" = "x86_64" ]; then
      MYARCH="win64"
    else
      MYARCH="win32"
    fi
  fi
fi

mkdir -p compile
cd compile

# if we have a source archive in the source dir use that ...
if [ -f ../source/Rack-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd .. ; tar xzf source/Rack-source.tar.gz )
  cd Rack
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/VCVRack/Rack.git
  cd Rack
  git checkout v2.4.1
  git submodule update --init --recursive
  # create a backup copy of the unpatched sources if needed to build elsewhere later from them
  ( cd ../.. ; mkdir -p source ; tar czf source/Rack-source.tar.gz compile/Rack )
fi
# arch independent patches
if [ -f ../../patches/Rack.patch ]; then
  patch -p1 < ../../patches/Rack.patch
fi
# arch specific patches
if [ -f ../../patches/Rack.$MYARCH.patch ]; then
  patch -p1 < ../../patches/Rack.$MYARCH.patch
fi
cd ..
cp ../build.sh-proto build.sh
