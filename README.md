# Python projects

A repository to execute Python projects in IOC container context.

#
Clone this pytorch fork (git clone --recursive https://github.com/micmelesse/pytorch)

git checkout to the fix_warpsize_issue branch

Run python3 tools/amd_build/build_amd.py

Run python3 setup.py build --cmake-only and then ccmake build. In the TUI for ccmake build, change AMDGPU_TARGETS and GPU_TARGETS to gfx1030. Press configure and then generate.

Run PYTORCH_ROCM_ARCH=gfx1030 python3 setup.py install. Takes a LONG time even on a 5900X.
