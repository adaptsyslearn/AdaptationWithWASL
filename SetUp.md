# A Guide to using the overall runtime system involving WASL

This guide provides the prerequisites and the steps required to setup the system as per Algorithms 1 and 2 in the paper.

## Code Organization

The following independent modules work in conjunction for the functioning of the overall runtime system (top-down as in Fig.5):

1. [apto-tailbench-apps](./apto-tailbench-apps/) -- Wrappers around an application [TailBench](https://github.com/adaptsyslearn/TailBenchMod)
   that profile specified parameters to the processing/activation layer (Apto).
2. [apto](./apto) -- A layer that application(s) and the system can use to process the profiled parameters, i.e. a rust implementation of the [GOAL](https://dl.acm.org/doi/pdf/10.1145/3563835.3567655) work.
3. [OptimizingController](./OptimizingController) -- Local adaptation module(s) for the system and the application.
4. [PoleAdaptation](./PoleAdaptation) -- The novel multi-module adaptation method WASL as proposed in Algo.2 of the paper.

Algo.1 (in the paper) involves 1, 2, and 3 above.

Interactions between the modules:

a. Applications connect to `apto-tailbench-apps` using a linux message queue to report performance information. <br>
b. `apto-tailbench-apps` sets up `apto` with a specific local adaptation method and an application goal. <br>
`apto-tailbench-apps` communicates the information it receives from the (tailbench) applications to `apto`. <br>
c. `apto` uses this information along with the `OptimizingController` for resource adjustments to achieve an application's goals. <br>
d. The `OptimizingController` (adaptation method) invokes WASL (`PoleAdaptation`) as and when needed to address multi-tenant (global) interference.

## Prerequisites

An user either needs *root* access (RECOMMENDED), or access to the binaries to read energy consumption data of the system.

Furthermore, depending on the users' preferences and knobs used by the users the applications and the underlying system modules need to be able to:
1. Toggle hyperthreading
2. Task affinity
3. Core Frequency (requires `scaling_governor` to be `userspace`)
4. Uncore Frequency

Therefore, running these experiments requires permission to manage all of the aforementioned quantities. Therefore, it is recommended to run these experiments on
a bare-metal machine and adjust the underlying drivers accordingly.

1. [Energymon](https://github.com/energymon/energymon): Install energy monitoring module with a suitable flag that is appropriate for the hardware being used. <br>
    Note that default installation provides dummy values that will not sense energy values for the underlying CPU hardware. <br>
    As an example, `cmake -DENERGYMON_BUILD_DEFAULT=rapl` can be used for RAPL energy monitor.
    For recent Linux kernels, *msr* kernel modules *may* need to be loaded with RAWIO permissions: <br>
    ```sudo modprobe msr``` <br>
    ```sudo setcap cap_sys_rawio=ep ./PATH/TO/BINARY``` <br>
    Please refer to [msr](https://github.com/energymon/energymon/tree/master/msr) for further information.
    These instructions only apply to modern Intel processors. <br>
    As a rule of thumb, users need to determine the appropriate energymon implementation for their platform.
3. [Rust](https://rust-lang.org/tools/install/): Use standard configuration that allow using `cargo`.
4. A [modified version](https://github.com/adaptsyslearn/TailBenchMod) of [TailBench](https://tailbench.csail.mit.edu/) provided with
   this repository and related tailBench inputs. This has to be correctly installed for the executables to work with our runtime system.


## Setup

1. Download all the repositories provided in this project into your chosen location
2. Update `Cargo.toml` files in `apto-tailbench-apps`, `apto` and `OptimizingController` accordingly.
3. Compile tailbench applications using the instructions provided.
4. Update the location of the tailbench binaries, application inputs, current directory and library paths
   in `apto-tailbench-apps/src/apps.rs` to reflect the relevant file paths. (IMPORTANT)
5. Compile `apto-tailbench-apps` using `cargo build --release --bin main` inside `apto-tailbench-apps` directory.

## Profiling applications

`apto` needs a `measuretable` for an application to adapt to an application's goals. <br>
`apto-tailbench-apps` can be used to obtain the `measuretable` (as in Table. 2 in the paper) after formulating a suitable `knobtable`. <br>

A `knobtable` is an enumeration of valid configurations (as in Table.3 in the paper) that `apto` can use. <br>
A sample `knobtable` for an application can be found in [./apto-tailbench-apps/knobtable](./apto-tailbench-apps/knobtable). <br>
Once this table is formed based on the available system resources, an application can be profiled as follows:

```
cd ./apto-tailbench-apps
$ cargo build --release --bin main
$ sudo RUST_LOG=info PROFILE=<NUMBER-OF-ITERATIONS> <APPLICATION-NAME>_PATH=<APPLICATION_BINARY_PATH> ./target/release/main --warmup-time <WARMUP-SECONDS> profile <APPLICATION-NAME>
```

This command outputs a file named `measuretable`.
It is recommended that the `knobtable` (kt) and `measuretable` (mt) be renamed to `<APPLICATION-NAME>.kt` and `<APPLICATION-NAME>.mt`, respectively.

Please note that an application profile is hardware-dependant. 
Therefore, users must profile each application independently before using the system.
The higher the number of iterations, the better the profile, as it will allow the profiler to capture the dynamics of the application and the underlying system more accurately.


## Running Adaptation-related Experiments

The overall runtime system executes all application(s) and system as modules. Each module is assigned a tag.
For a single application scenario, the application is always assigned the tag 0, while the system the tag 1.
For a multi application scenario, the applications are always assigned the tag 0 and 1, while the system the tag 2.

### Selecting Adaptation Method
An application or system is executed with specific (local) adaptation method.
This specification is controlled by environment variables as follows:
```
# Run with RL Reinforcement Learning (RL)-based adaptation
LEARNING_BASED_<TAG>=y CONF_TYPE_<TAG>=multi

# Run with Adaptive Control (AC) Module
CONF_TYPE_<TAG>=multi

# Run with PI control
CONT_TYPE_<TAG>=multi KP_<TAG>=<PROPORTIONAL_GAIN_VALUE>
```

### WASL Invocation by Adaptation Module(s)

An adaptive module can invoke WASL using environment variables as follows:
```
ADAPT_TYPE=linear ADAPT_INST=<LIST-OF-TAGS> DEV_TARGET=<GAMMA>
```

### Experimenting with Adaptation Module(s) for Application(s)

Finally, combine the aforementioned environment variables to run an experiment as follows:
```
cd ./apto-tailbench-apps/
cargo build --release --bin main

# Run one application and system with (centralized) monolithic coordination
sudo <ENVIRONMENT_VARIABLES> ./target/release/main --exec-time <EXECUTION-TIME-SECS> monolithic \
    <APPLICATION-NAME> <APPLICATION-TARGET>

# Run one application and system with multiple uncoordinated adaptation modules
sudo <ENVIRONMENT_VARIABLES> ./target/release/main --exec-time <EXECUTION-TIME-SECS> multimodule \
    <APPLICATION-NAME> <APPLICATION-TARGET>

# Run two applications and system with multiple uncoordinated adaptation modules
sudo <ENVIRONMENT_VARIABLES> ./target/release/main --exec-time <EXECUTION-TIME-SECS> multimodule \
    <APPLICATION-0-NAME> <APPLICATION-0-TARGET> \
    <APPLICATION-1-NAME> <APPLICATION-1-TARGET>
```
The resulting parameters for each iteration are printed to `stdout` and can be dumped to a file.
