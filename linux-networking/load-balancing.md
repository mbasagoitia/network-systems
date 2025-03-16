# Load Balancing

A load balacner serves as the point of entry for a service, and directs traffic to one of n servers that can handle the request.

Used for both scaling and resilience, likely involves NAT.

Uses a load balancing algorithm. Client initiates TCP connection to service and load balancer must select which server to forward the request to and establish the conneciton to.

Server set: which servers are part of the set to choose from. Set is statically assigned. May include liveness checks (through heartbeats).

Flow affinity: TCP is stateful, so we need to ensure that all packets are from the same flow (TCP connection) go to the same server.
    - First packet - algorithm will select server; creates an entry of flow (src IP, port) and VIP (virtual IP; which server it chose)
    - Subsequent packets - look in table for VIP

Algorithm examples:

- Source hash: For a source ip and port, a hash function determines the server. Balances connections among servers, assuming a distribution of source ip and ports. Stateless; flow affinity is taken care of by the hash function.

- Round robin: Server selection iterates through each server in order (1, 2, 3, 1, 2, ...). Ensures balanced load, asusming each request is roughly the same load. Load balancer needs to keep state for flow affinity.

- Least connections: Select server based on which has the least number of active connections. Takes into account that some requests may be longer, but assumes each connection imposes similar load on server. Load balancer needs to keep state (flow affinity and algorithm).

## Layer 4 vs Layer 7 Load Balancing

Layer 4 considers network (IP) and transport (TCP) headers. Also called a network load balancer.

Layer 7 also considers application (HTTP) header. Also called web proxy. For example, http://domain/signup goes to one server, and http://domain/purchase goes to a different one.

Layer 4 and layer 7 load balancers can be used together.

# ipvs

ipvs (IP virtual server) implements transport layer load balancing inside the Linux kernel.

ipvsadm is used to set up, maintain, or inspect the virtual server table in the Linux kernel.

Must have the ipvs kernel module loaded with the command "modprobe ip_vs"

## Creating Linux as a Load Balancer

Two parts:

- Define the service (ip address, port #, tcp, scheduling algorithm, etc.)
- Define the servers

Defining the service: 

General command: ipvsadm COMMAND [protocol] service-address (public facing address) [scheduling-method] [persistence options]

COMMAND
- -A or --add-service
- -E or --edit-service
- -D or --delete-service

Example: ipvsadm -A -t 207.175.44.110:80 -s rr <- adds a tcp protocol at this public address and port 80 with scheduling method round robin (also lc for least connection, sh for source hashing)

Adding a server:

General command: ivsadm COMMAND [protocol] service-address server-address [packet-forwarding-method] [weight options]

COMMAND
- -a or --add-server
- -e or --edit-server
- -d or --delete-server

-r or --real-server (address of backend server). With masquerading method, port can be different from the service. With tunneling and direct routing (gatewaying), port must be the same as service address port.

Packet forwarding method: -g or --gateway (default; use gatewaying/direct routing), -i or --ipip (ipip encapsulation/tunneling), or -m or --masquerading (use NAT)

Weight options: -w or --weight <weight> where <weight> is an integer specifying the capacity of a server (used in scheduling algorithms with weight such as weighted round robin)

Example: ipvsadm -t 207.175.44:110:80 -r 192.168.10.1:80 -m <- 

Server protocol and address should match service protocol and address.