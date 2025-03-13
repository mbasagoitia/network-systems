# Virtualization Overview

Enterprise IT centers support many service applications, each of which demands its own environment, operating system, configurations, processors/disks, etc. Combining services on the same server host is difficult, with conflicting demands and incompatible loads. Upgrading or commissioning a service is very difficult. 

Virtualization solves these problems by decoupling the OS/service from the hardware. Can multiplex lightly-used services on common host hardware, migrate services from host to host as needed, and introduce new OS/service pairs as needed.

A **virtual machine** provides an interface identical to the underlying bare hardware, and the VM operating system (hypervisor) creates the illusion of multiple processors. Each is capable of executing independently, no sharing (except via network protocols), and clusters and SMP can be simulated.

Drawbacks of VMs are they are heavyweight--CPU, memory, disk for extra OS and full set of binaries and lots of overhead. OS traditionally assume they are directly on hardware (CPU arch has improved).

## Containers

What if we didn't need different operating systems? With containers, we introduce isolation mechanisms into and OS. OS has support for cgroups and namespaces.
