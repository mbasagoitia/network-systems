# VPN (Virtual Private Network)

Companies will often have some IT infrastructure in their corporate offices that needs to interface to the infrastructure deployed in the cloud. 

For example, data is stored in GCP, but employees need to be able to access it and make queries on it from the office.

## Why is VPN Needed?

Company has 2 sites, and employees at different sites want to share information with each other (or data in cloud that employees need to access). If an attacker can see the traffic, they will get access to the secret data. Solution: IPsec

How would someone eavesdrop?

- Wifi is broadcast communication
- Network provider compelled by government agency or has a rogue employee or a compromised router
- Misconfiguration in routing redirects traffic to the wrong place
- Route hijacking to intentionally redirect traffic

## IPsec

Creates an encrypted tunnel between two endpoints (can be for whole site or one machine)

Commonly used in VPNs

To set up the IPsec tunnel, a protocol (ISAKMP/IKE) is used to set up the parameters and keys used and to authenticate each side. Then, traffic can be exchanged.

## Setting up in GCP

Say we have our own infrastructure (server, firewall, router) in an office and want to privately connect to GCP infrastructure. Need to create a VPN gateway in GCP to communicate with the IPsec tunnel. On the other side, firewall can communicate with IPsec protocol.

Set up GCP side router and tunnel:

- Search for VPN in GCP -> create VPN connection
- Choose either high availability (2 tunnels) or classic VPN (1 tunnel)
- Name gateway, choose associated network/region. Automatically allocates IP addresses
- Add VPN tunnels
- Add IP addresses of your firewall (or whatever other interface you're peering from)
- Add a cloud router
- Make sure to select "advertise all subnets visible to the cloud router"

The cloud router makes the Cloud's routes available to be shared with your local network via the IPsec tunnel so you can reference cloud routes locally

- Configure BGP session (IP address of peer router and ASN)

Set up private side router and firewall:

- May download configuration in GCP to use locally, or configure manually

IPsec can connect to other cloud (AWS, Azure)

Key point: use IP address (as peer) assigned by AWS or Azure