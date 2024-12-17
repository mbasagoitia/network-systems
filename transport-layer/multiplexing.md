# Multiplexing

The process of combining multiple application-level messages or data streams from different applications or processes into a single transport-layer protocol data unit for transmission over the network. The goal is to allow multiple applications or services to share the same network connection efficiently.

Whereas the link and network layers are used for communcation between hosts, the transport layer is used for **communcation between processes/applications running on a host.**

Inside of the header for the transport layer, we have a source and dest addresses known as **ports.** On our computers, we may run different servers (ssh, http) on different ports.

## Main Transport Protocols

- UDP (connectionless)
    - Simple multiplexing/demultiplexing
    - Inherits IP's service - best effort delivery of each datagram
- TCP (connection-oriented)
    - Single process can have multiple connections
    - In-order reliable stream

## Connectionless vs Connection-Oriented Protocols

- Connectionless
    - Hose uses dest IP and dest port to demultiplex to specific processes
    - Doesn't require establishment
    - Only state is (IP, port) -> process mapping

- Connection-Oriented
    - 4 tuple of src IP, dest IP, src port, dest port identifies the connection
    - Requires establishment before data transfer
    - Host keeps more state about the connection