# VPC Peering

Sets up a private connection between two VPCs.

- Must create one peering in each direction
- Performs route exchange between VPCs
- Can't have subnets with overlapping address space

## VPC Peering in GCP

VPC network -> VPC networking peering; click "create connection"

- Add connection name
- Specify peering "from" network
- Specify peering "to" network
- Select import and export custom routes
- Select import and export subnet routes

- Create the second peering connection in other direction with same settings

Now, routes have been exchanged and ping should work between two VMs in these separate VPCs.

If you add another subnet in either VPC where peering is established, routing for that subnet will also be available via the peered VPC.

NOTE: Peering is non-transitive in GCP. If you have peering from A to B and B to C, A does not receive the routes of C and vice versa.

## Firewall

vpc1 -> vpc2 traffic would still traverse the firewall. Ping worked because icmp was allowed, but rules would have to be defined to let traffic through.

## Terraform

Peering resource is known as "google_compute_network_peering" in Terraform

- Need to specify name, network, and peer_network