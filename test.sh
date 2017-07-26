#!/bin/bash

if [ ! -f ./borked.img ]; then
    echo "Uncompressing image first."
    gunzip -c borked.img.gz > borked.img
fi

echo "singularity --version"
singularity --version
echo "--------------------------------------"
echo "singularity inspect borked.img"
singularity inspect borked.img
echo "--------------------------------------"
echo "singularity shell borked.img"
singularity shell borked.img
echo "--------------------------------------"
echo "sudo singularity shell borked.img"
sudo singularity shell borked.img
