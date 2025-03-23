# WAN (Wide Area Network) Overview

How do we communicate beyond the bounds of the VPC? 

- VPC to VPC
- VPC to end user

WAN enables communication beyond the bounds of a region or datacenter; may go across internet or use private, interconnected networks (such as datacenters interconnected by fiber)

RFC 1918: IP addresses set aside to be used as private addresses; won't be assigned publicly, and we can use them in our infrastructure

- 10.0.0.0 - 10.255.255.255 (10/8 prefix)
- 172.16.0.0 - 17.31.255.255 (172.16/12 prefix)
- 192.168.0.0 - 192.168.255.255 (192.168/16 prefix)

Internal IP addresses are determined within subnets which are within VPCs

Remember when creating VMs, you can choose whether to assign an external IP address or not

## Communicating with Public IP Addresses

- Google IP addresses will traverse their backbone (network) to communicate with each other
- Otherwise, will use peering to an ISP to connect to broader internet

## Communicating with Private IP Addresses

- VPC peering
- Cloud NAT