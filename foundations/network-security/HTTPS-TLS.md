# TLS/HTTPS (Transport/Application Layer)

Recall that TCP provides reliable, in-order stream between two processes.

HTTP provides application protocol to get and put web objects.

An attacker could pretend to be an application (bank, etc.) or inspect/modify traffic (such as snooping on Wi-Fi in a public place).

**TLS** is a layer that provides security (confidentiality, integrity, authentication). When combined with HTTP, it is called **HTTPS**.

QUIC also incorporates TLS and can also be used with UDP.

Problems with HTTP/TCP:

- Messages sent in plaintext
- Message integrity not ensured
- Not guaranteed that you're communicating with desired server

Solutions:

- Symmetric encryption and message authentication codes (MAC) (shared secret key) which provides confidentiality and integrity
- Asymmetric encryption (to share the private session key): encrypt shared key with public key of a server and server decrypts with their private key; Diffie Hellman
    - How do we trust the public key of the server?
    - Digital certificates/certificate authorities (binds identity to public key, signed by a trusted source); provides authentication

**Let's Encrypt** is a popular certificate authority that verifies identity/ownership of a domain through a challenge
    - Provisioning a DNS record under example.com
    - Provisioning an HTTP resource under a well-known URI

## TLS Handshake

- Happens after the TCP connection is established (3-way handshake)
- Sets up agreements on parameters, authenticates the server, and sets up a private key
- Now, encrypted traffic can be exchanged

1. Client hello (tells server parameters: supported encryption algorithms, data integrity algorithms, etc.)
2. Server hello (chooses parameters and responds with choices)
3. Server certificate (servers sends its digital certificate signed by CA. Domain name is now bound to public key. Client will have root certificates installed; verifies server's certificate)
4. Server hello done (server indicates it is done with its negotiation)
5. Client key exchange (encrypted session key is sent by client with server's public key, decrypted by server's private key)
6. Change cipher spec (client indicates that it now believes parameters are agreed upon; next message will be encrypted)
7. Finished (client sends a summary of all messages to this point, ensuring integrity and that none have been tampered with)
8. Change cipher spec (server sends message indicating it has everything)
9. Finished (server sends summary of all messages to this point)
10. Communication is secured; encrypted traffic is sent across

## Mutual TLS (mTLS)

Usually, client verifying server's identity is enough, but sometimes the server may also want to verify the identity of clients as well (such as access control for API endpoints).

- Browsers (in client) would look at domain certificate and match to what is being accessed (implicit accept all)
- Servers would likely have an explicit access control list