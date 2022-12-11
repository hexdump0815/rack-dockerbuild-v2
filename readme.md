# vcvrack-dockerbuild-v2

docker based build for vcvrack v2 on debian bullseye for aarch64, armv7l, x86_64 and i686

still very much work in progress ... it might work on raspberry pi os as well, but most
probably only on the 64bit version of it as it is essentially a debian bullseye system

very short summary of how to use this:
- you need a system of the arch you want to build for (for example aarch64 for aarch64)
- docker needs to be installed and running well on that system
- clone this repo somewhere and make sure there are around 50+ gb of space available
- first build the docker image used for the build process: ./docker-buildenv.sh
- prepare for the rack build: ./prepare.sh
- prepare for the module build: ./prepare-modules.sh
- enter the docker buildenv: ./buildenv.sh
- inside of that start the rack build: /compile/build.sh
- inside of that start the module build: /compile/build-modules.sh
- exit the docker buildenv: exit
- build a distribution dir: ./make-dist.sh
- the result will be a dir dist - put this somewhere and run "./Rack -d" in it to start rack
