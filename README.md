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
