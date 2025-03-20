# Linux Data Plane

Linux networking has a rich set of functionality--forwarding, NATing, filtering, bridging, load balancing, traffic shaping

Generic router architecture: packet arrives, lookup IP address in forwarding table, determine next hop, update header, queue in packet buffer for sending out a specific port. The key takeaway is that there is a pipeline of functions happening, with tables driving the processing.

Lots of protocol header parsing

Device drivers: communicate with network cards

Starts with recv function which parses headers (is this ARP, VLAN, bridge, IPv4, etc.?), forwarding (queuing discipline), transmits, goes to driver

Hook points for various NAT, filtering, etc.

Some sample utilities:

- iproute2: interfaces, bridges, forwarding
- iptables: classification, NAT, filtering
- tc (traffic control): queuing discipline
- ipvsadm: load balancing

How do these utilities interact with Linux?

**Netlink**: protocol that tells the kernel (data plane) how it should process the traffic
    - Built on Berkeley sockets
    - A socket is an abstract representation for the local endpoint of a network communication path
    - App puts data into socket, other app gets data from socket
    - Netlink sockets: each application is a client; servers run in kernel; supports multicast; libraries hide details

## Summary

Data plane: functions with tables organized in a pipeline
    - API for each function/table exposed through Netlink sockets

Utilities: provide abstractions for users to configure various aspects of the Linux data plane
    - Uses the API provided by the data plane through Netlink sockets