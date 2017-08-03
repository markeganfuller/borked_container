#!/bin/bash

SING=/share/apps/centos7/singularity/2.3.1/bin/singularity

cd /tmp

rm borked.img

echo "${SING} --version"
${SING} --version
echo "--------------------------------------"
echo "${SING} create borked.img"
${SING} create borked.img
echo "--------------------------------------"
echo "sudo ${SING} bootstrap borked.img /home/vagrant/singularity-containers/dock.def"
sudo ${SING} bootstrap borked.img /home/vagrant/singularity-containers/dock.def
echo "--------------------------------------"
echo "${SING} inspect borked.img"
${SING} inspect borked.img
echo "--------------------------------------"
echo "${SING} shell borked.img"
${SING} shell borked.img
echo "--------------------------------------"
echo "sudo ${SING} shell borked.img"
sudo ${SING} shell borked.img
