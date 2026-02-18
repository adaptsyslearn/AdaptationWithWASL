# Multi-module Adaptation With WASL

This repo contains source code and other artifacts related to the paper 
*WASL: Harmonizing Uncoordinated Adaptive Modules in Multi-Tenant Cloud Systems*.
WASL is a rate-adaptation based technique for runtime cross-layer coordination
in multi-tenant clouds to mitigate performance interference arising due to
multiple colocated adaptive applications.

DOI Reference: [Zenodo](https://doi.org/10.5281/zenodo.18415164)

TailBench applications have been used for evaluation.
Tailbench details are [here](https://github.com/adaptsyslearn/TailBenchMod).<br>
TailBench      : Updates to standard TailBench suite used for experiments

### Require Bare-Metal Instances:

Could VMs that are not bare-metal instances will not work for this system. <br> 
Bare-metal hardware resources are needed for Energy Monitoring and Frequency Scaling.<br>

### p_state drivers:

Many Intel processors have *active* mode enabled by default for *intel_pstate* driver.<br> 
For managing CPU frequencies in this work, *passive* mode is needed; *hardware managed P_State (HWP)* support has to be disabled. <br>
``` echo "passive" > /sys/devices/system/cpu/intel_pstate/status``` <br>

Further information can be reference [here](https://www.kernel.org/doc/html/v5.3/admin-guide/pm/intel_pstate.html). 

The SetUp instructions are available [here](https://github.com/adaptsyslearn/AdaptationWithWASL/blob/main/SetUp.md). 


### Code Structure
```bash
/                           : Overall Runtime System
|-- apto-tailbench-apps     : Wrapper/Profiler for Application/System
|-- apto-tailbench-apps/scripts : Helper scripts for profiling/parsing
|-- apto                    : Processing and Activation,
                              coordination with the Adaptation Module
|-- OptimizingController    : Adaptation Module (local)
|-- PoleAdaptation          : WASL-based Multi-Module Adaptation (global)
|-- SetUp.md                : Readme about the setup of the overall system
|-- Plots                   : Scripts related to some results
```

Each folder has its own *Readme* file.

## Citation

The following paper can be cited:

```
@inproceedings{DBLP:conf/icpe/Pervaiz26,
  author       = {Ahsan Pervaiz, Anwesha Das, Vedant Kodagi,
                  Muhammad Husni Santriaji, Henry Hoffmann},
  title        = {WASL: Harmonizing Uncoordinated Adaptive Modules
                  in Multi-Tenant Cloud Systems},
  booktitle    = {International Conference on Performance Engineering, {ICPE}},
  publisher    = {{ACM/SPEC}},
  year         = {2026}
}
```
