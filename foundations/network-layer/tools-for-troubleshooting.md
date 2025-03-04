# Tools for Troubleshooting

- Ping: Quick check if a server is up
    - Includes round trip time to identify latency issues
    - Uses specific type of packet and ICMP echo

- Traceroute: Path to destination
    - Helps to identify latency or reachability issues
    - From a server hosted in cloudlab in Wisconsin
    - Shows a path of routers that the packet goes through
    - Set TTL = desired hop
    - When TTL expires, packet is dropped and router will send an ICMP message that the time exceeded

- iperf3: Allows you to determine the max throughput between client and server; can be used to identify performance issues