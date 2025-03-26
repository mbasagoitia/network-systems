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

## Global vs Regional Load Balancers

Global: workloads in more than one region

Regional: workload is all in the same region

Depends on standard vs premium tier in GCP

- Egress in standard tier: traffic exits Google network near source (PoP - points of presence) and then traverses the internet.

- Egress in premium tier: premium tier routing passes through Google Network; routing is cold potato, which minimizes distance and hops, resulting in faster and more secure transport. Traffic exits Google network near distribution (PoP near end user). Path over public internet is as short as possible.

- Ingress (incoming to Google) with global load balancing: in premium tier, the same global external IP address is advertised from various PoPs, and client requests are directed to the client's nearest GFE (Google Front End). Realized with Anycast.

## Load Balancing in GCP

To load balance between VMs, need to create an Unmanaged **Instance Group** to load balance to (grouping of a set of VMs)

- Unmanaged = manually manage groups of load balancing VMs

Select region, zone, network, subnetwork, and then choose VMs to be a part of the instance group

Port mapping: create a referenceable named port to later assign load balancer to (such as app-http -> port 5000)

Now, we can create a **Load Balancer**

- Choose network vs application load balancer
- Choose external vs internal
- Choose global vs regional
- Click configure
- Specify name, network (will need to create a reserved subnet with own unique address range)
- Configure front end (how public internet connects to load balancer) and back end (what the load balancer connects to). In backend is where you reference the named port from before.
- Create health check (call HTTP on backend server port, 5000 in this case) and add request path (mapped to your application's health check endpoint)
- Specify routing rules, if any

Health check requests will run automatically.

Front end IP address for load balancer

## Terraform

Need to create several services for load balancing, so look at examples here: https://cloud.google.com/load-balancing/docs/https/ext-http-lb-tf-module-examples