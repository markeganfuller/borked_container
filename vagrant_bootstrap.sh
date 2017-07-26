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

# Download and install singularity
git clone https://github.com/singularityware/singularity.git
cd singularity
./autogen.sh
./configure --prefix=/usr --sysconfdir=/etc
make
make install

# Cleanup
cd ..
rm -rf ./singularity
