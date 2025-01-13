# Network Security

Communication is between parties across a medium that may or may not be under their control.

Malicious parties can attack the communication in various locations.

## Properties:

- Confidentiality: information is visible only to those intended
- Integrity: data has not been modified/corrupted
- Availability: information can be accessed

## Confidentiality

We want to be able to send a message and keep it secret to everyone except the intended recipient.

**Plaintext** is unencrypted data sent by one party, which is transformed into **ciphertext** by an encryption algorithm. It is likewise decrypted by a decryption algorithm back into plaintext. The encryption and decryption keys must be kept a secret.

**Symmetric encryption**: (not secure) Shared key, used in both encryption and decryption. This is fast, but we need a way to share the key.

- Xor algorithm. Message is converted into plantext bytes with ASCII characters, xor'd block-by-block (each block being 8 bits, the key is 8 bits) with the key (generated in some way), sent across the network, and decrypted (xor'd) with the same key to get original message.

- **AES**: 128, 192, or 256 bit keys; similar principal as xor, but more complicated encryption process.

**Asymmetric encryption**: Generates a key pair, one public, one private. This is slower, but simple to share the public key. Message is encrypted with the recipient's public key and decrypted by their private key.

- **RSA**: 
    - Given public key (n, e) and private key (n, d)
    - Message (m) is a bit pattern interpreted as an integer
    - To encrypt message m(n), compute c = m^e mod n
    - To decrypt bit pattern c, compute m = c^d mod n

This works because of properties of mod and how n, e, and d are chosen

**Using public key to exchange shared (secret) key**:

To encrypt longer messages (since RSA tends to be slow and is best for smaller bit patterns), may use public key to exchange a shared (session) key.

Sender picks a session key, uses recipient's public key to encrypt and send the key. Recipient decrypts with private key. Since the two now share a secret session key, they can use that with symmetric encryption to encrypt/decrypt longer messages.

## Message Integrity

We don't want a potential attacker to be able to modify messages over the network.

**Hash**

- Hash function calculates a fixed length digest from a variable length message.
- Desired property: computationally infeasible to find another message that would result in the same digest message.
- Assumes digest unmodified; used in integrity checking software downloads
- On recipient's side, run same hash function on the data, compare calculated message to received digest
- Problem with this is the transfer of the digest

**HMAC (Hash-keyed Message Authentication Code)**

- Ensures the hash digest hasn’t been modified by using a shared secret key.
- Relies on a secret key shared between the sender and receiver.
- The sender creates the HMAC by hashing the key and message through a defined process, and the receiver verifies it by recalculating the HMAC.
- HMAC does not encrypt or decrypt the message but ensures message integrity and authenticity using the shared secret key.

A digest (e.g., SHA-256 hash) relies only on the input data. Anyone can generate it.
A MAC (e.g., HMAC) includes a secret key shared between the sender and receiver. Only someone with the key can generate or verify it.

**Digital Signatures**

- Uses asymmetric keys to enable checking message integrity and authenticity
- Sender uses their private key to "sign," and the receiver uses the sender's public key to verify the signature

## Authentication

We want to ensure that we are only communicating with who we expect to be communicating with.

**Digital Certificates**

- Binds public key and identity (definition of identity depends on the context)
- Recipient can validate that this key is the sender's public key
- Potential problems: certificate can be modified by attacker
- **Certificate Authority** is some trusted authority can verify the sender's identity and use its private key to sign
    - Anybody can verify the digital certificate use the certificate authority's public key
    - The CA's public key has to be trusted (pre-installed in a browser)