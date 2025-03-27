# Direct Connect

Sometimes infrastructure is hosted in co-location facilities; maybe companies built their infrastructure around the co-lo and wants to expand into the cloud.

## Co-Location

Provider (such as CoreSite, Digital Reality, Equinix, etc.) owns/operates a physical building (commonly popular areas)

Customer can place their physical equipment in the building

Co-location facility provides:

- space
- power
- network connectivity
- physical security

Each company gets its own secured cage

Network provider equipment is placed in a meet me room in a centralized part of the building, and can cross connect a cage to network providers

Many colocation providers are moving toward virtual cross connects/network fabric to help automate cross connections

In some facilities, cloud providers have network equipment. Customers can get a port on (for example) Google's physical switch, which connects them to Google Cloud

Some providers have a global network fabric and can automate some of the connection process and enable connections beyond where the cloud provider switch exists.

After ordering the cross connect (connection to network provider) and direct connect (port on cloud provider's switch), need (in cloud) a router and VLAN attachment.

- Add cloud router as in previous use cases
- Add VLAN attachment with Interconnect