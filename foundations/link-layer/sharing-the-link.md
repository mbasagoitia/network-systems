# Sharing the Link

We need to coordinate between nodes to regulate access to the shared medium.

If we don't regulate access, we may get **interference.** Signals collide and no data can be usefully transmitted.

How do we share the link fairly and efficiently?

- Channel partitioning
    - Divide the link into smaller pieces and assign to each node
    - TDMA: Time division multiple access, where nodes can only send information during their time slots
    - FDMA: Frequency division multiple access, where we divide frequency spectrum and assign each node its own frequency

- Random multi access protocols

    - Nodes can transit in an uncoordinated manner
    - Deal with collisions when they happen

    - When to send?
        - Carrier Sense Multiple Access (CSMA), used in both Ethernet and Wi-Fi
        - Node will read from the channel to see if another node is sending and transmits when it senses idle

    - How do we know if a transmission was successful?

        Ethernet
        - CSMA/CD: Collision detection
        - Ethernet NICs can read while transmitting; if what it reads is different from what it is sending, it detects a collision
        - Node will send a "jam" signal: transmits a fixed-bit pattern to ensure everyone detects the collision

        Wi-Fi
        - CSMA/CA: Collision avoidance
        - NICs cannot read while transmitting and may be out of range of some nodes
        - Depends on explicit acknowledgement from receiver
        - If it doesnt receive this acknowledgement in a certain period of time, it assumes a collision occurred
        - Optional RTS/CTS: request to send, clear to send
    
    - When a Transmission Fails
        - Retransmit the frame some time period (backoff)
        - CSMA/CA and CSMA/CD specify:
            - Random backoff time: To avoid nodes repeatedly colliding
            - Exponentially increasing: When multiple transmissions fail, wait longer each time