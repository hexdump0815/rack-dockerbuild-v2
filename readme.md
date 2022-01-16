# vcvrack-dockerbuild-v2
docker based build for vcvrack v1 on armv7l and aarch64 on ubuntu 18.04 

still very much work in progress ...

very short summary of how to use this:
- you need a system of the arch you want to build for (for example aarch64 for aarch64)
- docker needs to be installed and running well on that system
- clone this repo somewhere
- first build the docker image used for the build process: ./docker-buildenv.sh
  - if you want to build for raspbian use docker-buildenv-raspbian.sh instead
- prepare for the rack build: ./prepare.sh
- prepare for the module build: ./prepare-modules.sh
- enter the docker buildenv: ./buildenv.sh
- inside of that start the rack build: /compile/build.sh
- inside of that start the module build: /compile/build-modules.sh
- exit the docker buildenv: exit
- build a distribution dir: ./make-dist.sh
- the result will be a dir dist - put this somewhere and run "./Rack -d" in it to start rack
