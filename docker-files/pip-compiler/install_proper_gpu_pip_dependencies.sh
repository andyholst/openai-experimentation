#!/usr/bin/env bash

# TODO: Resolve how to install the proper CUDA/ROCM pytorch dependencies
#sed -i 's/torch==.*/torch==1.11.*/g' "${IN_REQUIREMENTS}"
#sed -i 's/torchvision==.*/torchvision==0.11.*/g' "${IN_REQUIREMENTS}"
#
#lspci | grep -i amd
#
#if [ $? -eq 0 ]; then
#  sed -i 's/torch==.*/torch==1.10.1+rocm4.2/g' "${IN_REQUIREMENTS}"
#  sed -i 's/torchvision==.*/torchvision==0.11.2+rocm4.2/g' "${IN_REQUIREMENTS}"
#fi
#
#lspci | grep -i nvidia
#
#if [ $? -eq 0 ]; then
#  sed -i 's/torch==.*/torch==1.10.1+cu111/g' "${IN_REQUIREMENTS}"
#  sed -i 's/torchvision==.*/torchvision==0.11.2+cu111/g' "${IN_REQUIREMENTS}"
#fi
