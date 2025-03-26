# Content Distribution Networks

Recall that HTTP is the web's application layer protocol. Client/server exchange web objects (html, jpeg, audio file). Stateless; server doesn't retain information about past client requests.

A request over the internet to a single server can lead to poor performance/reliability/scalability:

- Single point of failure
- Easy to be overloaded
- Long latency
- A lot of peering traffic

A **CDN** provider creates a network with servers at edge and a lot of peering agreements with network providers. Content provider signs up with CDN provider and specifies origin server. Client requests go to CDN servers. First access: CDN server contacts origin server (then caches content). Subsequent access: serve cached.

## CDN in GCP

Network services -> Cloud CDN

- Create origin server
- Point it to a backend service
- Configure how it should cache content