# borked container

Broken singularity container that will only work when run as root.

## Running

```bash
vagrant up
vagrant ssh

cd singularity-containers
./test.sh
```

## Example output

```
[vagrant@centos7 singularity-containers]$ ./test.sh
singularity --version
2.3.1-master.g1acb724
--------------------------------------
singularity inspect borked.img
ERROR: The Singularity metadata directory does not exist in image
ABORT: Aborting with RETVAL=255
--------------------------------------
singularity shell borked.img
ERROR  : No valid /bin/sh in container
ABORT  : Retval = 255
--------------------------------------
sudo singularity shell borked.img
Singularity: Invoking an interactive shell within container...

Singularity borked.img:/home/vagrant/singularity-containers>
```

## Creation of the broken image

The container was created with the following command line:

```
$ cat dock.def
Bootstrap: docker
From: centos:centos6

$ module load singularity
$ singularity create borked.img
$ sudo $(which singularity) bootstrap borked.img dock.def
```

The use of `sudo` and `which` here works successfully with no errors despite
losing a number of path changes from the module file:

```
$ module show singularity

-------------------------------------------------------------------
/share/apps/environmentmodules/centos7/general/singularity/2.3.1:

module-whatis    adds singularity 2.3.1 to your PATH environment variable
conflict         singularity
prepend-path     PATH /share/apps/centos7/singularity/2.3.1/bin
prepend-path     LD_LIBRARY_PATH /share/apps/centos7/singularity/2.3.1/lib
prepend-path     MANPATH /share/apps/centos7/singularity/2.3.1/share/man
prepend-path     C_INCLUDE_PATH /share/apps/centos7/singularity/2.3.1/include
prepend-path     CPLUS_INCLUDE_PATH /share/apps/centos7/singularity/2.3.1/include
-------------------------------------------------------------------
```

The actual issue here seems to be that Singularity happily carries on and
doesn't throw any errors but produces a container only usable by root. Whilst
clearly the initial error is the user's fault singularity should error instead
of carrying on.
