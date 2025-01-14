# RPKI (Network Control Plane)

BGP communicates paths to reach IP prefixes. If an attacker can inject fake paths, it can redirect traffic to it (denying service, changing messages, inspecting traffic).

Idealized solution: Prefix owner tells ASes what AS it is in. The path is chosen through BGP, but needs to originate in that AS. The actual owner can be verified through digital certificates (through a verified (by a certificate authority) identity tied to a public key).

- RPKI (Resource public key infrastructure): Regional internet registries (RIRs) are established as certificate authorities (these are the ones that allocate IP address space). Digital certificates contain IP prefix, AS origin, and tie to that owner. The RIR's private key signs and verifies the identity of the prefix owner and creates a certificate for the prefix owner's public key. These certificates (ROA - resource ownership authorization) are stored in a database and validated by software in the AS deploying RPKI.