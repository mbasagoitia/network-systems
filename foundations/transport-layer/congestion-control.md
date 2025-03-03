# Congestion Control

Congestion happens when the send rate out of a link is lower than the receive rate, which may happen as a result of different bandwidths, forwarding from multiple ports to one, etc.

When this occurs, packets get dropped by router and retransmitted by host

This can lead to congestion collapse, which is when buffers get full and sending keeps overloading them, leading to more packets getting dropped and retransmitted; leads to rapid goodput decrease

Can we get the network to operate just before it collapses (goodput and offered load are both maximal) in an efficient and fair manner?

- Fair: each flow receives and equal share of the bandwith of a link
- Efficient: full bandwith of link is used

## Resource Allocation Approaches

- Reservation: in network, reserve bandwith on each router
- Feedback and adjust: on hosts, detect congestion and adjust send rate

# TCP Congestion Control

Generally follows the feedback and adjust approach

Senders can increase sending rate until congestion occurs, then decrease sending rate

- Feedback: implicit
    - Packet loss due to timeout, duplicate ACK
    - Packet delay
    - Explicit congestion notification (requires router support)

- Adjust: window-based
    - Host limits sending through a congestion window (cwnd)
    - lastByteSent - lastByteAck ("in-flight" bytes) must be <= cwnd
    - cwnd is internal state on host

## Adjusting Congestion Window

- Additive increase multiplicative decrease (AIMD)
    - Optimizes congested flow rates network-wide
    - Has desirable stability properties

Additive increase increases sending rate by 1 maximum segment size every RTT until loss is detected

Multiplicative decrease decreases sending rate by some multiplicative factor (such as half) when loss is detected; leads to sawtooth pattern

**TCP slow start** increases the congestion window every ACK instead of every RTT; creates exponential increase up to a threshold, at which point additive increase starts (linear). Helps get to congestion point faster.