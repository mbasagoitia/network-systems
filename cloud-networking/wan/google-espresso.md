# Google's Espresso

Google's system for peering with external networks; VPC to internet/end user communication.

Problem statement: 

Very high volumes of traffic to send to internet peers (high definition video, cloud traffic, etc.)

1. Need to optimize traffic per customer and per application (optimal video quality or differentiated service for cloud)
    - Problem: constrained by BGP shortest path and lack of application awareness
2. Deliver new features quickly
    - Problem: router-vendor feature cycles and qualification take many years

**Espresso** leverages software-defined networking with Peering Edge

Peering edge requires interoperability with heterogeneous peers

## Design Principles

1. Hierarchical control plane
    - Global optimization while local control plane provide fast reaction
2. Fail static
    - Local control plane continues to function without global controller failure
3. Software programmability
    - Externalize features into software to exploit commodity servers for scale
4. Testability
5. Manageability

Architecture: reliability and scale of BGP

More software-oriented process that includes BGP speakers and label-switched fabric. Many BGP speakers run on standard host servers.

Architecture: externalize packet processing

Host-based packet processor allows flexible packet processing, including ACL and handling of DoS

Architecture: hierarchical control

Global controller and location control that interconnects with peering fabric control

Architecture: application aware routing

Google "knows" what traffic is happening through application signals which are sent to global controller. This allows for using the user's best path, not BGP's. This is a more optimal solution (application aware manner) than BGP's best path approach. Helps capacity-constrained ISPs by overflowing demand to alternate paths within local metro and also via remote metros.

Provides better end user experience

Espresso demonstrates that:

- Traditional peering architecture can evolve to exploit SDN
- SDN's value is in flexibility and feature velocity

Router-centric protocols (old):

- Local view
- Connectivity-based optimization
- Slow evolution
- Costly

Espresso SDN Peering:

- Global view
- Application signals-based optimization
- Rapid deploy-and-iterate
- 75% cheaper