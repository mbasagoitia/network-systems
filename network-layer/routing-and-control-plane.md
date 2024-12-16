# Routing and Control Plane

The key function of the control plane is calculating the forwarding table.

## Centralized Control Plane (Software-defined Networking)

Newer concept

- Central controllers know entire topology and makes decision for entire network
- Routers become just the data plane


## Distributed Routing

The network can be viewed as a graph. Routing involves distributed calculations in the **decentralized control plane** where each router runs some control plane software and communicates with its neighbors in order to choose paths in the network. Different protocols for this exist and are distinguished in the following ways:

- What info each router knows (entire topology or just its neighbors)
- What info each router exchanges (all routes or single route)
- What calculation is performed (shortest path or what's locally best)

# Routing Protocols

## Link State Protocol: OSPF (Intra-domain)

Widely used in LANs. 

Process:

- Each router establishes peering with its neighbors
- Link states are flooded to entire network (links exchange state information) until network reaches convergence (links have learned entire topology and all agree on the state of the network)
- Each router calculates shortest path to every other node/router (Dijkstra's algorithm) where "weights" may be link bandwith, latency, etc. to build forwarding table
    - Builds shortest path tree from node to every other node
    - From this constructs forwarding table

What is a link state?

- Connection to other routers; tells who the neigbor is
- Connection to network with end hosts; tells prefixes reachable

### Changes in the Network

- New neighbor
- Failure of a link
- Adding a prefix

Since all of these are changes in the link state, link state updates are sent (until convergence) and the process repeats (calculate shortest path; update forwarding table)

## Path Vector Protocol: BGP (Border Gateway Protocol) (Inter-domain)

iBGP (internal) and eBGP (external)

Used in the context of many interconnected networks called autonomous systems (the internet).

Process:

- Peer with neighbors
- For any route update, failure event, or config change:
    - Update routing table (list of known routes)
    - Perform locally best route calculation for that prefix
    - If any change, send update to neighbors (withdraw/update routes if needed)

**Route**: path to a prefix

**Path**: sequence of autonomous systems

### BGP Policies (and the Internet Business)

- Provider is paid money to transit traffic
- Customer pays money to a provider to have its traffic carried
- Peer: financially neutral arrangement where two autonomous systems connect to each other and will send traffic through each other
- BGP policies control what is being announced 

Best path calculation:

Prioritized list

- Local preference
- AS path length
- Multiple exit discriminator
- eBGP over iBGP
- Shortest iBGP path cost
- Router ID