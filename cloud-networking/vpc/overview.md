# Overview of VPCs (Virtual Private Clouds)

Cloud providers have data centers across the world representing different regions. There are zones within each region that have critical shared resources for compute infrastructure including power, cooling, and networking. Zones provide fault isolation within a region, interconnected by fiber.

A VPC is the core networking abstraction inside the cloud. Effectively, it is your own private cloud running on top of the provider's physical infrastructure.

Within a VPC, you can further divide infrastructure into subnets, which are a subdivision of a network through partitioning IP address space into subnets.

VPCs contain routes (directing traffic between different subnets and external gateways) and rules (firewall policy configuration for what traffic to block/allow).

This module will cover:

- Creating a VPC in the GCP
- Software Defined Networking
- Google's Andromeda
- Azure's Accelnet (SmartNIC)
- Deeper dive into VPCs