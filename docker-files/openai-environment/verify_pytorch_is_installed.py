import os
import torch

ROCM_ARCH = os.getenv('ROCM_ARCH')

print('PyTorch version is: ' + torch.__version__)

if ROCM_ARCH:
    if not torch.cuda.is_available():
        raise SystemError('ROCm feature not correctly installed with PyTorch.')

    print('Number of CUDA devices are: ' + str(torch.cuda.device_count()))
    torch.cuda.get_device_name()
    for i in range(torch.cuda.device_count()):
        print('CUDA device: ' + torch.cuda.get_device_name(i))
