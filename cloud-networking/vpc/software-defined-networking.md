# Software Defined Networking

Challenges of standardization and control requirements with independent mechanisms make network systems very complex and slow to innovate.

Complexity vs Simplicity:

Networking is still focused on mastering complexity
- Little emphasis on extracting simplicity from control plane
- No recognition that there's a difference

Extracting simplicity build intellectual foundations
- Necessary for creating a discipline
- That's why networking lags behind

Abstractions are key to extracting simplicity

We need a network-wide view, which is needed for a network-level objective

Need ability to express desired solution

OpenFlow was a key abstraction innovation: match action table

Match/action unifies different kinds of devices:

- Router
    - match: longest destination IP prefix
    - action: forward out a link
- Switch
    - match: destination MAC address
    - action: forward or flood
- Firewall
    - match: IP addresses and TCP/UDP port numbers
    - action: permit or deny
- NAT
    - match: IP address and port
    - action: rewrite address and port

The problem with OpenFlow is a fixed set of things you can match on and fixed set of actions. Proliferation of protocols, header fields, tables

So in 2013 there was introduction of Reconfigurable Match Action Tables (RMT). Brought more flexibility to hardware. SDN control plane interacts with compiler

Goal of the SDN and OpenFlow movement was to move from a model of vertically-integrated, closed, proprietary, slow innovation model to one of horizontal, open interfaces (switching chips), rapid innovation.