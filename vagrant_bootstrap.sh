#!/bin/bash

# Update box
yum update -y

# Install build requirements
yum groupinstall "Development Tools" -y
yum install git

# Install requirements for building deb images
yum install epel-release -y
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
yum install debootstrap -y

# Install singularity
cp ./singularity-containers/install.tgz .
tar -xzvf install.tgz
rm install.tgz
setfacl --restore=./singularity-containers/facl
mv share /
