# TCP Connection Establishment

Each side stores state in send/receive buffers to be delivered to application

**Connection establishment** is an exchange of messages where each process agrees to form a connection

Connection uniquely identified by tuple (src IP, dest IP, src port, dest port)

## TCP Header Flags Used in Connection Establishment

- SYN: synchronize sequence number
- ACK: acknowledgement number field is valid or not

1. Host chooses starting sequence # arbitrarily; sets SYN flag to indicate start of connection
2. Receiver receives the message and sends ACK #, chooses and sends it own seq # and sets SYN flag
3. Host acknowledges the next sequence number it is expecting with ACK flag
4. Connection is established and data ready to transfer

Packets may be resent during connection establishment if RTT time is exceeded
