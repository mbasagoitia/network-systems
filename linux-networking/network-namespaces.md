# Network Namespaces

Recall that **namespace** refers to what resources and naming of those resources a process sees (file descriptors, IP addresses). Namespaces create isolation in the kernel that allows processes to have their own namespace for these resources.

**cgroup** (control group) groups processes and allocates resources (CPU, memory) that the kernel enforces.

These concepts provide the isolation mechanisms that we need for containerization.

## Linux Namespaces

Kernel maintains data structures on a per-process basis (file system, process ID, etc.). The relevant one to us is the struct net, which contains all of the ipv4 forwarding data structures, the netfilter tables, etc.

Each namespace gets its own set of tables.