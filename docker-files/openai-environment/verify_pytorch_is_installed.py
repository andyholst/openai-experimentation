import os

import torch

ROCM_ARCH = os.getenv('ROCM_ARCH')

if not torch.__version__:
    raise SystemError('PyTorch not successfully installed.')

if ROCM_ARCH:
    if not torch.cuda.is_available():
        raise SystemError('ROCm feature not correctly installed with PyTorch.')

    print('Number of CUDA devices are: ' + str(torch.cuda.device_count()))
    for i in range(torch.cuda.device_count()):
        print('CUDA device: ' + torch.cuda.get_device_name(i))
