# Transport Layer Introduction

Problems solved by the transport layer:

- Multiplexing: We have multiple applications running; which application is a packet for?
- Reliable transfer: Allow an application to be assured that what they send is what is received (same data, same order)
- Congestion control: Congestion in the network will occur, leading to packets being dropped. What if senders could detect this and back off if needed?