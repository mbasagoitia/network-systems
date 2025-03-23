# Microsoft's Software-Driven WAN (SWAN)

Cloud providers have many datacenters and many layers to their networks.

Inter-datacenter WAN is a critical, expensive resource (subsea fiberoptic cables and network equipment are very expensive). This is highly inefficient:

- Lack of coordination - can we control and schedule background traffic around non-background traffic
- Local, greedy resource allocation (worse than globally optimal allocation)

## Goals of SWAN

- Highly-efficient WAN
- Support flexible sharing policies
    - Strict priority classes
    - Max-min fairness within a class

## Key Design Elements

- Coordinate the sending rate of services
- Centralized resource allocation

Centralized Swan controller implements:

- **Traffic demand**; can tell individual hosts (controls packet forwarding on each host) to do rate limiting (control over bandwith allocation)

- **Topology and traffic** information is received, and programs individual flows of traffic to be able to directly control forwarding within WAN

## Design Challenges

- Scalably computing bandwitch allocation and network configuration
- Avoiding congestion during network updates
- Working with limited switch memory
    - Use tunnel-based forwarding
    - Install only the "working set" of tunnels
    - Efficient mechanisms to update the set

Showed that throughput of SWAN was near optimal (definitely better than standard routing)

## Legacy Networks vs SDN

Legacy:

- Beefy interconnected routers
- Control plane: distributed, on-board
- Data plane: indirect configuration

SDN:

- Streamlined switches
- Control plane: centralized, off-board
- Data plane: direct configuration

## SWAN Summary

- Yields a highly-efficient and flexible WAN
    - Coordinates transmissions of services
    - Allocates resources centrally
    - Manages transitions by using scratch link and memory capacity

- High efficiency is key to cost-effective cloud services
    - Many avenues for impactful research
    - Opportunity to be "clean slate"