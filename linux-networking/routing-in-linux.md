# Routing in Linux

Recall that BGP (Border Gateway Protcol) is the protocol used to coordinate between many interconnected autonomous systems in the internet.

**Peering** is a key concept in BGP where routers will "peer" with neighbors, establish a TCP connection, establish some properties about each other (AS number, capabilities, etc.), and state machine leads to "established" state once peered. They can now exchange routing information to update routing tables and forward traffic.

Message exchange: announcement tells neighbors of the availability of a path to some destination and withdrawals tells neighbors that a route is no longer available (such as failure).

Each BGP router will independently make the "best" choice from all routes to announce to neighbors. Factors include local preference (you can manually configure), AS path length, multiple exit discriminator, eBGP over iBGP, shortest IGP path cost, router ID.

## Linux Routing Software

- Quagga
- Bird
- FRR
- GoBGP

## Routing with Bird

birdc allows you to interact with running bird protocols

- rtrA birdc show protocols
- rtrA birdc show route all