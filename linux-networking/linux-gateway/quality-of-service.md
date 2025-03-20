# Quality of Service

QoS refers to the overall performance of a service. 

Applications care about:

- Bandwidth
- Latency
- Jitter (difference/regularity in latency)
- Loss

Different services will have different QoS requirements.

## QoS Management

Three main areas:

1. Classification - inspecting packets to identify what class of traffic they belong to
    - Given a packet, place it into a queue representing a traffic class
    - Ex. low (email), medium (web), and high (video conference) priorities
    - Various mechanisms for classification
        - Based on packet headers (such as tcp port 80 for web traffic, or a specific ip address pays more for service)
        - Based on deep packet inspection (inspect packet payload for known headers or bit patterns). Computationally expensive, but helps identify traffic that can't be at layer 3 or 4
        - Based on fingerprinting (protocols, applications, OSs all have fingerprints, such as distribution of packet sizes, inter-packet gap, etc. so performing statistical analysis over many packets can identify traffic)
2. Shaping - Ensuring a given class of packets conforms to desired properties such as rates
    - 2 key properties: traffic rate and burst rate, where traffic rate is a general/average allowed traffic level, and additionally allowing a higher burst rate.
        - Method: token bucket implements rate limiting
            - Tokens are added to a bucket at a given rate R
            - A packet can be transmitted if there is a token in the bucket
        - Handling bursts: bucket size determines burst rate. Say there's no traffic for a while, tokens start filling up the bucket. Allows for bursts of traffic. To constrain burst size, limit bucket size.
3. Scheduling - Determines which packet to transmit next and which packets to drop
    - 2 main functions:
        - Given a queue that is starting to fill up, determine what/when to drop
            - Queue size: if too large, long delays with congestion; if too short, lead to a lot of drops.
            - What to drop? Tail drop: when queue fills up, just drop from the tail. There are problems with this (lots of packet loss), and other methods are used such as RED (random early detection), CoDel, FQ-CoDel, etc.
        - Given multiple queues, determine which packet to transmit next
            - Strict priority: if top queue has a packet send that, else look in next
            - Round robin: cycle through each queue, transmitting one packet from each
            - Fair queuing: mimic a bit-per-bit multiplexing by computing theoretical departure date for each packet

All of the above happens on the egress side

On the ingress side, the 3 main areas of QoS are classification and **policing.** Policing is similar to shaping; enforces a rate limit. The difference is that it can only take one corrective action, which is dropping a received packet.

# tc

Linux traffic control utility

Used for QoS setup, but can do much more.

Key constructs: 

- qdisc (queuing discipline)
    - Main object for shaping/scheduling. Every interface must have an ingress and egress qdisc. Packets go into a qdisc and then go out the other side. Default used by Linux is pfifo_fast - first in first out.
    - Adding/removing a qdisc: tc qdisc [add | delete | replace...] dev DEV [parent qdisc-id | root] [handle qdisc-id] qdisc [qdisc specific parameters]
    - Each qdisc must be associated with a device
    - Ex. tc qdisc add dev eth0 root handle 1: tbf rate 1mbit burst 32kbit latency 400ms
    - qdiscs can be classless or classful. Some qdiscs can contain classes, which contain further qdiscs. Traffic may then be enqueued in any of the inner qdiscs, which are within the classes.
- class
    - tc [OPTIONS] class [add | change | replace | delete | show] dev DEV parent qdisc-id [classid class-id] qdisc [qdisc specific parameters]
    - Nearly identical to qdisc; can't be root, classid instead of handle - same basic type, the type (qdisc) must be the same as parent qdisc
- filter
    - tc filter [add | replace | delete] dev DEV [parent qdisc-id | root] [handle filter-id] protocol protocol prio priority filtertype [filtertype specific parameters]
    - Enables specifying which traffic is in which class
    - Need to specify the device to associate with and parent qdisc
    - Match filters (match / action): u32, fw, flow

Another interesting qdisc: netem (network emulation): provides functionality for testing protocols by emulating the properties of real-world networks. Adds delays to packets, add packet loss with some probability, etc.
