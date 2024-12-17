# Internet Protocol

Internetworking enables communications between multiple, heterogeneous networks. 

Key: Router at edge of each network (called Gateway in 1974 paper)

## Service Model of the Internet Protocol

Best effort: 

- Delivery: packets may get dropped
- Timing: no guarantee on how long it takes to deliver a packet
- Order: packets may get reordered in the network

Reasoning: interconnecting different link layers, so needs to be lowest common denominator

## Addressing in IP

Each interface gets and IP address

- IPv4: 32 bits in dotted decimal (4 groupings of 8 bits; each 8 bits gets decimal number between 0-255)
- IPv6: 128 bits in hextets (16 bits) separated by a colon (8 groups of 16 bits)

## Scalability

Add structure to addresses so devices can be grouped

A **subnet** is a set of consecutive IP addresses. 

- High order bits are all the same
- Low order bits identify host uniquely within that network

So a router may only include the high order bits in its table to reach all devices on a particular network through a given port. Then, a closer router will distinguish between devices represented in the low order bits.

## CIDR

Classless Inter Domain Routing

Format: a.b.c.d/x (also called a prefix)

x is the length of the prefix; number of higher order bits that are the same

a.b.c.d are values which are the same (use 0 for low order bits)

Ex.

- Prefix is 2.1.1.0/24 -> This means that 24 uppermost bits (2.1.1) are all the same, and the low order bits (represented by 0) can be anything.

## Hierarchy

Subnets can be combined. 

Ex.

- 1.1.0.0/24 and 1.1.1.0/24 can aggregate as 1.1.0.0/23 -> creates a larger grouping and thus a hierarchy