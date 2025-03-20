# Linux Utilities for IP Layer

Internetworking enables communication between multiple, heterogeneous networks. The key is a router (gateway) at the edge of each network.

Utilities:

- ip addr: used to display, add, remove, change addresses of devices (ex. ip addr add dev eth1 10.0.1.2)
    - Each device must have at least one address to use the corresponding protocol
    - It is possible to have several different addresses attached to one device
- ip route: utility for Linux forwarding table management
    - ip route { add, del, change, append, replace } ROUTE
        - ROUTE consists of NODE_SPEC and optional INFO_SPEC
    - ex. ip route add 11.11.0.0/16 dev eth3 <- adds an entry to the routing table
- What does via do?
    - ex. ip route add 11.11.0.0/16 via 192.168.2.1 dev eth3 
    - via indicates that there is a hop between devices at the IP layer (next hop is not the destination, but a router at that MAC address)
- ip neigh: neighbor/arp table management utility
    - ex. ip neigh show, add, flush, etc. <- shows arp protocol and neighbors (mapping IP addresses to MAC addresses)

## Role of a Router

- Routing: compute paths by coordinating with neighbors. Uses protocols like LPM (longest prefix match) to figure out next hop
- Forwarding: direct traffic to a destination