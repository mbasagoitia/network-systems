# Akamai

Internet application requirements:

Application performance is directly tied to key business metrics such as application adoption and site conversion rates.

Experiment: site visitors were partitioned:
    - Half were directed to the site through Akamai (CDN)
    - Half were sent directly to the site's origin servers

Finding: Through Akamai, users were 15% more likely to complete a purchase and 9% less likely to abandon the site after one page

Another study: annual revenue increases of over $200,000 to over $3 million directly attributable to the improved performance and reliability of their applications

The problem with the internet:

- Reach of any single network is limited
- Peering point congestion
- Inefficient routing protocols
- Unreliable networks
- Inefficient communication protocols
- Scalability of backend
- Application limitations and slow rate of change adoption (supporting different browsers)

Initially, Akamai's network consisted of 61,000 servers located across nearly 1,000 networks in 70 countries. Had hierarchy of servers including parent servers, edge servers, and monitoring/management system.

Use cases:

1. Content delivery
2. Live video streaming
3. Application delivery
    - When content is not cachable, still has benefits
    - Path optimization
    - Packet loss reduction (with forward error correction)
    - Transport protocol optimizations (pooling persistent connections, retransmission based on network observation)
    - Application optimization (parse and prefetch content)

Uses DNS-based load balancing: looks up client's IP address and redirects them to nearest DNS server