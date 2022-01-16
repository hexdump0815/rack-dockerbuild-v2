#!/bin/bash

# exit on errors
#set -e

WORKDIR=`dirname $0`
cd $WORKDIR
# make it an absolute path
WORKDIR=`pwd`

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

cd compile
cp ../build-modules.sh-proto build-modules.sh

# if we have a source archive in the source dir use that ...
if [ -f ../source/library-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd .. ; tar xzf source/library-source.tar.gz )
  cd library
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/VCVRack/library.git
  cd library
  git checkout v2
  # this is the version i used this script last with
  #git checkout xyz

  # looks like the the-xor plugin is no longer available via github
  cd repos
  git submodule deinit -f -- TheXOR
  git rm -f TheXOR
  cd ..

  # and the rjmodules repo seems to make trouble as well, so get rid of it too
  cd repos
  git submodule deinit -f -- RJModules
  git rm -f RJModules
  cd ..

  git submodule update --init --recursive
  ( cd ../.. ; mkdir -p source ; tar czf source/library-source.tar.gz compile/library )
fi

cd repos

# arch specific patching if needed

for i in * ; do
  # SurgeRack is handled separately below
  if [ "$i" != "SurgeRack" ]; then
    if [ -f ${i}/plugin.json ]; then
      # we only want v2 plugins
      grep -q '"version": "2' ${i}/plugin.json
      if [ "$?" = "0" ]; then
        echo ""
        echo "===> $i"
        echo ""
        cd $i
        # arch independent patches
        if [ -f ../../../../patches/${i}.patch ]; then
          patch -p1 < ../../../../patches/${i}.patch
        fi
        # arch specific patches
        if [ -f ../../../../patches/${i}.$MYARCH.patch ]; then
          patch -p1 < ../../../../patches/${i}.$MYARCH.patch
        fi
        cd ..
      fi
    fi
  fi
done

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# some special handling:

# AudibleInstruments
echo ""
echo "===> AudibleInstruments extra steps"
echo ""
cd AudibleInstruments
find * -type f -exec ../../../../simde-ify.sh {} \;
# this file gets accidently simde-ified :)
git checkout -- design/Warps.ai
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# # Bark
# echo ""
# echo "===> Bark extra steps"
# echo ""
# cd Bark
# find * -type f -exec ../../../../simde-ify.sh {} \;
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# squinkylabs-plug1
echo ""
echo "===> squinkylabs-plug1 extra steps"
echo ""
cd squinkylabs-plug1
find * -type f -exec ../../../../simde-ify.sh {} \;
# this file gets accidently simde-ified :)
git checkout -- gfx/Cheby.ai
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# # Valley
# echo ""
# echo "===> Valley extra steps"
# echo ""
# cd Valley
# find * -type f -exec ../../../../simde-ify.sh {} \;
# # this file gets accidently simde-ified :)
# #git checkout -- TopographImg.png
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# ML_modules
echo ""
echo "===> ML_modules extra steps"
echo ""
cd ML_modules
find * -type f -exec ../../../../simde-ify.sh {} \;
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# SubmarineFree
echo ""
echo "===> SubmarineFree extra steps"
echo ""
cd SubmarineFree
find * -type f -exec ../../../../simde-ify.sh {} \;
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# Comfortzone
echo ""
echo "===> Comfortzone extra steps"
echo ""
cd Comfortzone
find * -type f -exec ../../../../simde-ify.sh {} \;
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# # HetrickCV
# echo ""
# echo "===> HetrickCV extra steps"
# echo ""
# cd HetrickCV
# # https://github.com/VCVRack/Rack/issues/1583 is fixed on master
# git checkout master
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# # BaconMusic
# echo ""
# echo "===> BaconMusic extra steps"
# echo ""
# cd BaconMusic
# # https://github.com/VCVRack/Rack/issues/1583 is fixed on master
# git checkout main
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# some extra plugins

cd ${WORKDIR}
mkdir -p compile/plugins
cd compile/plugins

# Fundamental
echo ""
echo "===> Fundamental extra plugin"
echo ""
# if we have a source archive in the source dir use that ...
if [ -f ../../source/Fundamental-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd ../.. ; tar xzf source/Fundamental-source.tar.gz )
  cd Fundamental
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/VCVRack/Fundamental.git
  cd Fundamental
  git checkout v2
  git submodule update --init --recursive
  ( cd ../../.. ; mkdir -p source ; tar czf source/Fundamental-source.tar.gz compile/plugins/Fundamental )
fi
if [ -f ../../../patches/Fundamental.patch ]; then
  patch -p1 < ../../../patches/Fundamental.patch
fi
if [ -f ../../../patches/Fundamental.$MYARCH.patch ]; then
  patch -p1 < ../../../patches/Fundamental.$MYARCH.patch
fi
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# VCV-Recorder
echo ""
echo "===> VCV-Recorder extra plugin"
echo ""
# if we have a source archive in the source dir use that ...
if [ -f ../../source/VCV-Recorder-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd ../.. ; tar xzf source/VCV-Recorder-source.tar.gz )
  cd VCV-Recorder
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/VCVRack/VCV-Recorder
  cd VCV-Recorder
  git checkout v2
  git submodule update --init --recursive
  ( cd ../../.. ; mkdir -p source ; tar czf source/VCV-Recorder-source.tar.gz compile/plugins/VCV-Recorder )
fi
if [ -f ../../../patches/VCV-Recorder.patch ]; then
  patch -p1 < ../../../patches/VCV-Recorder.patch
fi
if [ -f ../../../patches/VCV-Recorder.$MYARCH.patch ]; then
  patch -p1 < ../../../patches/VCV-Recorder.$MYARCH.patch
fi
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# ValleyRackFree
echo ""
echo "===> ValleyRackFree extra plugin"
echo ""
# if we have a source archive in the source dir use that ...
if [ -f ../../source/ValleyRackFree-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd ../.. ; tar xzf source/ValleyRackFree-source.tar.gz )
  cd ValleyRackFree
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/ValleyAudio/ValleyRackFree.git
  cd ValleyRackFree
  git checkout v2.0
  git submodule update --init --recursive
  ( cd ../../.. ; mkdir -p source ; tar czf source/ValleyRackFree-source.tar.gz compile/plugins/ValleyRackFree )
fi
if [ -f ../../../patches/ValleyRackFree.patch ]; then
  patch -p1 < ../../../patches/ValleyRackFree.patch
fi
if [ -f ../../../patches/ValleyRackFree.$MYARCH.patch ]; then
  patch -p1 < ../../../patches/ValleyRackFree.$MYARCH.patch
fi
find * -type f -exec ../../../simde-ify.sh {} \;
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# vcvrack-packone
echo ""
echo "===> vcvrack-packone extra plugin"
echo ""
# if we have a source archive in the source dir use that ...
if [ -f ../../source/vcvrack-packone-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd ../.. ; tar xzf source/vcvrack-packone-source.tar.gz )
  cd vcvrack-packone
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/stoermelder/vcvrack-packone
  cd vcvrack-packone
  git checkout v2-dev
  git submodule update --init --recursive
  ( cd ../../.. ; mkdir -p source ; tar czf source/vcvrack-packone-source.tar.gz compile/plugins/vcvrack-packone )
fi
if [ -f ../../../patches/vcvrack-packone.patch ]; then
  patch -p1 < ../../../patches/vcvrack-packone.patch
fi
if [ -f ../../../patches/vcvrack-packone.$MYARCH.patch ]; then
  patch -p1 < ../../../patches/vcvrack-packone.$MYARCH.patch
fi
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # VCV-Prototype
# echo ""
# echo "===> VCV-Prototype extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/VCV-Prototype-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/VCV-Prototype-source.tar.gz )
#   cd VCV-Prototype
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/VCVRack/VCV-Prototype
#   cd VCV-Prototype
#   git checkout b5efc01fdce16a34324d53334c82a9dedebe3200
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/VCV-Prototype-source.tar.gz compile/plugins/VCV-Prototype )
# fi
# if [ -f ../../../patches/VCV-Prototype.patch ]; then
#   patch -p1 < ../../../patches/VCV-Prototype.patch
# fi
# if [ -f ../../../patches/VCV-Prototype.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/VCV-Prototype.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # vcv-link
# echo ""
# echo "===> vcv-link extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/vcv-link-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/vcv-link-source.tar.gz )
#   cd vcv-link
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/stellare-modular/vcv-link
#   cd vcv-link
#   git checkout feature/v2
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/vcv-link-source.tar.gz compile/plugins/vcv-link )
# fi
# if [ -f ../../../patches/vcv-link.patch ]; then
#   patch -p1 < ../../../patches/vcv-link.patch
# fi
# if [ -f ../../../patches/vcv-link.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/vcv-link.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # vcvrack-packgamma
# echo ""
# echo "===> vcvrack-packgamma extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/vcvrack-packgamma-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/vcvrack-packgamma-source.tar.gz )
#   cd vcvrack-packgamma
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/stoermelder/vcvrack-packgamma.git
#   cd vcvrack-packgamma
#   git checkout v1
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/vcvrack-packgamma-source.tar.gz compile/plugins/vcvrack-packgamma )
# fi
# if [ -f ../../../patches/vcvrack-packgamma.patch ]; then
#   patch -p1 < ../../../patches/vcvrack-packgamma.patch
# fi
# if [ -f ../../../patches/vcvrack-packgamma.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/vcvrack-packgamma.$MYARCH.patch
# fi
# cd dep/Gamma
# if [ -f ../../../../../patches/vcvrack-packgamma-dep-Gamma.$MYARCH.patch ]; then
#   patch -p1 < ../../../../../patches/vcvrack-packgamma-dep-Gamma.$MYARCH.patch
# fi
# cd ../..
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # vcvrack-packtau
# echo ""
# echo "===> vcvrack-packtau extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/vcvrack-packtau-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/vcvrack-packtau-source.tar.gz )
#   cd vcvrack-packtau
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/stoermelder/vcvrack-packtau.git
#   cd vcvrack-packtau
#   git checkout v1
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/vcvrack-packtau-source.tar.gz compile/plugins/vcvrack-packtau )
# fi
# if [ -f ../../../patches/vcvrack-packtau.patch ]; then
#   patch -p1 < ../../../patches/vcvrack-packtau.patch
# fi
# if [ -f ../../../patches/vcvrack-packtau.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/vcvrack-packtau.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins
 
# # surge-rack
# echo ""
# echo "===> surge-rack extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/surge-rack-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/surge-rack-source.tar.gz )
#   cd surge-rack
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/surge-synthesizer/surge-rack
#   cd surge-rack
#   git checkout release/1.7.1.2
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/surge-rack-source.tar.gz compile/plugins/surge-rack )
# fi
# if [ -f ../../../patches/surge-rack.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/surge-rack.$MYARCH.patch
# fi
# # special patching for surge-rack in the surge subdir
# cd surge
# if [ -f ../../../../patches/surge-rack-surge.$MYARCH.patch ]; then
#   patch -p1 < ../../../../patches/surge-rack-surge.$MYARCH.patch
# fi
# cd ..
# # this seems to no longer be required with 1.7.1
# # find * -type f -exec ../../../simde-ify.sh {} \;
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # 4rack
# echo ""
# echo "===> 4rack extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/4rack-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/4rack-source.tar.gz )
#   cd 4rack
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/Moaneschien/4rack
#   cd 4rack
#   git checkout master
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/4rack-source.tar.gz compile/plugins/4rack )
# fi
# if [ -f ../../../patches/4rack.patch ]; then
#   patch -p1 < ../../../patches/4rack.patch
# fi
# if [ -f ../../../patches/4rack.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/4rack.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # CAOplugs
# echo ""
# echo "===> CAOplugs extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/CAOplugs-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/CAOplugs-source.tar.gz )
#   cd CAOplugs
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/caoliver/CAOplugs.git
#   cd CAOplugs
#   git checkout master
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/CAOplugs-source.tar.gz compile/plugins/CAOplugs )
# fi
# if [ -f ../../../patches/CAOplugs.patch ]; then
#   patch -p1 < ../../../patches/CAOplugs.patch
# fi
# if [ -f ../../../patches/CAOplugs.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/CAOplugs.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # Demo
# echo ""
# echo "===> Demo extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/Demo-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/Demo-source.tar.gz )
#   cd Demo
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/squinkylabs/Demo.git
#   cd Demo
#   git checkout main
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/Demo-source.tar.gz compile/plugins/Demo )
# fi
# if [ -f ../../../patches/Demo.patch ]; then
#   patch -p1 < ../../../patches/Demo.patch
# fi
# if [ -f ../../../patches/Demo.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/Demo.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # FM-Delexander
# echo ""
# echo "===> FM-Delexander extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/FM-Delexander-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/FM-Delexander-source.tar.gz )
#   cd FM-Delexander
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/anlexmatos/FM-Delexander
#   cd FM-Delexander
#   git checkout beta-3
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/FM-Delexander-source.tar.gz compile/plugins/FM-Delexander )
# fi
# if [ -f ../../../patches/FM-Delexander.patch ]; then
#   patch -p1 < ../../../patches/FM-Delexander.patch
# fi
# if [ -f ../../../patches/FM-Delexander.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/FM-Delexander.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # LocoVCVModules
# echo ""
# echo "===> LocoVCVModules extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/LocoVCVModules-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/LocoVCVModules-source.tar.gz )
#   cd LocoVCVModules
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/perky/LocoVCVModules.git
#   cd LocoVCVModules
#   git checkout master
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/LocoVCVModules-source.tar.gz compile/plugins/LocoVCVModules )
# fi
# if [ -f ../../../patches/LocoVCVModules.patch ]; then
#   patch -p1 < ../../../patches/LocoVCVModules.patch
# fi
# if [ -f ../../../patches/LocoVCVModules.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/LocoVCVModules.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # MIDI-Delexander
# echo ""
# echo "===> MIDI-Delexander extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/MIDI-Delexander-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/MIDI-Delexander-source.tar.gz )
#   cd MIDI-Delexander
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/anlexmatos/MIDI-Delexander.git
#   cd MIDI-Delexander
#   git checkout master
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/MIDI-Delexander-source.tar.gz compile/plugins/MIDI-Delexander )
# fi
# if [ -f ../../../patches/MIDI-Delexander.patch ]; then
#   patch -p1 < ../../../patches/MIDI-Delexander.patch
# fi
# if [ -f ../../../patches/MIDI-Delexander.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/MIDI-Delexander.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # RackdeLirios
# echo ""
# echo "===> RackdeLirios extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/RackdeLirios-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/RackdeLirios-source.tar.gz )
#   cd RackdeLirios
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/xnamahx/RackdeLirios.git
#   cd RackdeLirios
# #  git checkout master
#   git checkout 6dfa31e5777be838f34e4ac6d01e0cab1f675b0e
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/RackdeLirios-source.tar.gz compile/plugins/RackdeLirios )
# fi
# if [ -f ../../../patches/RackdeLirios.patch ]; then
#   patch -p1 < ../../../patches/RackdeLirios.patch
# fi
# if [ -f ../../../patches/RackdeLirios.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/RackdeLirios.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # VCVRack_modules
# echo ""
# echo "===> VCVRack_modules extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/VCVRack_modules-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/VCVRack_modules-source.tar.gz )
#   cd VCVRack_modules
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/gweltou/VCVRack_modules.git
#   cd VCVRack_modules
#   git checkout master
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/VCVRack_modules-source.tar.gz compile/plugins/VCVRack_modules )
# fi
# if [ -f ../../../patches/VCVRack_modules.patch ]; then
#   patch -p1 < ../../../patches/VCVRack_modules.patch
# fi
# if [ -f ../../../patches/VCVRack_modules.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/VCVRack_modules.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # VCV-Plugins
# echo ""
# echo "===> VCV-Plugins extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/VCV-Plugins-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/VCV-Plugins-source.tar.gz )
#   cd VCV-Plugins
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/jdstmporter/VCV-Plugins.git
#   cd VCV-Plugins
#   git checkout master
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/VCV-Plugins-source.tar.gz compile/plugins/VCV-Plugins )
# fi
# if [ -f ../../../patches/VCV-Plugins.patch ]; then
#   patch -p1 < ../../../patches/VCV-Plugins.patch
# fi
# if [ -f ../../../patches/VCV-Plugins.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/VCV-Plugins.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # Paralis-Modular
# echo ""
# echo "===> Paralis-Modular extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/Paralis-Modular-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/Paralis-Modular-source.tar.gz )
#   cd Paralis-Modular
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/PaeiChe/Paralis-Modular.git
#   cd Paralis-Modular
#   git checkout master
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/Paralis-Modular-source.tar.gz compile/plugins/Paralis-Modular )
# fi
# RACK_DIR=${WORKDIR}/compile/Rack make clean
# if [ -f ../../../patches/Paralis-Modular.patch ]; then
#   patch -p1 < ../../../patches/Paralis-Modular.patch
# fi
# if [ -f ../../../patches/Paralis-Modular.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/Paralis-Modular.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # southpole-vcvrack
# echo ""
# echo "===> southpole-vcvrack extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/southpole-vcvrack-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/southpole-vcvrack-source.tar.gz )
#   cd southpole-vcvrack
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/dogonthehorizon/southpole-vcvrack
#   cd southpole-vcvrack
#   git checkout v1
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/southpole-vcvrack-source.tar.gz compile/plugins/southpole-vcvrack )
# fi
# if [ -f ../../../patches/southpole-vcvrack.patch ]; then
#   patch -p1 < ../../../patches/southpole-vcvrack.patch
# fi
# if [ -f ../../../patches/southpole-vcvrack.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/southpole-vcvrack.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # AtomicHorse-Modules
# echo ""
# echo "===> AtomicHorse-Modules extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/AtomicHorse-Modules-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/AtomicHorse-Modules-source.tar.gz )
#   cd AtomicHorse-Modules
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/animeslave/AtomicHorse-Modules
#   cd AtomicHorse-Modules
#   git checkout master
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/AtomicHorse-Modules-source.tar.gz compile/plugins/AtomicHorse-Modules )
# fi
# if [ -f ../../../patches/AtomicHorse-Modules.patch ]; then
#   patch -p1 < ../../../patches/AtomicHorse-Modules.patch
# fi
# if [ -f ../../../patches/AtomicHorse-Modules.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/AtomicHorse-Modules.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # Modal
# echo ""
# echo "===> Modal extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/Modal-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/Modal-source.tar.gz )
#   cd Modal
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/PelleJuul/Modal
#   cd Modal
#   git checkout main
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/Modal-source.tar.gz compile/plugins/Modal )
# fi
# if [ -f ../../../patches/Modal.patch ]; then
#   patch -p1 < ../../../patches/Modal.patch
# fi
# if [ -f ../../../patches/Modal.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/Modal.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # Diapason-modules
# echo ""
# echo "===> Diapason-modules extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/Diapason-modules-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/Diapason-modules-source.tar.gz )
#   cd Diapason-modules
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/gle-bellier/Diapason-modules
#   cd Diapason-modules
#   git checkout master
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/Diapason-modules-source.tar.gz compile/plugins/Diapason-modules )
# fi
# if [ -f ../../../patches/Diapason-modules.patch ]; then
#   patch -p1 < ../../../patches/Diapason-modules.patch
# fi
# if [ -f ../../../patches/Diapason-modules.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/Diapason-modules.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # Poly_AudibleInstruments
# echo ""
# echo "===> Poly_AudibleInstruments extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/Poly_AudibleInstruments-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/Poly_AudibleInstruments-source.tar.gz )
#   cd Poly_AudibleInstruments
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/Xenakios/Poly_AudibleInstruments
#   cd Poly_AudibleInstruments
#   git checkout master
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/Poly_AudibleInstruments-source.tar.gz compile/plugins/Poly_AudibleInstruments )
# fi
# if [ -f ../../../patches/Poly_AudibleInstruments.patch ]; then
#   patch -p1 < ../../../patches/Poly_AudibleInstruments.patch
# fi
# if [ -f ../../../patches/Poly_AudibleInstruments.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/Poly_AudibleInstruments.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# # 23volts-vcv
# # at least for a certain time this repo disappeared from github, so i
# # moved it over here as extra plugin and disabled it in library repo for now
# echo ""
# echo "===> 23volts-vcv extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/23volts-vcv-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/23volts-vcv-source.tar.gz )
#   cd 23volts-vcv
# ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/23volts/23volts-vcv.git
#   cd 23volts-vcv
#   git checkout bf1f1c2cd93216b0dfd0d2483391c4a9eff2c0c7
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/23volts-vcv-source.tar.gz compile/plugins/23volts-vcv )
# fi
# if [ -f ../../../patches/23volts-vcv.patch ]; then
#   patch -p1 < ../../../patches/23volts-vcv.patch
# fi
# if [ -f ../../../patches/23volts-vcv.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/23volts-vcv.$MYARCH.patch
# fi
# cd ..

# go back to a defined point
cd ${WORKDIR}

# # unpack potential other source archives
# cd source
# for i in $(ls *.tar.gz | grep -v simde.tar.gz | grep -v Rack-source.tar.gz | grep -v library-source.tar.gz | grep -v Fundamental-source.tar.gz | grep -v VCV-Recorder-source.tar.gz | grep -v vcv-link-source.tar.gz | grep -v LRTRack-source.tar.gz | grep -v vcvrack-packgamma-source.tar.gz | grep -v surge-rack-source.tar.gz); do
#   ( cd .. ; tar xzf source/$i )
# done

# go back to a defined point
cd ${WORKDIR}
