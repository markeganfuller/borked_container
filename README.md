# borked container

Broken singularity install that creates containers that will only work when run
as root. Fixed as part of issue https://github.com/sylabs/singularity/issues/835

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
/share/apps/centos7/singularity/2.3.1/bin/singularity --version
2.3.1-HEAD.ge214d4e
--------------------------------------
/share/apps/centos7/singularity/2.3.1/bin/singularity create borked.img
Initializing Singularity image subsystem
Opening image file: borked.img
Creating 768MiB image
Binding image to loop
Creating file system within image
Image is done: borked.img
--------------------------------------
sudo /share/apps/centos7/singularity/2.3.1/bin/singularity bootstrap borked.img /home/vagrant/singularity-containers/dock.def
Sanitizing environment
Building from bootstrap definition recipe
Adding base Singularity environment to container
Docker image path: index.docker.io/library/centos:centos6
Cache folder set to /root/.singularity/docker
Exploding layer: sha256:8b04204cfecd799ca315da5d0460363f2c114ed699bc0a2e023bb26fd85243ee.tar.gz
Exploding layer: sha256:60e3079474b1671bcc20b340572ee6cae735ecdd5a13d6686475ca4916eb6003.tar.gz
Finalizing Singularity container
--------------------------------------
/share/apps/centos7/singularity/2.3.1/bin/singularity inspect borked.img
ERROR: The Singularity metadata directory does not exist in image
ABORT: Aborting with RETVAL=255
--------------------------------------
/share/apps/centos7/singularity/2.3.1/bin/singularity shell borked.img
ERROR  : No valid /bin/sh in container
ABORT  : Retval = 255
--------------------------------------
sudo /share/apps/centos7/singularity/2.3.1/bin/singularity shell borked.img
WARNING: Non existant 'bind path' source: '/data'
Singularity: Invoking an interactive shell within container...

Singularity borked.img:/tmp> exit
```

## Copying install from live

On live:

```
tar -czvf install.tgz /share/apps/centos7/singularity/2.3.1
getfacl -R /share/apps/centos7/singularity/2.3.1 > facl
```

When deploying:

```
tar -xzvf install.tgz
# Sudo needed to suid  / chown etc
sudo setfacl --restore=facl
sudo mv share /
```
