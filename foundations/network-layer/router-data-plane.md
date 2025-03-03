# Router Data Plane

## Role of a Router

- Acts as an interface/gateway between LANs
- Forwards traffic to some destination

## Forwarding vs Routing

- Forwarding: Data plane
    - Direct a data packet to an output port/link
    - Uses a forwarding table

- Routing: Control plane
    - Computes paths by coordinating with neighbors
    - Creates the forwarding table

## Packet Forwarding

- Control plane (route processor) calculates the forwarding table
- Data plane: life of packet
    - Received at ingress of line card
    - Looks up destination in forwarding table and determines output port
    - Sends packet over switch fabric to output port
    - Line card transmits packet

## Data Plane Processing

### Switch Card

Data is received, looks up IP address in the forwarding table, updates header, queue packet inside of a buffer and is sent out

Lookup searches for a match on IP prefixes (subnets), but prefixes may overlap. Solution is **longest prefix match (LPM)**, which finds the most specific prefix that matches the destination.

## Address Lookup Using Tries

- Type of search tree
- Left branch = 0, right branch = 1
- Walk the tree to perform a lookup

### Switch Fabric

- Parallelism via a switching fabric, such as crossbar (or other topology): during each time slot, each input is connected to a 0 or 1 output

    - Can transfer many packets simultaneously, but requires special hardware

- Switching via memory: Processors are getting faster; cloud/virtualized environments gaining popularity