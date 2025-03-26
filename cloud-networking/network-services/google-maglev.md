# Google's Maglev

Maglev is Google's network load balancer. Recall that L4 load balancing is designed to be fast and passthrough traffic.

Maglev leverages **consistent hashing**, which was originally designed around content distribution (Akamai)

Suppose we want to partition files (balance load) among a set of k servers

Could use modulo: server = x modulo k, but this may not provide even distribution.

Could also use hashing: server = hash(x) modulo k. But if k changes (failure or scaling), mapping of x to server will change.

## Consistent Hashing

Construction:

- Assign n hash buckets to random points on mod 2^k circle; hash key size = k
- Map object to random position on circle
- Hash of object = closest clockwise bucket (server)
- Successor (key) -> bucket

Desired features:

- Balanced: no bucket has a disproportionate number of objects
- Smoothness: Addition/removal of bucket does not cause movement among existing buckets (only immediate buckets)

Consider a network of n nodes.

If each node has 1 bucket:

- Owns 1/nth of keyspace in expectation
- Says nothing of request load per bucket

If a node fails:

- Its successor takes over the bucket
- Achieves smoothness goal: only localized shift, not O(n)
- But now successor owns 2 buckets, keyspace of size 2/n 

Instead, if each node maintains v random nodeIDs, not 1:

- "Virtual" nodes spread over ID space, each of size 1/vn
- Upon failure, v successors take over, each now stores (v + 1) / vn

## Network Load Balancers

What do we need from a network load balancer?

- Balance load evenly
- Reliability: do not reset user connections
- Flexibility: iterate quickly
- Scalability: grow with cloud scale
- Efficiency: deliver high performance per dollar

Limitation of hardware appliances:

- Poor flexibility
- Scaling is hard
- Active-passive failover
- Expense at scale

Why Maglev?

- In 2008, hit wall with existing appliance solution
- Key insight: replace inflexible, dedicated hardware with software running on existing servers
- Scalable deployment model
- Virtualize the network function
- Global control plane: SDN

Scales out across many servers with ECMP, scales up with kernel bypass. Enables cloud scale control plane.

Design challenges:

- Reliability: keep connections alive
    - TCP connection needs to go to same backend server, even when set of load balancers or set of back ends changes. We can do this with consistent hashing.
    - Reliability when set of Maglevs changes:
        - ECMP change sends most connections to different Maglev
        - Can't share connection state or do round robin; hashing on 5-tuple solves the problem. Same backend server handles request even if ECMP sends to different Maglev.
    - Reliability when set of backend changes
        - Hash space gets remapped (only consider latest set of servers)
        - Need to do connection tracking (lookup in table for existing connections)
            - Plenty of memory even in worst case
    - What if both cases happen at once?
        - Consistent hashing
        - Given similar inputs, will produce similar assignments
        - Does not depend on backend history
        - ECMP change will not cause many resets, even with minor (routine) backend changes
- Scaling: scaling out with ECMP and scaling up with kernel bypass

## Conclusion

- Maglev is a fast and reliable network load balancer
- ECMP, connection tracking, and consistent hashing combine to scale out reliably
- Kernel bypass gives performance needed to make software network LB economical
- Software is a good place for stateful network functions
