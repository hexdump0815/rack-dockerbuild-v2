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

cd ${WORKDIR}/compile
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
  #git checkout 6939f7073fb6c13d347938d2a978a5ca5019b2b0

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

  # and the SunsetSignals repo seems to make trouble as well, so get rid of it too
  cd repos
  git submodule deinit -f -- SunsetSignals
  git rm -f SunsetSignals
  cd ..

  # and the ReTunesFree repo seems to make trouble as well, so get rid of it too
  cd repos
  git submodule deinit -f -- ReTunesFree
  git rm -f ReTunesFree
  cd ..

  # and the EH_modules repo seems to make trouble as well, so get rid of it too
  cd repos
  git submodule deinit -f -- EH_modules
  git rm -f EH_modules
  cd ..

  # and the RacketScience repo seems to make trouble as well, so get rid of it too
  cd repos
  git submodule deinit -f -- RacketScience
  git rm -f RacketScience
  cd ..

  # and the questionablemodules repo seems to make trouble as well, so lets fix its gitmodules
  cd repos/questionablemodules
  git submodule deinit .
  sed -i 's,git@github.com:imvu/gmtl.git,https://github.com/imvu/gmtl.git,g' .gitmodules
  git submodule init .
  git submodule update .
  cd ../..

  git submodule update --init --recursive
  ( cd ../.. ; mkdir -p source ; tar czf source/library-source.tar.gz compile/library )
fi

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# arch specific patching if needed

for i in * ; do
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
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# Bark
echo ""
echo "===> Bark extra steps"
echo ""
cd Bark
find * -type f -exec ../../../../simde-ify.sh {} \;
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# ChowDSP
echo ""
echo "===> ChowDSP extra steps"
echo ""
cd ChowDSP
find * -type f -exec ../../../../simde-ify.sh {} \;
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# squinkylabs-plug1
echo ""
echo "===> squinkylabs-plug1 extra steps"
echo ""
cd squinkylabs-plug1
find * -type f -exec ../../../../simde-ify.sh {} \;
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# Valley
echo ""
echo "===> Valley extra steps"
echo ""
cd Valley
find * -type f -exec ../../../../simde-ify.sh {} \;
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# RPJ
echo ""
echo "===> RPJ extra steps"
echo ""
cd RPJ
find * -type f -exec ../../../../simde-ify.sh {} \;
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# dbRackModules
echo ""
echo "===> dbRackModules extra steps"
echo ""
cd dbRackModules
find * -type f -exec ../../../../simde-ify.sh {} \;
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# CosineKitty-Sapphire
echo ""
echo "===> CosineKitty-Sapphire extra steps"
echo ""
cd CosineKitty-Sapphire
find * -type f -exec ../../../../simde-ify.sh {} \;
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# SurgeRack
echo ""
echo "===> SurgeRack extra steps"
echo ""
cd SurgeRack
find * -type f -exec ../../../../simde-ify.sh {} \;
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/library/repos

# SurgeXTRack
echo ""
echo "===> SurgeXTRack extra steps"
echo ""
cd SurgeXTRack
find * -type f -exec ../../../../simde-ify.sh {} \;
cd ..

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

# # go back to a defined starting point to be on the safe side
# cd ${WORKDIR}/compile/plugins
#
# # vcvrack-packone-beta
# echo ""
# echo "===> vcvrack-packone-beta extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/vcvrack-packone-beta-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/vcvrack-packone-beta-source.tar.gz )
#   cd vcvrack-packone-beta
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/stoermelder/vcvrack-packone vcvrack-packone-beta
#   cd vcvrack-packone-beta
#   git checkout v2-dev
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/vcvrack-packone-beta-source.tar.gz compile/plugins/vcvrack-packone-beta )
# fi
# if [ -f ../../../patches/vcvrack-packone-beta.patch ]; then
#   patch -p1 < ../../../patches/vcvrack-packone-beta.patch
# fi
# if [ -f ../../../patches/vcvrack-packone-beta.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/vcvrack-packone-beta.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# vcv-link
echo ""
echo "===> vcv-link extra plugin"
echo ""
# if we have a source archive in the source dir use that ...
if [ -f ../../source/vcv-link-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd ../.. ; tar xzf source/vcv-link-source.tar.gz )
  cd vcv-link
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/stellare-modular/vcv-link
  cd vcv-link
  git checkout 2.0.0
  git submodule update --init --recursive
  ( cd ../../.. ; mkdir -p source ; tar czf source/vcv-link-source.tar.gz compile/plugins/vcv-link )
fi
# for some strange reason the link modules does not get checked out properly - so redo it by hand
cd modules/link
git checkout 4f00babaa9fa6812ada1aacbb71aaac8ac34f547
cd ../..
if [ -f ../../../patches/vcv-link.patch ]; then
  patch -p1 < ../../../patches/vcv-link.patch
fi
if [ -f ../../../patches/vcv-link.$MYARCH.patch ]; then
  patch -p1 < ../../../patches/vcv-link.$MYARCH.patch
fi
cd ..

# # go back to a defined starting point to be on the safe side
# cd ${WORKDIR}/compile/plugins
#
# # surgext-rack-beta
# echo ""
# echo "===> surgext-rack-beta extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/surgext-rack-beta-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/surgext-rack-beta-source.tar.gz )
#   cd surgext-rack-beta
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/surge-synthesizer/surge-rack surgext-rack-beta
#   cd surgext-rack-beta
#   git checkout main
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/surgext-rack-beta-source.tar.gz compile/plugins/surgext-rack-beta )
# fi
# find * -type f -exec ../../../simde-ify.sh {} \;
# if [ -f ../../../patches/surgext-rack-beta.patch ]; then
#   patch -p1 < ../../../patches/surgext-rack-beta.patch
# fi
# if [ -f ../../../patches/surgext-rack-beta.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/surgext-rack-beta.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# 23volts-vcv
echo ""
echo "===> 23volts-vcv extra plugin"
echo ""
# if we have a source archive in the source dir use that ...
if [ -f ../../source/23volts-vcv-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd ../.. ; tar xzf source/23volts-vcv-source.tar.gz )
  cd 23volts-vcv
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/23volts/23volts-vcv.git
  cd 23volts-vcv
  git checkout 2.0
  git submodule update --init --recursive
  ( cd ../../.. ; mkdir -p source ; tar czf source/23volts-vcv-source.tar.gz compile/plugins/23volts-vcv )
fi
if [ -f ../../../patches/23volts-vcv.patch ]; then
  patch -p1 < ../../../patches/23volts-vcv.patch
fi
if [ -f ../../../patches/23volts-vcv.$MYARCH.patch ]; then
  patch -p1 < ../../../patches/23volts-vcv.$MYARCH.patch
fi
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# vcvrack-fv1-emu
echo ""
echo "===> vcvrack-fv1-emu extra plugin"
echo ""
# if we have a source archive in the source dir use that ...
if [ -f ../../source/vcvrack-fv1-emu-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd ../.. ; tar xzf source/vcvrack-fv1-emu-source.tar.gz )
  cd vcvrack-fv1-emu
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/eh2k/vcvrack-fv1-emu.git
  cd vcvrack-fv1-emu
  git checkout 2.0.5
  git submodule update --init --recursive
  ( cd ../../.. ; mkdir -p source ; tar czf source/vcvrack-fv1-emu-source.tar.gz compile/plugins/vcvrack-fv1-emu )
fi
if [ -f ../../../patches/vcvrack-fv1-emu.patch ]; then
  patch -p1 < ../../../patches/vcvrack-fv1-emu.patch
fi
if [ -f ../../../patches/vcvrack-fv1-emu.$MYARCH.patch ]; then
  patch -p1 < ../../../patches/vcvrack-fv1-emu.$MYARCH.patch
fi
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# NullPath
echo ""
echo "===> NullPath extra plugin"
echo ""
# if we have a source archive in the source dir use that ...
if [ -f ../../source/NullPath-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd ../.. ; tar xzf source/NullPath-source.tar.gz )
  cd NullPath
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/alefnull/NullPath.git
  cd NullPath
  git checkout main
  git submodule update --init --recursive
  ( cd ../../.. ; mkdir -p source ; tar czf source/NullPath-source.tar.gz compile/plugins/NullPath )
fi
if [ -f ../../../patches/NullPath.patch ]; then
  patch -p1 < ../../../patches/NullPath.patch
fi
if [ -f ../../../patches/NullPath.$MYARCH.patch ]; then
  patch -p1 < ../../../patches/NullPath.$MYARCH.patch
fi
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# Volume1
echo ""
echo "===> Volume1 extra plugin"
echo ""
# if we have a source archive in the source dir use that ...
if [ -f ../../source/Volume1-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd ../.. ; tar xzf source/Volume1-source.tar.gz )
  cd Volume1
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/Delexander/Volume1
  cd Volume1
  git checkout v2
  git submodule update --init --recursive
  ( cd ../../.. ; mkdir -p source ; tar czf source/Volume1-source.tar.gz compile/plugins/Volume1 )
fi
if [ -f ../../../patches/Volume1.patch ]; then
  patch -p1 < ../../../patches/Volume1.patch
fi
if [ -f ../../../patches/Volume1.$MYARCH.patch ]; then
  patch -p1 < ../../../patches/Volume1.$MYARCH.patch
fi
cd ..

# # go back to a defined starting point to be on the safe side
# cd ${WORKDIR}/compile/plugins
#
# this plugin compiles well but gives an error when starting - more investigation required
# # substation-opensource
# echo ""
# echo "===> substation-opensource extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/substation-opensource-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/substation-opensource-source.tar.gz )
#   cd substation-opensource
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://gitlab.com/slimechild/substation-opensource.git
#   cd substation-opensource
#   git checkout 9dca160ed29596d5fc64c02c7f43a91dfac5a4d1
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/substation-opensource-source.tar.gz compile/plugins/substation-opensource )
# fi
# if [ -f ../../../patches/substation-opensource.patch ]; then
#   patch -p1 < ../../../patches/substation-opensource.patch
# fi
# if [ -f ../../../patches/substation-opensource.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/substation-opensource.$MYARCH.patch
# fi

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# vcvrack-packtau
echo ""
echo "===> vcvrack-packtau extra plugin"
echo ""
# if we have a source archive in the source dir use that ...
if [ -f ../../source/vcvrack-packtau-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd ../.. ; tar xzf source/vcvrack-packtau-source.tar.gz )
  cd vcvrack-packtau
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/stoermelder/vcvrack-packtau.git
  cd vcvrack-packtau
  git checkout v2
  git submodule update --init --recursive
  ( cd ../../.. ; mkdir -p source ; tar czf source/vcvrack-packtau-source.tar.gz compile/plugins/vcvrack-packtau )
fi
if [ -f ../../../patches/vcvrack-packtau.patch ]; then
  patch -p1 < ../../../patches/vcvrack-packtau.patch
fi
if [ -f ../../../patches/vcvrack-packtau.$MYARCH.patch ]; then
  patch -p1 < ../../../patches/vcvrack-packtau.$MYARCH.patch
fi
cd ..

# # go back to a defined starting point to be on the safe side
# cd ${WORKDIR}/compile/plugins
#
# # MindMeldModular-beta
# echo ""
# echo "===> MindMeldModular-beta extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/MindMeldModular-beta-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/MindMeldModular-beta-source.tar.gz )
#   cd MindMeldModular-beta
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/MarcBoule/MindMeldModular.git MindMeldModular-beta
#   cd MindMeldModular-beta
#   git checkout v2.1.1b
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/MindMeldModular-beta-source.tar.gz compile/plugins/MindMeldModular-beta )
# fi
# if [ -f ../../../patches/MindMeldModular-beta.patch ]; then
#   patch -p1 < ../../../patches/MindMeldModular-beta.patch
# fi
# if [ -f ../../../patches/MindMeldModular-beta.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/MindMeldModular-beta.$MYARCH.patch
# fi
# cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# qwelk-vcvrack-plugins
echo ""
echo "===> qwelk-vcvrack-plugins extra plugin"
echo ""
# if we have a source archive in the source dir use that ...
if [ -f ../../source/qwelk-vcvrack-plugins-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd ../.. ; tar xzf source/qwelk-vcvrack-plugins-source.tar.gz )
  cd qwelk-vcvrack-plugins
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/netboy3/qwelk-vcvrack-plugins.git
  cd qwelk-vcvrack-plugins
  git checkout v2
  git submodule update --init --recursive
  ( cd ../../.. ; mkdir -p source ; tar czf source/qwelk-vcvrack-plugins-source.tar.gz compile/plugins/qwelk-vcvrack-plugins )
fi
if [ -f ../../../patches/qwelk-vcvrack-plugins.patch ]; then
  patch -p1 < ../../../patches/qwelk-vcvrack-plugins.patch
fi
if [ -f ../../../patches/qwelk-vcvrack-plugins.$MYARCH.patch ]; then
  patch -p1 < ../../../patches/qwelk-vcvrack-plugins.$MYARCH.patch
fi
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# LocoVCVModules
echo ""
echo "===> LocoVCVModules extra plugin"
echo ""
# if we have a source archive in the source dir use that ...
if [ -f ../../source/LocoVCVModules-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd ../.. ; tar xzf source/LocoVCVModules-source.tar.gz )
  cd LocoVCVModules
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/SteveRussell33/LocoVCVModules
  cd LocoVCVModules
  git checkout master
  git submodule update --init --recursive
  ( cd ../../.. ; mkdir -p source ; tar czf source/LocoVCVModules-source.tar.gz compile/plugins/LocoVCVModules )
fi
if [ -f ../../../patches/LocoVCVModules.patch ]; then
  patch -p1 < ../../../patches/LocoVCVModules.patch
fi
if [ -f ../../../patches/LocoVCVModules.$MYARCH.patch ]; then
  patch -p1 < ../../../patches/LocoVCVModules.$MYARCH.patch
fi
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# rackwindows
echo ""
echo "===> rackwindows extra plugin"
echo ""
# if we have a source archive in the source dir use that ...
if [ -f ../../source/rackwindows-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd ../.. ; tar xzf source/rackwindows-source.tar.gz )
  cd rackwindows
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/Ahornberg/rackwindows
  cd rackwindows
  git checkout v2.0.1
  git submodule update --init --recursive
  ( cd ../../.. ; mkdir -p source ; tar czf source/rackwindows-source.tar.gz compile/plugins/rackwindows )
fi
if [ -f ../../../patches/rackwindows.patch ]; then
  patch -p1 < ../../../patches/rackwindows.patch
fi
if [ -f ../../../patches/rackwindows.$MYARCH.patch ]; then
  patch -p1 < ../../../patches/rackwindows.$MYARCH.patch
fi
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# Mog-VCV
echo ""
echo "===> Mog-VCV extra plugin"
echo ""
# if we have a source archive in the source dir use that ...
if [ -f ../../source/Mog-VCV-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd ../.. ; tar xzf source/Mog-VCV-source.tar.gz )
  cd Mog-VCV
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/Ahornberg/Mog-VCV
  cd Mog-VCV
  git checkout v2.0.0
  git submodule update --init --recursive
  ( cd ../../.. ; mkdir -p source ; tar czf source/Mog-VCV-source.tar.gz compile/plugins/Mog-VCV )
fi
if [ -f ../../../patches/Mog-VCV.patch ]; then
  patch -p1 < ../../../patches/Mog-VCV.patch
fi
if [ -f ../../../patches/Mog-VCV.$MYARCH.patch ]; then
  patch -p1 < ../../../patches/Mog-VCV.$MYARCH.patch
fi
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# forsitan-modulare
echo ""
echo "===> forsitan-modulare extra plugin"
echo ""
# if we have a source archive in the source dir use that ...
if [ -f ../../source/forsitan-modulare-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd ../.. ; tar xzf source/forsitan-modulare-source.tar.gz )
  cd forsitan-modulare
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/Ahornberg/forsitan-modulare
  cd forsitan-modulare
  git checkout v2.0.1
  git submodule update --init --recursive
  ( cd ../../.. ; mkdir -p source ; tar czf source/forsitan-modulare-source.tar.gz compile/plugins/forsitan-modulare )
fi
if [ -f ../../../patches/forsitan-modulare.patch ]; then
  patch -p1 < ../../../patches/forsitan-modulare.patch
fi
if [ -f ../../../patches/forsitan-modulare.$MYARCH.patch ]; then
  patch -p1 < ../../../patches/forsitan-modulare.$MYARCH.patch
fi
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# AriaModules
echo ""
echo "===> AriaModules extra plugin"
echo ""
# if we have a source archive in the source dir use that ...
if [ -f ../../source/AriaModules-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd ../.. ; tar xzf source/AriaModules-source.tar.gz )
  cd AriaModules
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/Ahornberg/AriaModules
  cd AriaModules
  git checkout v2.0.0
  git submodule update --init --recursive
  ( cd ../../.. ; mkdir -p source ; tar czf source/AriaModules-source.tar.gz compile/plugins/AriaModules )
fi
if [ -f ../../../patches/AriaModules.patch ]; then
  patch -p1 < ../../../patches/AriaModules.patch
fi
if [ -f ../../../patches/AriaModules.$MYARCH.patch ]; then
  patch -p1 < ../../../patches/AriaModules.$MYARCH.patch
fi
cd ..

# go back to a defined starting point to be on the safe side
cd ${WORKDIR}/compile/plugins

# ihtsyn
echo ""
echo "===> ihtsyn extra plugin"
echo ""
# if we have a source archive in the source dir use that ...
if [ -f ../../source/ihtsyn-source.tar.gz ]; then
  echo "INFO: using sources from the source archive"
  ( cd ../.. ; tar xzf source/ihtsyn-source.tar.gz )
  cd ihtsyn
# ... otherwise get it from git and create a source archive afterwards
else
  git clone https://github.com/Ahornberg/ihtsyn
  cd ihtsyn
  git checkout v2.0.0
  git submodule update --init --recursive
  ( cd ../../.. ; mkdir -p source ; tar czf source/ihtsyn-source.tar.gz compile/plugins/ihtsyn )
fi
if [ -f ../../../patches/ihtsyn.patch ]; then
  patch -p1 < ../../../patches/ihtsyn.patch
fi
if [ -f ../../../patches/ihtsyn.$MYARCH.patch ]; then
  patch -p1 < ../../../patches/ihtsyn.$MYARCH.patch
fi
cd ..

# still some things to be sorted out to get this built properly
# on all supported arches - see build-modules.sh-proto
# # go back to a defined starting point to be on the safe side
# cd ${WORKDIR}/compile/plugins
#
# # dbRackCsound
# echo ""
# echo "===> dbRackCsound extra plugin"
# echo ""
# # if we have a source archive in the source dir use that ...
# if [ -f ../../source/dbRackCsound-source.tar.gz ]; then
#   echo "INFO: using sources from the source archive"
#   ( cd ../.. ; tar xzf source/dbRackCsound-source.tar.gz )
#   cd dbRackCsound
# # ... otherwise get it from git and create a source archive afterwards
# else
#   git clone https://github.com/docb/dbRackCsound
#   cd dbRackCsound
#   git checkout v2.0.3
#   git submodule update --init --recursive
#   ( cd ../../.. ; mkdir -p source ; tar czf source/dbRackCsound-source.tar.gz compile/plugins/dbRackCsound )
# fi
# find * -type f -exec ../../../simde-ify.sh {} \;
# if [ -f ../../../patches/dbRackCsound.patch ]; then
#   patch -p1 < ../../../patches/dbRackCsound.patch
# fi
# if [ -f ../../../patches/dbRackCsound.$MYARCH.patch ]; then
#   patch -p1 < ../../../patches/dbRackCsound.$MYARCH.patch
# fi
# cd ..

# go back to a defined point
cd ${WORKDIR}
