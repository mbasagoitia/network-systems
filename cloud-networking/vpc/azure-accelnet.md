# Azure's AccelNet (SmartNIC)

Azure also uses a virtual switch. Went one step further to improve performance.

Virtual Filtering Platform (VFP)

- Virtual switch for Hyper-V/Azure
- Provides core SDN functionality for Azure networking services, including address virtualization for VNET, VIP -> DIP translation for SLB, ACLs, metering, and security guards
- Uses programmable rule/flow tables to perform per-packet actions
- Programmed by multiple Azure SDN controllers, supports all dataplane policy at line rate with offloads

Key primitive: Match action tables inspired by OpenFlow

- VPF exposes a typed match-action table API to the agents/controllers
- One table (layer) per policy
- Designed for multi-controller, stateful, scalable host SDN applications

Unified flow tables - a fast path through VFP

- Sequences of table lookups are expensive; we only need to do that once (first packet in a flow/connection since all packets should be handled the same way)
- Transposition engine converts first packet into a single hash lookup (cheap vs rule lookups) and all actions are available in one lookup

Scaling up SDN: NIC speeds in Azure

We got a 50x improvement in network throughput, but not a 50x improvement in CPU power.

Example ASIC solution: Single Root IO Virtualization (SR-IOV) gives native performance for virtualized workloads. But where is SDN policy?

Silicon alternatives such as CPU, GPU, FPGA

## CPU vs FPGA

CPU: temporal compute (one set of instructions at a time)
FPGA: spatial compute (instructions operating in parallel)

FPGA:

- Field programmable gate array
- Chip has large quantities of programmable gates - highly parallel
- Program specialized circuits that communicate directly
- Two kinds of paralellism:
    - Thread-level parallelism (stamp out multiple pipelines)
    - Pipeline parallelism (create one long pipeline storing many packets at different stages)
- FPGA chips are now large SoCs (can run a control plane)

Amazon's solution: Azure SmartNIC (FPGA)

- HW is needed for scale, performance, and COGS at 40G+
- 12-18 month ASIC cycle + time to roll new HW is too slow
- To compete and react to new needs, we need agility: SDN
- Programmed using generic flow tables
    - Language for programming SDN to hardware
    - Uses connections and structured actions as primitives
- First packet processed in the virtual switch software
- Instead of transposing subsequent packets into a table, can mirror that table in the FPGA where packet processing is performed. SmartNIC communicates directly with guest's VM