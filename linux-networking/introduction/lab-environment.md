# Lab Environment

Our goal is to create a topology of network devices, configure them, inject traffic, and troubleshoot.

## Vagrant

Enables the creation and configuration of lightweight, reproducible, and portable development environments. Vagrantfile, which is a configuration file, specifies the Linux distribution and other config scripts to install needed software. Runs on top of virtualization software such as VirtualBox. 

Vagrantfile includes Linux disribution, CPU/RAM allocation, and tool installation such as Docker, net-tools, containerlab.

### Starting the VM

Run "vagrant up" in directory with the Vagrantfile to start the virtual machine, install Linux distribution, etc.

### Shutting Down VM

- "vagrant suspend": saves the state and turns off the VM
- "vagrant resume": starts the VM again and continue from the same state 
- "vagrant halt": shuts down the VM
- "vagrant status": checks the status of all VMs

### Connecting to the VM with SSH

**SSH** (secure shell) protocol is a cryptographic network protocol for operating network services securely over an unsecured network. Its most notable applications are remote login and command line execution.

We (client, host operating system) connect to the VM (server) using SSH. Need a private key to connect to the server using its public key. Vagrant handles this for us.

"vagrant ssh config": shows filepath to private key and other information (host, port, etc.) for the ssh server

Next, configure the ssh client (such as Mobaxterm). You will need:

- Hostname/IP address: 127.0.0.1
- Port number: 2222
- Username: vagrant
- Private key: path_to_private_key
- You will want x11 forwarding on

## Containers and Docker

VMs run on a software layer known as the hypervisor that makes it possible to run multiple, independent operating systems on the same server, each with separate dependencies. This way, we can avoid interference between packages, variable workloads, OSs, etc. Reduces resource wastage; allows us to run multiple applications on the same server.

Some drawbacks to virtualization is that they are resource-intensive with a lot of overhead to run VMs. So, next came containers.

If we don't need different operating systems, introduce isolation mechanisms inside of the OS (Linux). May have different distributions, dependencies

2 key mechanisms inside of the Linux kernel are **namespace** (what resources and naming of those resources a process sees, such as file descriptors and IP addresses) and **cgroup** (control group; groups processes and allocates resources such as CPU and memory that the kernel enforces). This is more efficient than virtualization alone.

Docker brought about packaging around container technology and made it usable.

A **container** is a temporary file system that is layered over an image, fully writably (copy on write), and disappears when end of life. Each container has its own network stack and a process group with one main process and possible subprocesses.

### Docker Architecture

- Client
    - Docker: an executable that interacts with the docker daemon to execute docker commands
        - Docker run, docker build, docker pull
- Host
    - Running containers. A container is a process that runs its own namespace (file directory structure, resources, file descriptors, etc.) that can be in the running, stopped, or paused state
    - Images: immutable snapshot of a filesystem; a collection of files/directories such as /bin/ls, /etc/ssh/sshd_config, used as the initial collection of files within a container's namespace
    - Docker daemon: runs on each machine you want to run containers on. Manages the images and starting processes and interfacing to the cgroups and namespaces. Can be used to build images locally (snapshot running containers or using a docker build system).
- Registry
    - A storage for images and enables an interface to push/pull images to/from a local host (API). Examples include Docker hub.

## Containerlab

Provides a CLI for orchestrating and managing container-based networking labs. Starts containers, builds the virtual wiring between them to create lab topologies of user's choice and manages lab's lifecycle.