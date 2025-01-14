# ipSEC (Network Data Plane)

If an attacker can see traffic on a network/the internet, they could potentially get access to secret data.

How would someone eavesdrop?

- WiFi is a broadcast communication
- Network provider compelled by government agency or has a rogue employee or compromised router
- Misconfiguration in routing redirects traffic to the wrong place
- Route hijacking to intentionally redirect traffic

**IPsec** (Internet Protocol Security) is a suite of protocols used to secure communication over the internet or any IP-based network. It provides encryption, integrity, and authentication for data transmitted over IP, ensuring secure communication between devices over an encrypted tunnel.

To set up an ipSEC tunnel, a protocol (ISAKMP/IKE) is used to set up the parameters and keys used, and authenticate each side. Then traffic can be exhcanged.

- ISAKMP: Internet security association
- KMP: Key management protocol
- IKE: Internet key exchange
- SA: Security association
- DH (Diffie Hellman): Allows two parties that have no prior knowledge of each other to jointly establish a shared secret key over an insecure channel
    - Initiator chooses a prime p and base g and sends those to the responder
    - Initiator picks a secret x (which it does not share) calculates hA = g^x mod p. Sends hA to responder.
    - Responder picks a secret y and calculates hB = g^y mod p. Sends hB to the initiator. 
    - Now, the shared key for the initiator is K = hB^x mod p and for the responder is K = hA^y mod p, and **these two values are the same.** This is because both simplify to g^xy mod p, without either side knowing the opposite side's x or y value.
    - Given only the information that was exchanged (p, g, hA, and hB), it is hard to calculate K.

Steps:

1. SA-1 Parameter Exchange: Initiator says what algorithms it supports across 4 categories (encryption, hash, DH group, auth), and the responder chooses.
2. DH Key Exchange: ipSEC uses shared keys for (symmetric) encryption and integrity. DH is a protocol to secretly create and share private keys.
3. Authenticate: Verifies that each side is communicating with who they think they are. Option decided in SA-1 parameter exchange (shared private key/digital certificate); this step uses keys determined with the DH key exchange setup.
4. SA-2 Parameter Exchange: Sets up security association for traffic exchange (in case different parameters are desired). Sets up traffic selectors which determine what traffic is allowed through the tunnel (5-tuple of IP src/dest, protocol, transport src/dest)
5. Traffic Exchange: Supports several modes--AH (authenticating header) or ESP (encapsulating security payload), transport (mostly for single enpoint) or tunnel (mostly for whole site)

## Software for IPsec

- From vendors of most routers/firewalls - Juniper, Cisco, Palo Alto
- In cloud - AWS, Azure, GCP's VPN service
- Open source: Strong Swan