# Socket Programming

How do we write programs to interface with the network stack?

## Berkeley Sockets

- Originated in 1983 and has been the standard since
- A socket is an abstract representation for the local endpoint of a network communication path
- Application puts data into socket; other application gets data from the socket

The application layer is controlled by the app developer; the protocols in lower layers are handled by the operating system

## Socket Programming

**TCP/UDP Server** functions

- socket(): OS will create a socket and return a handle (file descriptor) which includes domain, type, and protocol
- bind(): tells the OS which address to use (IP address, port number)
- listen(): notifies OS the willingness to accept incoming connections on this socket; takes in number of clients the server can listen to simultaneously
- accept(): blocks waiting for connections; sets the address of the incoming connection
- send(), recv(): read and write calls to exchange data
- close(): end-of-file notification (from client to server); closes connection

**TCP/UDP Client** functions

- socket()
- connect(): on the client side, tells OS to initiate connection to a specific address (three-way handshake initiation)
- send(), recv(): read and write calls to exchange data
- close(): end-of-file notification (from client to server); closes connection