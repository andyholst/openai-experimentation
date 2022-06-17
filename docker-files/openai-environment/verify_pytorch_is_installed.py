import os

import torch

ROCM_ARCH = os.getenv('ROCM_ARCH')

if not torch.__version__:
    raise Exception('PyTorch not currently installed.')

if ROCM_ARCH:
    if not torch.cuda.is_available():
        raise Exception('ROCm feature not correctly installed with PyTorch')
