# Domain Name System

The application layer has its own addressing because IP addresses are not human-readable.

Also has hierarchical naming system
- Top-level domains (.com, .edu, .org, etc.)
- Next level-domain (princeton, cu, etc.)
- Domains within higher-level domain (cs, ee, physics, etc.)

## DNS

DNS is a distributed database of mappings between host names and IP addresses.

Application layer protocol runs on top of UDP.

DNS stores resource records (RR)

RR format: name, value, type, ttl

Type A:
- Name - hostname
- Value - IP address

Type NS:
- Name - domain
- Value - hostname of authoritative name server for this domain

Name servers query a local DNS server (resolver) to try to find the IP address for the host; different levels of DNS servers can be queried, and records can be cached.

## Root servers

DNS is critical infrastructure for the Internet/web

Root servers are critical within DNS--let us know how to find top-level domains, which then should be able to find other domains/hosts

Known set of 13 root servers (IP addresses are configured in resolvers)

Each root server is replicated for redundancy

**Any Cast**: Advertise a single IP prefix from multiple distinct locations; hosts trying to reach that prefix will go to the closest one

## DNS Message Format

Query and reply has same format

- Identification: reply will match query
- Flags: tell if query or reply, etc.
- Questions, answers, authority, additional
    - Questions: Contains a query of the hostname being looked up
    - Answers: Responses to queries if resolver has the answer (includes address header and corresponding IP address)
    - Authority: If resolver doesn't know the answer, it responds with a name server that it knows is authoritative for the name or part of the name.
    - Additional: To help prevent further lookups, if the resolver can resolve the address of the name server in the authority record, it includes it as an additional record.