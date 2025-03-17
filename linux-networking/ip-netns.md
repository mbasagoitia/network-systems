# ip netns

Linux utility for working with network namespaces

Processes inherit from parent (starting with the root/default namespace).

Commands:

- ip [OPTIONS] netns { COMMAND | help }

- ip netns [ list ]
- ip netns add NETNSNAME
- ip netns attach NETNSNAME PID
- ip [-all] netns del [ NETNSNAME ]
- ip netns set NETNSNAME NETNSID

## General Process

Setup:

- create network namespace
    - sudo ip netns add NAME
    - sudo ip netns list <-- lists network namespaces 
- create veth (virtual ethernet) pair. Always create in interconnected pairs (like two ends of an ethernet cable).
    - sudo ip link add <p1-name> type veth peer name <p2-name>
    - ip link <-- see both devices
    - ip link set dev <p1-name> up
    - ip link set dev <p2-name> up

    - if you need to find index of a veth interface, run ethtool -S <name>
- attach veth devices to a namespace
    - sudo ip link set <p2-name> netns <p2-ns>

- see links with ip link

Now, the device is no longer in the root namespace but in the new one you created.

You can connect two namespaces by attaching the other end of a veth pair to another namespace.

Then:

- execute commands inside namespace
- use Linux networking

To execute commands inside of a namespace, run ip netns exec <netns> <command>

Examples:

- set an address on each veth device and ping between them
    - ip netns exec nsDemo ip link
    - ip netns exec nsDemo ip addr add 10.10.10.10/24 dev vethZ
    - ip netns exec nsDemo ip link set vethZ up

    - ip addr add 10.10.10.11/24 dev vethY
    - ip netns exec nsDemo1 ping 10.0.0.1
    - ip netns exec nsDemo tcpdump -i vethZ

To move a veth device out of a namespace, run ip netns exec <ns-name> ip link set <device-name> netns 1 <-- 1 is the default/root ns

Note that the -n option replaces netns exec, so you can just run ip -n <ns-name> <command>

## Networking Between Namespaces

Case 1: Connecting Together with a Bridge

General steps:

- Create the network namespaces (ns1, ns2, ns3)
- Create the veth pairs (vethA and vethB, vethC and vethD, vethE and vethF)
- Attach one end of each pair to a netns (vethB in ns1, vethD in ns2, vethF in ns3)
- Bring all devices in root ns up (vethA, vethC, vethE), then devices in separate ns up (vethB in ns1, vethD in ns2, vethF in ns3)
- Create the bridge and bring it up
    - sudo ip link add mybridge type bridge
    - sudo ip link set dev mybridge up
- Attach the other end of each pair (in root ns; vethA, vethC, and vethE) to the bridge
    - sudo ip link set vethA master mybridge (and repeat for vethC and vethE)
- Add addresses to the devices (vethB, vethD, vethF) and enable them to ping one another
    - sudo ip netns exec ns1 ip addr add 10.0.0.1/24 dev vethB
    - sudo ip netns exec ns2 ip addr add 10.0.0.2/24 dev vethD
    - sudo ip netns exec ns3 ip addr add 10.0.0.3/24 dev vethF

You can check ip addresses and routes with ip addr (inside of each netns) and ip route

To ping:

- sudo ip netns exec ns3 tshark -i vethF <-- runs tshark inside of ns3 and captures traffic on vethF
- sudo ip netns exec ns1 ping -c 4 10.0.0.3 <-- from vs1, pings vethF inside of ns3 with a count of 4

Case 2: Connecting to External World (port forwarding)

We will use a second VM to represent the external world.

General steps:

- Create 2 network namespaces
- Create 2 veth pairs
- Attach one end of each pair to a network namespace
- Bring veths up
- Add routing in host to direct traffic to vethA or vethC
- Add IP addresses to each of the veths inside the namespaces
- Set default routes within each namespace
- Set iptables rules (port forwarding)