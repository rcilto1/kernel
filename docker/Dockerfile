FROM debian:trixie

ARG DEBIAN_FRONTEND=noninteractive

# Dockerfile should be built from root of this project
#ADD docker/sources.list /etc/apt/sources.list



# To apply patches using 'git',
# it is necessary to provide a gitconfig to the container
ADD gitconfig /root/.gitconfig

RUN apt-get update && \
    apt-get -qy full-upgrade && \
    apt-get install -y \
	debhelper \
	dh-make \
	build-essential \
	libncurses-dev \
	bison \
	flex \
	libssl-dev \
	libelf-dev \
	rsync \
	dwarves \
	bc \
	kmod \
	cpio \
        git \
#	liblz4-tool \
	lz4 \
	lzop \
	rsync \
	dwarves \
	openssl

WORKDIR /lux-kernel
