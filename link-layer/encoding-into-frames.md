# Encoding into Frames

Assume that you can transmit 1s and 0s through whatever medium. We need to structure this data; the series of 1s and 0s.

This structure is called a **frame.**

3 parts of a frame:
- Header/Trailer: Extra information (metadata) to help understand how to handle it; further broken down into fields
- Payload: The data to be transmitted

## Ethernet

Main wired link layer protocol

The frame format for ethernet consists of the following:

- Dest: used for filtering messages; 48 bits
- Source: useful to know who sent the message (so the node can reply); 48 bits
- Type: tells what the data is; 16 bits. The value of the type field indicates that the payload should be interpreted as specific types of packet, such as IPv4, ARP, etc.
- data
- FCS: for error handling; 32 bits (this part is the trailer)

The source and dest are called media access control (MAC) addresses. 48 bits; typically displayed in hex with colons separating each 8 bits (2 hex characters)

Special address: broadcast address. All 48 bits are 1s (all hex characterss are F)
    - Set as a destination address in the frame, indicating that this frame is meant to be perceived by all nodes in the network

There are many different link layer protocols, each with its own frame format. Some standard defines the frame format so that everyone using it knows how to speak to one another.