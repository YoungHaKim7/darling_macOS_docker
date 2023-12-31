# Original Source

- https://github.com/darlinghq/darling-docker
- Docker file세팅이 옛날꺼라 최신꺼로 수정해야함. 도커파일 공부해야함. ㅠㅠ 231231


<hr>

# Darling(run macOS software on Linux)

- https://www.darlinghq.org/
- eBook https://docs.darlinghq.org/build-instructions.html

# darling_macOS_docker

- Dockerfile을 작성하고 실행하는 방법

  - https://sewcode.tistory.com/2

- https://www.kali.org/docs/containers/installing-docker-on-kali/

<hr>

# Darling Download releases

https://github.com/darlinghq/darling/releases

<hr>


# Darling in Docker

This is the source code of the Darling Docker image. This is an experimental feature!

Running desktop software under Docker has inherent challenges. It is up to you to ensure that the container can connect to X11, D-Bus (-> PulseAudio) etc.

## Prerequisites

You still need to [build and install](https://docs.darlinghq.org/build-instructions.html) Darling's Linux kernel module within the host system.

BEWARE: The `darling-dkms` package inside this repository is fake.

Before starting the container, do as root:
```
modprobe darling-mach
```

## Tutorial

Starting a container:

```
docker run -d --name darling1 docker.pkg.github.com/darlinghq/darling/darling:latest
```

Now you have a container named `darling1` with `launchd` and various daemons running. You can drop into a shell:

```
docker exec -ti darling1 shell
```

You can run various commands:

```
docker exec darling1 shell -c 'uname -a'
```

## Advanced

### Experimental X11

First of all, disable authorization on your X11 session by executing `xhost +`. Keeping the authorization enabled [is trickier](https://stackoverflow.com/a/25280523/479753).

```
docker run -d --name darling1 -e DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix -v /run/dbus:/run/dbus \
    -v docker.pkg.github.com/darlinghq/darling/darling:latest
```

Whether this works or not depends mainly on the compatibility of OpenGL runtimes between the container and the host.

## Technical Notes

Darling uses a virtual chroot environment under `/usr/libexec/darling`:

* If you bind a volume as `/somewhere`, it will be accessible as `/Volumes/SystemRoot/somewhere`.
* If you bind a volume as `/usr/libexec/darling/somewhere`, it will appear as `/somewhere`.

The base system of the image is Ubuntu. Therefore, if you do this, you will drop into a Linux shell, and NOT into the macOS shell:

```
docker exec -ti darling1 /bin/bash
```

macOS Bash lives as `/usr/libexec/darling/bin/bash`. The `shell` command used in above examples is just a convenience shortcut.
