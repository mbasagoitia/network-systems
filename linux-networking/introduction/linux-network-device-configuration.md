# Linux Network Device Configuration (IP Link)

Goal: Network device configuration

Types of devices:

- Physical interfaces (ethernet)
- Attach to another device (vlan)
- Connect together multiple devices (bridge, bond)
- Tunnel traffic (vxlan, geneve)
- Virtual devices (veth)

IP Link is a part of the "toolbox" iproute2, used for network device configuration for Linux

Key commands:

- show
- set
- add
- delete

Examples:

- ip link show: displays device attributes; can add additional options such as DEVICE, group GROUP, master DEVICE, etc.
- ip link set: change state/configuration of an already existing device; address, up, down, etc.
- ip link add: adds a virtual link/device; recall different types of devices above. Each device uses ip link add differently and has specific options.

Example: Bridge

Device that effectively implements a learning switch. You create the bridge device, then makes devices slaves to the bridge.

Commands:

ip link add name mybridge type bridge
ip link set mybridge up
ip link set eth1 master mybridge
ip link set eth2 master mybridge
ip link set eth3 master mybridge

Example: VLAN

Device that adds VLAN tagging; enables isolation (traffic) in a shared L2 network. Specific groups could each get their own unique vlan id. This happens "on top of" a physical network device such as a switch. So here, we will specify the ethernet device to associate the vlan with.

Commands:

ip link add link eth0 name eth0.2 type vlan id 2 <- naming convention for the vlan is eth0.<vlan id> e.g. eth0.2

Example: Tunnel (geneve, vxlan)

Tunnels encapsulate traffic for transmission over some network.

Commands:

ip link add name gen0 type geneve id 55 remote 1.2.3.4 <- destination IP address

Example: Deleting a tunnel

ip link delete dev eth0.2

## Demo Setup

Show nothing running in Docker: docker ps

Show containerlab configuration: vi 2node-mod1.clab.yml

Create lab: sudo containerlab deploy

Aliases for docker commands: vi make_aliases.sh ... source make_aliases.sh <- this makes it so you don't have to run docker exec -it <container name> <command> each time. Now you simply run <alias> <command>

Go over the scapy code to craft a packet: vi onepkt.py