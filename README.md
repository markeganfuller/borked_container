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

Note: This can't be reproduced in this vagrant machine as singularity is
globablly installed.

### Creation with --debug

```
$ sudo $(which singularity) --debug bootstrap borked.img dock.def
[sudo] password for aaw702:
Enabling debugging
Ending argument loop
Singularity version: 2.3.1-HEAD.ge214d4e
Exec'ing: /share/apps/centos7/singularity/2.3.1/libexec/singularity/cli/bootstrap.exec
VERBOSE [U=0,P=45429]      message_init()                            Set messagelevel to: 5
VERBOSE [U=0,P=45429]      singularity_config_parse()                Initialize configuration file: /share/apps/centos7/singularity/2.3.1/etc/singularity/singularity.conf
DEBUG   [U=0,P=45429]      singularity_config_parse()                Starting parse of configuration file /share/apps/centos7/singularity/2.3.1/etc/singularity/singularity.conf
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key allow setuid = 'yes'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key max loop devices = '256'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key allow pid ns = 'yes'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key config passwd = 'yes'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key config group = 'yes'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key config resolv_conf = 'yes'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key mount proc = 'yes'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key mount sys = 'yes'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key mount dev = 'yes'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key mount home = 'yes'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key mount tmp = 'yes'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key mount hostfs = 'no'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key bind path = '/etc/localtime'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key bind path = '/etc/hosts'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key bind path = '/data'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key user bind control = 'yes'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key enable overlay = 'yes'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key mount slave = 'yes'
VERBOSE [U=0,P=45429]      singularity_config_parse()                Got config key sessiondir max size = '16'
DEBUG   [U=0,P=45429]      singularity_config_parse()                Finished parsing configuration file '/share/apps/centos7/singularity/2.3.1/etc/singularity/singularity.conf'
VERBOSE [U=0,P=45429]      singularity_registry_init()               Initializing Singularity Registry
VERBOSE [U=0,P=45429]      singularity_registry_set()                Adding value to registry: 'WRITABLE' = '1'
DEBUG   [U=0,P=45429]      singularity_registry_set()                Returning singularity_registry_set(WRITABLE, 1) = 0
VERBOSE [U=0,P=45429]      singularity_registry_set()                Adding value to registry: 'LIBEXECDIR' = '/share/apps/centos7/singularity/2.3.1/libexec'
DEBUG   [U=0,P=45429]      singularity_registry_set()                Returning singularity_registry_set(libexecdir, /share/apps/centos7/singularity/2.3.1/libexec) = 0
VERBOSE [U=0,P=45429]      singularity_registry_set()                Adding value to registry: 'COMMAND' = 'bootstrap'
DEBUG   [U=0,P=45429]      singularity_registry_set()                Returning singularity_registry_set(COMMAND, bootstrap) = 0
VERBOSE [U=0,P=45429]      singularity_registry_set()                Adding value to registry: 'MESSAGELEVEL' = '5'
DEBUG   [U=0,P=45429]      singularity_registry_set()                Returning singularity_registry_set(MESSAGELEVEL, 5) = 0
VERBOSE [U=0,P=45429]      singularity_registry_set()                Adding value to registry: 'VERSION' = '2.3.1-HEAD.ge214d4e'
DEBUG   [U=0,P=45429]      singularity_registry_set()                Returning singularity_registry_set(version, 2.3.1-HEAD.ge214d4e) = 0
VERBOSE [U=0,P=45429]      singularity_registry_set()                Adding value to registry: 'LOCALSTATEDIR' = '/share/apps/centos7/singularity/2.3.1/var'
DEBUG   [U=0,P=45429]      singularity_registry_set()                Returning singularity_registry_set(localstatedir, /share/apps/centos7/singularity/2.3.1/var) = 0
VERBOSE [U=0,P=45429]      singularity_registry_set()                Adding value to registry: 'SYSCONFDIR' = '/share/apps/centos7/singularity/2.3.1/etc'
DEBUG   [U=0,P=45429]      singularity_registry_set()                Returning singularity_registry_set(sysconfdir, /share/apps/centos7/singularity/2.3.1/etc) = 0
VERBOSE [U=0,P=45429]      singularity_registry_set()                Adding value to registry: 'BINDIR' = '/share/apps/centos7/singularity/2.3.1/bin'
DEBUG   [U=0,P=45429]      singularity_registry_set()                Returning singularity_registry_set(bindir, /share/apps/centos7/singularity/2.3.1/bin) = 0
VERBOSE [U=0,P=45429]      singularity_registry_set()                Adding value to registry: 'BUILDDEF' = 'dock.def'
DEBUG   [U=0,P=45429]      singularity_registry_set()                Returning singularity_registry_set(BUILDDEF, dock.def) = 0
VERBOSE [U=0,P=45429]      singularity_registry_set()                Adding value to registry: 'IMAGE' = 'borked.img'
DEBUG   [U=0,P=45429]      singularity_registry_set()                Returning singularity_registry_set(IMAGE, borked.img) = 0
DEBUG   [U=0,P=45429]      singularity_registry_get()                Returning NULL on 'HOME'
DEBUG   [U=0,P=45429]      singularity_registry_get()                Returning NULL on 'TARGET_UID'
DEBUG   [U=0,P=45429]      singularity_registry_get()                Returning NULL on 'TARGET_GID'
DEBUG   [U=0,P=45429]      singularity_priv_init()                   Initializing user info
DEBUG   [U=0,P=45429]      singularity_priv_init()                   Set the calling user's username to: root
DEBUG   [U=0,P=45429]      singularity_priv_init()                   Marking uinfo structure as ready
DEBUG   [U=0,P=45429]      singularity_priv_init()                   Obtaining home directory
VERBOSE [U=0,P=45429]      singularity_priv_init()                   Set home (via getpwuid()) to: /root
INFO    [U=0,P=45429]      main()                                    Sanitizing environment
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: HOSTNAME
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: SINGULARITY_WRITABLE
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: TERM
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: SHELL
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: HISTSIZE
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: SINGULARITY_libexecdir
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: SINGULARITY_COMMAND
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: USER
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: SINGULARITY_MESSAGELEVEL
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: LS_COLORS
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: SUDO_USER
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: SUDO_UID
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: USERNAME
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: SINGULARITY_version
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: MAIL
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: PATH
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: SINGULARITY_localstatedir
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: PWD
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: LANG
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: HOME
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: SUDO_COMMAND
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: SHLVL
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: SINGULARITY_sysconfdir
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: LOGNAME
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: SINGULARITY_bindir
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: SINGULARITY_BUILDDEF
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: SUDO_GID
DEBUG   [U=0,P=45429]      envclean()                                Unsetting environment variable: SINGULARITY_IMAGE
VERBOSE [U=0,P=45429]      singularity_registry_set()                Adding value to registry: 'WRITABLE' = '1'
DEBUG   [U=0,P=45429]      singularity_registry_set()                Returning singularity_registry_set(WRITABLE, 1) = 0
DEBUG   [U=0,P=45429]      singularity_registry_get()                Returning value from registry: 'IMAGE' = 'borked.img'
DEBUG   [U=0,P=45429]      singularity_config_get_value_impl()       No configuration entry found for 'limit container owners'; returning default value 'NULL'
DEBUG   [U=0,P=45429]      singularity_config_get_value_impl()       No configuration entry found for 'limit container paths'; returning default value 'NULL'
DEBUG   [U=0,P=45429]      singularity_image_open()                  Opening file descriptor to image: borked.img
DEBUG   [U=0,P=45429]      singularity_suid_enabled()                Executable is not SUID
DEBUG   [U=0,P=45429]      singularity_runtime_ns()                  Calling: _singularity_runtime_ns_mnt()
DEBUG   [U=0,P=45429]      singularity_config_get_bool_char_impl()   Called singularity_config_get_bool(mount slave, yes)
DEBUG   [U=0,P=45429]      singularity_config_get_value_impl()       Returning configuration value mount slave='yes'
DEBUG   [U=0,P=45429]      singularity_config_get_bool_char_impl()   Return singularity_config_get_bool(mount slave, yes) = 1
DEBUG   [U=0,P=45429]      singularity_priv_escalate()               Running as root, not changing privileges
DEBUG   [U=0,P=45429]      singularity_runtime_ns_mnt()              Virtualizing FS namespace
DEBUG   [U=0,P=45429]      singularity_runtime_ns_mnt()              Virtualizing mount namespace
DEBUG   [U=0,P=45429]      singularity_runtime_ns_mnt()              Making mounts slave
DEBUG   [U=0,P=45429]      singularity_priv_drop()                   Running as root, not changing privileges
DEBUG   [U=0,P=45429]      singularity_config_get_value_impl()       Returning configuration value max loop devices='256'
DEBUG   [U=0,P=45429]      singularity_image_bind()                  Entered singularity_image_bind()
DEBUG   [U=0,P=45429]      singularity_image_bind()                  Converting max_loop_devs_string to int: '256'
DEBUG   [U=0,P=45429]      singularity_image_bind()                  Converted max_loop_devs_string to int: '256' -> 256
DEBUG   [U=0,P=45429]      singularity_image_bind()                  Checking if this image has been properly opened
DEBUG   [U=0,P=45429]      singularity_image_bind()                  Checking if image is valid file
DEBUG   [U=0,P=45429]      singularity_image_bind()                  Checking if image is already bound to a loop device
DEBUG   [U=0,P=45429]      singularity_registry_get()                Returning value from registry: 'WRITABLE' = '1'
DEBUG   [U=0,P=45429]      singularity_image_bind()                  Setting loopdev open to: O_RDWR
DEBUG   [U=0,P=45429]      singularity_image_bind()                  Setting LO_FLAGS_AUTOCLEAR
DEBUG   [U=0,P=45429]      singularity_image_bind()                  Calculating image offset
VERBOSE [U=0,P=45429]      singularity_image_check()                 Checking what kind of image we are mounting
VERBOSE [U=0,P=45429]      singularity_image_check_image()           Checking that file pointer is a Singularity image
DEBUG   [U=0,P=45429]      singularity_image_check_image()           First line of image(fd=4): #!/usr/bin/env run-singularity

DEBUG   [U=0,P=45429]      singularity_image_check_image()           Checking if first line matches key
VERBOSE [U=0,P=45429]      singularity_image_check_image()           File is a valid Singularity image
VERBOSE [U=0,P=45429]      singularity_image_offset()                Calculating image offset
VERBOSE [U=0,P=45429]      singularity_image_offset()                Found image at an offset of 31 bytes
DEBUG   [U=0,P=45429]      singularity_image_offset()                Returning image_offset(image_fp) = 31
DEBUG   [U=0,P=45429]      singularity_priv_escalate()               Running as root, not changing privileges
DEBUG   [U=0,P=45429]      singularity_image_bind()                  Finding next available loop device...
VERBOSE [U=0,P=45429]      singularity_image_bind()                  Found available loop device: /dev/loop0
DEBUG   [U=0,P=45429]      singularity_image_bind()                  Setting loop device flags
DEBUG   [U=0,P=45429]      singularity_priv_drop()                   Running as root, not changing privileges
VERBOSE [U=0,P=45429]      singularity_image_bind()                  Using loop device: /dev/loop0
VERBOSE [U=0,P=45429]      singularity_runtime_rootfs()              Set container directory to: /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container
DEBUG   [U=0,P=45429]      singularity_runtime_rootfs()              Checking for container directory
DEBUG   [U=0,P=45429]      singularity_runtime_rootfs()              Returning container_directory: /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container
DEBUG   [U=0,P=45429]      chk_mode()                                Checking exact mode (40755) on: /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container
DEBUG   [U=0,P=45429]      chk_mode()                                Found appropriate mode on file: /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container
VERBOSE [U=0,P=45429]      singularity_image_mount()                 Checking what kind of image we are mounting
VERBOSE [U=0,P=45429]      singularity_image_mount()                 Attempting to mount as singularity image
DEBUG   [U=0,P=45429]      singularity_registry_get()                Returning value from registry: 'WRITABLE' = '1'
DEBUG   [U=0,P=45429]      singularity_priv_escalate()               Running as root, not changing privileges
VERBOSE [U=0,P=45429]      singularity_image_mount_image_mount()     Mounting /dev/loop0 in read/write to: /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container
DEBUG   [U=0,P=45429]      singularity_priv_drop()                   Running as root, not changing privileges
DEBUG   [U=0,P=45429]      envar_set()                               Setting environment variable: 'PATH' = '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin'
DEBUG   [U=0,P=45429]      singularity_runtime_rootfs()              Returning container_directory: /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container
DEBUG   [U=0,P=45429]      envar_set()                               Setting environment variable: 'SINGULARITY_ROOTFS' = '/share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container'
DEBUG   [U=0,P=45429]      singularity_registry_get()                Returning value from registry: 'LIBEXECDIR' = '/share/apps/centos7/singularity/2.3.1/libexec'
DEBUG   [U=0,P=45429]      envar_set()                               Setting environment variable: 'SINGULARITY_libexecdir' = '/share/apps/centos7/singularity/2.3.1/libexec'
DEBUG   [U=0,P=45429]      singularity_registry_get()                Returning value from registry: 'IMAGE' = 'borked.img'
DEBUG   [U=0,P=45429]      envar_set()                               Setting environment variable: 'SINGULARITY_IMAGE' = 'borked.img'
DEBUG   [U=0,P=45429]      singularity_registry_get()                Returning value from registry: 'BUILDDEF' = 'dock.def'
DEBUG   [U=0,P=45429]      envar_set()                               Setting environment variable: 'SINGULARITY_BUILDDEF' = 'dock.def'
DEBUG   [U=0,P=45429]      singularity_registry_get()                Returning value from registry: 'MESSAGELEVEL' = '5'
DEBUG   [U=0,P=45429]      envar_set()                               Setting environment variable: 'SINGULARITY_MESSAGELEVEL' = '5'
DEBUG   [U=0,P=45429]      singularity_registry_get()                Returning NULL on 'NOTEST'
DEBUG   [U=0,P=45429]      envar_set()                               Unsetting environment variable: SINGULARITY_NOTEST
DEBUG   [U=0,P=45429]      singularity_registry_get()                Returning NULL on 'BUILDSECTION'
DEBUG   [U=0,P=45429]      envar_set()                               Unsetting environment variable: SINGULARITY_BUILDSECTION
DEBUG   [U=0,P=45429]      singularity_registry_get()                Returning NULL on 'BUILDNOBASE'
DEBUG   [U=0,P=45429]      envar_set()                               Unsetting environment variable: SINGULARITY_BUILDNOBASE
DEBUG   [U=0,P=45429]      singularity_registry_get()                Returning NULL on 'CACHEDIR'
DEBUG   [U=0,P=45429]      envar_set()                               Unsetting environment variable: SINGULARITY_CACHEDIR
DEBUG   [U=0,P=45429]      singularity_registry_get()                Returning value from registry: 'VERSION' = '2.3.1-HEAD.ge214d4e'
DEBUG   [U=0,P=45429]      envar_set()                               Setting environment variable: 'SINGULARITY_version' = '2.3.1-HEAD.ge214d4e'
DEBUG   [U=0,P=45429]      envar_set()                               Setting environment variable: 'HOME' = '/root'
DEBUG   [U=0,P=45429]      envar_set()                               Setting environment variable: 'LANG' = 'C'
DEBUG   [U=0,P=45429]      singularity_registry_get()                Returning value from registry: 'BUILDDEF' = 'dock.def'
INFO    [U=0,P=45429]      bootstrap_init()                          Building from bootstrap definition recipe
VERBOSE [U=0,P=45429]      bootstrap_keyval_parse()                  Got bootstrap definition key/val 'Bootstrap' = 'docker'
VERBOSE [U=0,P=45429]      singularity_registry_set()                Adding value to registry: 'DRIVER' = 'docker'
DEBUG   [U=0,P=45429]      singularity_registry_set()                Returning singularity_registry_set(DRIVER, docker) = 0
DEBUG   [U=0,P=45429]      uppercase()                               Transformed to uppercase: 'Bootstrap' -> 'BOOTSTRAP'
DEBUG   [U=0,P=45429]      envar_set()                               Setting environment variable: 'BOOTSTRAP' = 'docker'
VERBOSE [U=0,P=45429]      bootstrap_keyval_parse()                  Got bootstrap definition key/val 'From' = 'centos:centos6'
DEBUG   [U=0,P=45429]      uppercase()                               Transformed to uppercase: 'From' -> 'FROM'
DEBUG   [U=0,P=45429]      envar_set()                               Setting environment variable: 'FROM' = 'centos:centos6'
VERBOSE [U=0,P=45446]      message_init()                            Set messagelevel to: 5
DEBUG   [U=0,P=45446]      main()                                    Iterating through file looking for sections matching: %pre
Adding base Singularity environment to container
VERBOSE2 SINGULARITY_COMMAND_ASIS found as False
VERBOSE2 SINGULARITY_ROOTFS found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container
VERBOSE2 SINGULARITY_METADATA_FOLDER found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d
VERBOSE2 SINGULARITY_FIX_PERMS found as False
VERBOSE2 SINGULARITY_COLORIZE not defined (None)
VERBOSE2 SINGULARITY_DISABLE_CACHE found as False
VERBOSE2 SINGULARITY_CACHEDIR found as /root/.singularity
VERBOSE2 SINGULARITY_ENVIRONMENT found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/environment
VERBOSE2 SINGULARITY_RUNSCRIPT found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/singularity
VERBOSE2 SINGULARITY_TESTFILE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/test
VERBOSE2 SINGULARITY_DEFFILE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/Singularity
VERBOSE2 SINGULARITY_ENVBASE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/env
VERBOSE2 SINGULARITY_LABELFILE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/labels.json
VERBOSE2 SINGULARITY_INCLUDECMD found as yes
VERBOSE2 SINGULARITY_PULLFOLDER found as /data2/containers/aaw702_test
VERBOSE2 SHUB_NAMEBYHASH not defined (None)
VERBOSE2 SHUB_NAMEBYCOMMIT not defined (None)
VERBOSE2 SHUB_CONTAINERNAME not defined (None)
VERBOSE2 SINGULARITY_CONTENTS found as /tmp/.singularity-layers.0X8et6si
VERBOSE2 SINGULARITY_PYTHREADS found as 9
VERBOSE2 SINGULARITY_CONTAINER found as docker://centos:centos6
DEBUG Found uri docker://
DEBUG
*** STARTING DOCKER IMPORT PYTHON  ****
DEBUG Docker layers and (env,labels,runscript) will be written to: /tmp/.singularity-layers.0X8et6si
VERBOSE2 SINGULARITY_DOCKER_USERNAME not defined (None)
VERBOSE2 SINGULARITY_DOCKER_PASSWORD found
DEBUG Starting Docker IMPORT, includes environment, runscript, and metadata.
VERBOSE Docker image: centos:centos6
VERBOSE2 Specified Docker CMD as %runscript.
DEBUG Headers found: Content-Type,Accept
VERBOSE Registry: index.docker.io
VERBOSE Namespace: library
VERBOSE Repo Name: centos
VERBOSE Repo Tag: centos6
VERBOSE Version: None
VERBOSE Obtaining tags: https://index.docker.io/v2/library/centos/tags/list
DEBUG GET https://index.docker.io/v2/library/centos/tags/list
DEBUG Http Error with code 401
DEBUG GET https://auth.docker.io/token?service=registry.docker.io&expires_in=9000&scope=repository:library/centos:pull
DEBUG Headers found: Content-Type,Authorization,Accept
VERBOSE3 Response on obtaining token is None.
Docker image path: index.docker.io/library/centos:centos6
VERBOSE Obtaining manifest: https://index.docker.io/v2/library/centos/manifests/centos6
DEBUG GET https://index.docker.io/v2/library/centos/manifests/centos6
DEBUG Image manifest version 2.2 found.
DEBUG Adding digest sha256:8b04204cfecd799ca315da5d0460363f2c114ed699bc0a2e023bb26fd85243ee
VERBOSE Obtaining manifest: https://index.docker.io/v2/library/centos/manifests/centos6
DEBUG GET https://index.docker.io/v2/library/centos/manifests/centos6
Cache folder set to /root/.singularity/docker
DEBUG Using 9 workers for multiprocess.
VERBOSE3 Found Docker command (Cmd) /bin/bash
VERBOSE3 Found Docker command (Entrypoint) None
VERBOSE3 Adding Docker CMD as Singularity runscript...
DEBUG /bin/bash
VERBOSE3 Found Docker command (Env) PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
VERBOSE3 Found Docker container environment!
VERBOSE3 Adding Docker environment to metadata tar
DEBUG Found template for tarinfo
VERBOSE3 Found Docker command (Labels) {u'build-date': u'20170705', u'vendor': u'CentOS', u'name': u'CentOS Base Image', u'license': u'GPLv2'}
VERBOSE3 Found Docker container labels!
VERBOSE3 Adding Docker labels to metadata tar
DEBUG Found template for tarinfo
VERBOSE3 Adding Docker runscript to metadata tar
DEBUG Found template for tarinfo
DEBUG metadata file /root/.singularity/metadata/sha256:60e3079474b1671bcc20b340572ee6cae735ecdd5a13d6686475ca4916eb6003.tar.gz already exists, will over-write.
VERBOSE2 Tar file with Docker env and labels: /root/.singularity/metadata/sha256:60e3079474b1671bcc20b340572ee6cae735ecdd5a13d6686475ca4916eb6003.tar.gz
VERBOSE3 Writing Docker layers files to /tmp/.singularity-layers.0X8et6si
VERBOSE2 Writing file /tmp/.singularity-layers.0X8et6si with mode w.
VERBOSE2 Writing file /tmp/.singularity-layers.0X8et6si with mode a.
DEBUG *** FINISHING DOCKER IMPORT PYTHON PORTION ****
Exploding layer: sha256:8b04204cfecd799ca315da5d0460363f2c114ed699bc0a2e023bb26fd85243ee.tar.gz
Exploding layer: sha256:60e3079474b1671bcc20b340572ee6cae735ecdd5a13d6686475ca4916eb6003.tar.gz
VERBOSE [U=0,P=45508]      message_init()                            Set messagelevel to: 5
DEBUG   [U=0,P=45508]      main()                                    Iterating through file looking for sections matching: %runscript
Finalizing Singularity container
VERBOSE2 SINGULARITY_COMMAND_ASIS found as False
VERBOSE2 SINGULARITY_ROOTFS found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container
VERBOSE2 SINGULARITY_METADATA_FOLDER found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d
VERBOSE2 SINGULARITY_FIX_PERMS found as False
VERBOSE2 SINGULARITY_COLORIZE not defined (None)
VERBOSE2 SINGULARITY_DISABLE_CACHE found as False
VERBOSE2 SINGULARITY_CACHEDIR found as /root/.singularity
VERBOSE2 SINGULARITY_ENVIRONMENT found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/environment
VERBOSE2 SINGULARITY_RUNSCRIPT found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/singularity
VERBOSE2 SINGULARITY_TESTFILE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/test
VERBOSE2 SINGULARITY_DEFFILE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/Singularity
VERBOSE2 SINGULARITY_ENVBASE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/env
VERBOSE2 SINGULARITY_LABELFILE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/labels.json
VERBOSE2 SINGULARITY_INCLUDECMD found as False
VERBOSE2 SINGULARITY_PULLFOLDER found as /data2/containers/aaw702_test
VERBOSE2 SHUB_NAMEBYHASH not defined (None)
VERBOSE2 SHUB_NAMEBYCOMMIT not defined (None)
VERBOSE2 SHUB_CONTAINERNAME not defined (None)
VERBOSE2 SINGULARITY_CONTENTS found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/.layers
VERBOSE2 SINGULARITY_PYTHREADS found as 9
DEBUG Adding label: 'SINGULARITY_DEFFILE' = 'dock.def'
DEBUG ADD SINGULARITY_DEFFILE from /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/labels.json
DEBUG SINGULARITY_DEFFILE is dock.def
VERBOSE2 Writing json file /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/labels.json with mode w.
VERBOSE2 SINGULARITY_COMMAND_ASIS found as False
VERBOSE2 SINGULARITY_ROOTFS found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container
VERBOSE2 SINGULARITY_METADATA_FOLDER found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d
VERBOSE2 SINGULARITY_FIX_PERMS found as False
VERBOSE2 SINGULARITY_COLORIZE not defined (None)
VERBOSE2 SINGULARITY_DISABLE_CACHE found as False
VERBOSE2 SINGULARITY_CACHEDIR found as /root/.singularity
VERBOSE2 SINGULARITY_ENVIRONMENT found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/environment
VERBOSE2 SINGULARITY_RUNSCRIPT found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/singularity
VERBOSE2 SINGULARITY_TESTFILE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/test
VERBOSE2 SINGULARITY_DEFFILE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/Singularity
VERBOSE2 SINGULARITY_ENVBASE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/env
VERBOSE2 SINGULARITY_LABELFILE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/labels.json
VERBOSE2 SINGULARITY_INCLUDECMD found as False
VERBOSE2 SINGULARITY_PULLFOLDER found as /data2/containers/aaw702_test
VERBOSE2 SHUB_NAMEBYHASH not defined (None)
VERBOSE2 SHUB_NAMEBYCOMMIT not defined (None)
VERBOSE2 SHUB_CONTAINERNAME not defined (None)
VERBOSE2 SINGULARITY_CONTENTS found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/.layers
VERBOSE2 SINGULARITY_PYTHREADS found as 9
DEBUG Adding label: 'SINGULARITY_BOOTSTRAP_VERSION' = '2.3.1-HEAD.ge214d4e'
DEBUG ADD SINGULARITY_BOOTSTRAP_VERSION from /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/labels.json
DEBUG SINGULARITY_BOOTSTRAP_VERSION is 2.3.1-HEAD.ge214d4e
VERBOSE2 Writing json file /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/labels.json with mode w.
VERBOSE2 SINGULARITY_COMMAND_ASIS found as False
VERBOSE2 SINGULARITY_ROOTFS found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container
VERBOSE2 SINGULARITY_METADATA_FOLDER found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d
VERBOSE2 SINGULARITY_FIX_PERMS found as False
VERBOSE2 SINGULARITY_COLORIZE not defined (None)
VERBOSE2 SINGULARITY_DISABLE_CACHE found as False
VERBOSE2 SINGULARITY_CACHEDIR found as /root/.singularity
VERBOSE2 SINGULARITY_ENVIRONMENT found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/environment
VERBOSE2 SINGULARITY_RUNSCRIPT found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/singularity
VERBOSE2 SINGULARITY_TESTFILE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/test
VERBOSE2 SINGULARITY_DEFFILE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/Singularity
VERBOSE2 SINGULARITY_ENVBASE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/env
VERBOSE2 SINGULARITY_LABELFILE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/labels.json
VERBOSE2 SINGULARITY_INCLUDECMD found as False
VERBOSE2 SINGULARITY_PULLFOLDER found as /data2/containers/aaw702_test
VERBOSE2 SHUB_NAMEBYHASH not defined (None)
VERBOSE2 SHUB_NAMEBYCOMMIT not defined (None)
VERBOSE2 SHUB_CONTAINERNAME not defined (None)
VERBOSE2 SINGULARITY_CONTENTS found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/.layers
VERBOSE2 SINGULARITY_PYTHREADS found as 9
DEBUG Adding label: 'SINGULARITY_DEFFILE_BOOTSTRAP' = 'docker'
DEBUG ADD SINGULARITY_DEFFILE_BOOTSTRAP from /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/labels.json
DEBUG SINGULARITY_DEFFILE_BOOTSTRAP is docker
VERBOSE2 Writing json file /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/labels.json with mode w.
VERBOSE2 SINGULARITY_COMMAND_ASIS found as False
VERBOSE2 SINGULARITY_ROOTFS found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container
VERBOSE2 SINGULARITY_METADATA_FOLDER found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d
VERBOSE2 SINGULARITY_FIX_PERMS found as False
VERBOSE2 SINGULARITY_COLORIZE not defined (None)
VERBOSE2 SINGULARITY_DISABLE_CACHE found as False
VERBOSE2 SINGULARITY_CACHEDIR found as /root/.singularity
VERBOSE2 SINGULARITY_ENVIRONMENT found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/environment
VERBOSE2 SINGULARITY_RUNSCRIPT found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/singularity
VERBOSE2 SINGULARITY_TESTFILE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/test
VERBOSE2 SINGULARITY_DEFFILE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/Singularity
VERBOSE2 SINGULARITY_ENVBASE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/env
VERBOSE2 SINGULARITY_LABELFILE found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/labels.json
VERBOSE2 SINGULARITY_INCLUDECMD found as False
VERBOSE2 SINGULARITY_PULLFOLDER found as /data2/containers/aaw702_test
VERBOSE2 SHUB_NAMEBYHASH not defined (None)
VERBOSE2 SHUB_NAMEBYCOMMIT not defined (None)
VERBOSE2 SHUB_CONTAINERNAME not defined (None)
VERBOSE2 SINGULARITY_CONTENTS found as /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/.layers
VERBOSE2 SINGULARITY_PYTHREADS found as 9
DEBUG Adding label: 'SINGULARITY_DEFFILE_FROM' = 'centos:centos6'
DEBUG ADD SINGULARITY_DEFFILE_FROM from /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/labels.json
DEBUG SINGULARITY_DEFFILE_FROM is centos:centos6
VERBOSE2 Writing json file /share/apps/centos7/singularity/2.3.1/var/singularity/mnt/container/.singularity.d/labels.json with mode w.
```
