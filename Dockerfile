FROM ubuntu:22.04 as base

ARG DARLING_DEB

ADD darling_0.1.20230310.jammy_amd64.deb /root

RUN dpkg -i /root/darling_0.1.20230310.jammy_amd64.deb && rm /root/darling_0.1.20230310.jammy_amd64.deb

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y \
  sudo apt install cmake automake clang-15 bison flex libfuse-dev libudev-dev pkg-config libc6-dev-i386 \
  gcc-multilib libcairo2-dev libgl1-mesa-dev curl libglu1-mesa-dev libtiff5-dev \
  libfreetype6-dev git git-lfs libelf-dev libxml2-dev libegl1-mesa-dev libfontconfig1-dev \
  libbsd-dev libxrandr-dev libxcursor-dev libgif-dev libavutil-dev libpulse-dev \
  libavformat-dev libavcodec-dev libswresample-dev libdbus-1-dev libxkbfile-dev \
  libssl-dev libstdc++-12-dev \
  libcairo2 libcairo2:i386 \
	libgl1 libgl1:i386 \
	libglu1 libglu1:i386 \
	libtiff5 libtiff5:i386 \
	libfreetype6 libfreetype6:i386 \
	libegl1-mesa libegl1-mesa:i386 \
	libfontconfig1 libfontconfig1:i386 \
	libxrandr2 libxrandr2:i386 \
	libxcursor1 libxcursor1:i386 \
	libgif7 libgif7:i386 \
	libpulse0 libpulse0:i386 \
	libavformat58 libavformat58:i386 \
	libavcodec58 libavcodec58:i386 \
	libavresample4 libavresample4:i386 \
	libdbus-1-3 libdbus-1-3:i386 \
	libxkbfile1 libxkbfile1:i386 \
	libc6-i386 \
	fuse -o APT::Immediate-Configure=0 \
	wget && apt-get clean -y

RUN	wget -O darling.deb ${DARLING_DEB} && \
	dpkg -i darling.deb && rm -f darling .deb

RUN mkdir -p /usr/libexec/darling/Users/macuser /home/macuser \
	/usr/libexec/darling/Users/Shared \
	/usr/libexec/darling/Volumes/SystemRoot \
	/usr/libexec/darling/var/tmp \
	/usr/libexec/darling/var/run
RUN cd /usr/libexec/darling/Users/macuser && ln -s /Volumes/SystemRoot/home/macuser LinuxHome

ENV HOME=/Users/macuser

ADD bootstrap /
ADD shell /usr/bin
RUN rm -rf /usr/libexec/darling/proc && cd /usr/libexec/darling && ln -s /Volumes/SystemRoot/proc

ENTRYPOINT ["/bootstrap"]

