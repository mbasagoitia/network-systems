# Filtering/Address Translation

## Filtering

Allows us to block/allow traffic according to some policy, such as blocking all web traffic not for port 80, or blocking blocking all traffic except for connections initiated internally on a home gateway.

Can be at the edge of a network and/or on the end hosts themselves.

Achieved through match-action tables

- Match: compare input packets to the rule to see if there's a match
    - ex. dstIP = 1.2.3.0/24 and dstPort = 80
- Action: what to do with the packet if there is a match
    - ex. drop, allow

A good practice to to default to drop and have rules to have an action other than drop ("whitelisting")

## Address Translation

Actions can also manipulate the address, such as source/dest ip addresses and source/dest ports.

Ex. Use private addressing on the LAN, with a single shared public IP address. Packets destined to public address are translated to a private one.

Use cases:

- Static mapping: internal to external
- Dynamic mapping: single external IP; dynamically select from available TCP ports
- Port forwarding; run a publicly available server on a private ip

# iptables

Linux netfilter framework that configures the Linux kernel's filtering framework

Examples of iptables rules

- iptables -A FORWARD -m state --state ESTABLISHED, RELATED -j ACCEPT
- iptables -A INPUT -p tcp --dport 80 -j DROP
- iptables -A INPUT -i eth1 -s 10.0.0.0/8 -j LOG --log-prefix "IP_SPOOF A:"

Main concepts: tables, chains, rules

iptables is used to set up, maintain, and inspect the **tables** of IP packet filter rules in the Linux kernel. Several different tables may be defined. 

Each table contains a number of built-in **chains** and may also contain user-defined chains. 

Each chain is a list of **rules** which can match a set of packets.

Ex. iptables ADD/REM/CHANGE TABLE CHAIN RULE

## Rules

Rules match on some criteria and take some action. They consist of the match-action tables pairs.

Matching basics: 

- -p, --protocol [!] protocol
- -s, --source [!] address[/mask]
- -d, --destination [!] address[/mask]
- -i, --in-interface [!] name
- -o, --out-interface [!] name

Rules: actions

- -j, --jump target

target can be DROP, ACCEPT, LOG, and others

Tables: 4 defined tables:

- filter - default table
- nat - consulted when a packet that creates a new connection is encountered
- mangle - used for specialized packet alteration
- raw - used mainly for configuring exemptions from connection tracking

Chains: sets of rules that are evaluated sequentially

Rules can be terminating or non-terminating

Recall -j, --jump target. The target can be a user-defined chain, one of the special built-in targets which decide the fate of the packet immediately, or an extension.

Specifying tables and chains:

- -t <table>
- -A <chain> (to add an entry)

iptables -t filter -A FORWARD ... <- applies to the forward chain of the filter table. Remember filter is the default table.

iptables -t nat -A PREROUTING ... <- applies to the prerouting chain of the nat table, specifies a rule

iptables -t mangle -A FORWARD ...