# Load Balancing

A load balancer serves as the point of entry for a service and directs traffic to one of N servers that can handle the request. Use for both scaling and resilience.

## Key Properties

- Algorithm
    - Client initiates connection
    - Load balancer must select which server to forward the request to

- Server set
    - Which servers are part of the set to choose from
    - May include liveness checks (through heartbeats)

## Application Load Balancer (L7) vs Network Load Balancer (L4) in GCP

- Choose an application load balancer when you need a flexible feature set for you applications with HTTP and HTTPS traffic.

- Choose a network load balancer when you need TLS offloading at scale, support for UDP, and exposing IP addresses to your applications.

Recall that the transport layer (L4) enables process-to-process, reliable in-order stream.

An application layer (L7) protocol defines:

- Message syntax: what fields, how fields are delineated
- Types of messages exchanged: e.g. request, response
- Message semantics: meaning of information in fields

Layer 4 considers network (IP) and transport (TCP) headers
    - Can passthrough the traffic
    - Routing consideration: how to balance load, and may ensure flow affinity

Layer 7 also considers application (HTTP) header
    - Also called web proxy
    - Terminates the TCP connection
    - Routing consideration: can also direct specific URLs to specific servers

## Internal vs External Load Balancing

External: associated with public IP address, directs to web tier front end

Internal: between applications
    - With internal network load balancer, forwarding rules can be handled with Andromeda (which is the virtual switch running on each host)

## Other Systems in GCP

- Envoy: for application layer load balancing (internal or external)
- Maglev: for network load balancer (from external)