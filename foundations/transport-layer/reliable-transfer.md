# Reliable Transfer

Transport Control Protocol (TCP) offers reliable transfer--same data, same order.

Possible issues:

- Frame/packet error
    - Errors may occur at the link layer (interference)
    - Ethernet has a CRC field to be able to detect errors
    - However, it does not fix them; just drops the frames that are in error

- Dropping due to congestion
    - Router architecture queues packets for transmission
    - If incoming rate is greater than outgoing rate, buffer fills up

- Packet reordering
    - Routing calculates best path, and can change over time (dynamic)
    - For example, new path is shorter transmission delay than old

## TCP Mechanisms for Reliable Transfer

Provides abstraction of a reliable, in-order stream

- Sequence number: Indicates which bytes in the stream the datagram contains
- Ackknowledgement number: Sent by the receiver back to the sender; specifies the next byte in the stream that the receiver expects
- Retransmission: Sender can resend unacknowledged bytes in the stream
    - When does this happen?
    - On timeout after some estimated round trip time (RTT) plus buffer before resending
    - On duplicate ACK (indicates packet was dropped rather than out of order)

### Drops at the Receiver

Sender may be able to send at higher rates than the receiver can accept

Goal: make it so that the sender cannot overwhelm the receiver through **flow control**

- TCP receiver "advertises" free buffer space in rwnd (receive window) field in TCP header
- Sender limits amount of unacknowledged ("in-flight") data to receiver rwnd
- Window size field: how many bytes the host is currently able to receive