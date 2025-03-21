# Google's Andromeda

Andromeda is the method for realizing the VPC abstraction in Google's infrastructrure.

How does Google achieve network virtualization?

Goals:

- Performance and isolation
    - High throughput and low latency, regardless of the actions of other tenants
- Velocity
    - Quickyl develop and deploy new features and performance improvements
- Scalability
    - Large networks, many tenants, rapid provisioning

Architecture:

VM Controller -> OpenFlow Front End (centralized controllers) -> Virtual Switches (data plane) on VM Host (which hosts many VMs)

When a new VM is added, install flows from other VMs to the new VM and install rules/flows from the new VM to other VMs in the network.

Noticed that programming took very long time, quadratic

Introduction of scaling with hoverboards; offloads load priority flows. Instead of having a rule for every VM to VM communication on every virtual switch, have only high priority/most active traffic flows on virtual switch and everything else redirected to hoverboard. **Hoverboard model** avoids programming long tail of mostly idle flows on VM host. Very scalable. All rules are programmed onto hoverboard. Greatly reduces time to program network connectivity for large networks. Today, more than 99.5% of traffic is offloaded.

Andromeda Data Plane:

Andromeda Fast Path (routes packet, applies per-flow Fast Path actions (encap, decap, etc.)) which uses **OS bypass**, busy polling dedicated CPU Fast Pass for high performance. Also runs guest VM coprocessor (per-VM attributed threads for executing CPU-intensive packet operations)

Other features:

Rapid release cycle of features and bug fixes via nondisruptive upgrades (weekly)

Live migration allows VMs to be migrated between physical host without distruption (such as for host maintenance). Old data plane state is transferred to new dataplane in the background while old dataplane continues serving physical NIC and virtual NIC queues. Very fast blackout time (270 ms). New dataplane starts serving VM virtual NIC and physical NIC cues and old dataplane is terminated.