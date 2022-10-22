# OpenAI experimentation

[![Build and release PyTorch pipeline](https://github.com/andyholst/openai-experimentation/actions/workflows/pytorch_build_release.yaml/badge.svg)](https://github.com/andyholst/openai-experimentation/actions/workflows/pytorch_build_release.yaml)
[![Train Sonic skills CI pipeline](https://github.com/andyholst/openai-experimentation/actions/workflows/train_sonic_agent.yaml/badge.svg)](https://github.com/andyholst/openai-experimentation/actions/workflows/train_sonic_agent.yaml)
[![Verify trained Sonic agent skills CI pipeline](https://github.com/andyholst/openai-experimentation/actions/workflows/verify_trained_sonic_agent.yaml/badge.svg)](https://github.com/andyholst/openai-experimentation/actions/workflows/verify_trained_sonic_agent.yaml)
[![Verify Sonic skills CI pipeline](https://github.com/andyholst/openai-experimentation/actions/workflows/verify_sonic_skills.yaml/badge.svg)](https://github.com/andyholst/openai-experimentation/actions/workflows/verify_sonic_skills.yaml)

A repository to experiment with machine learning projects in a IOC container context mainly in Python and with the
PyTorch machine learning framework. Experimenting with retro games like Sonic the Hedgehog.

## Trained Sonic agent for specific game levels

### SonicTheHedgehog-Genesis_on_state_GreenHillZone_Act1_NORMALIZED_PPO_CnnPolicy

#### Neural network depth: 2048, learning rate: 0.000001

##### CPU:

```
  processor     : 0
  vendor_id     : GenuineIntel
  cpu family    : 6
  model         : 94
  model name    : Intel(R) Core(TM) i7-6920HQ CPU @ 2.90GHz
  stepping      : 3
  microcode     : 0xf0
  cpu MHz               : 2900.000
  cache size    : 8192 KB
  physical id   : 0
  siblings      : 8
  core id               : 0
  cpu cores     : 4
  apicid                : 0
  initial apicid        : 0
  fpu           : yes
  fpu_exception : yes
  cpuid level   : 22
  wp            : yes
  flags         : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nonstop_
tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault epb invpcid_s
ingle pti ssbd ibrs ibpb stibp tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid mpx rdseed adx smap clflushopt intel_pt xsaveopt xsavec xgetbv1 xsaves dtherm ida arat pln pts hwp hwp_notify
 hwp_act_window hwp_epp md_clear flush_l1d arch_capabilities
  vmx flags     : vnmi preemption_timer invvpid ept_x_only ept_ad ept_1gb flexpriority tsc_offset vtpr mtf vapic ept vpid unrestricted_guest ple shadow_vmcs pml
  bugs          : cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf mds swapgs taa itlb_multihit srbds mmio_stale_data retbleed
  bogomips      : 5802.42
  clflush size  : 64
  cache_alignment       : 64
  address sizes : 39 bits physical, 48 bits virtual
  
  Training time: 3d 18h 43m 9s
```

#### AMD:

```
ROCm version: 5.2.3
GPU model: gfx803 

Training time: 22h 52m 21s
```
