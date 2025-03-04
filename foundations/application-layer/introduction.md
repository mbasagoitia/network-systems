# Application Layer

Interface for users and application services

Problems solved by this layer:

- Addressing: IP address isn't human-readable. An IP address represents a single machine.
- Programming: Link, Network, and Transport layer protocols are concepts, and the operating system network stack is their implementation. How do we write programs to interface to this network stack?
- How should the processes communicate what they want, and how do processes encode data?