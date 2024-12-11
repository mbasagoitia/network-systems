# Local Area Network

Extending beyond the physical limits of the transmission medium

## Ethernet

**Switching** solves the problem of scalability problems with shared cable between nodes in a network. It uses point-to-point full duplex links and switches (special nodes) to direct traffic to its destination.

Each switch contains a MAC address table which maps destination addresses to output ports. The switch receives a frame, looks up the destination, and sends the frame.

How does this table get filled? 

### MAC Table Learning

When a switch receives a frame, it learns the source is at that port. If the destination is unknown, it floods to all ports and all but the actual destination will ignore it. If the destination node replies, the switch will learn the address on that port.

### Topology of Switches

Switches are limited in the number of ports, so we can extend with a topology of switches. A potential problem with this is loops when flooding. This can be solved by keeping track of messages seen, limiting the number of hops a message can take, turning off links that create the loop (such as with Spanning Tree Protocol), and architecting the network so that loops won't occur (avoid broadcasts and flooding).

## Wireless LAN

The special nodes are access points, commonly connected to a wired network. All traffic goes via the access points, even if nodes are in range. The challenge here is associating with an access point.