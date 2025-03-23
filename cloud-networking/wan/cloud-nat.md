# Cloud NAT

VPC to end user communcation

Address translation:

- Actions can manipulate the address
    - Source/dest IP addresses
    - Source/dest ports
- Ex. Use private addressing on the LAN, with a single shared public IP address
    - Packets destined to public addresses are translated to a private one
- Static mapping: internal to external
- Dynamic mapping single external IP (dynamically select from available TCP ports) - share a single IP address among many devices

Cloud NAT is the Google service that provides access to external networks for VMs that don't have external IP addresses. Effectively provides this same concept for a VPC.

There is no immediate NAT proxy in the data path; each VM is progammed by GCP to NAT using assigned ports. Translation happens on each host.

## Instantiating in Console

- Need a Cloud router
- Search for Cloud NAT in searchbar and click "get started"
- Add gateway name
- Public NAT type
- Add VPC and region
- Create new cloud router
- Leave default settings for rest

Now, all members of VPC 1 have external communicaition (if that's the network you chose) since they share the same NAT instance

## Terraform

Cloud router resource is called "google_compute_router" (instantiate this before the NAT)

Need to specify name, region, network, bgp

Cloud NAT resource is called "google_compute_router_nat"

Need to specify name, router, region, nat_ip_allocate_option, source_subnetwork_ip_ranges_to_nat, log_config