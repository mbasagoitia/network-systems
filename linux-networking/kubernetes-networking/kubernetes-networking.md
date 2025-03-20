# Kubernetes Networking

What types of communication do we need?

- pod to pod
- pod to pods
- pod to external service
- external service to pod(s)

Pod to Pod:

Each pod gets its own IP address in some subnet/address range. 

We use the **container network interface (CNI)** 

Container runtime creates the pod and calls a network plugin to set up the networking for that pod. The configuration and API of a network plugin follows the CNI spec. Flannel is one example of a network plugin.

- ADD
- DEL
- CHECK

Pod to Pods:

To recap, a service is an abstraction which defines a logical set of pods (chosen by a selector), a policy by which to access them, and load balances between them.

**kube-proxy** ensures that clients can connect to the services we define and load balance when needed. It runs on every node. Not in path of traffic; interfaces to iptables or ipvs.

Pod to External:

An external service would be defined in the yaml file with type: ExternalName and externalName: external-address.com

External to Pod:

Ingress and Ingress Controller are used, which are defined in each service you use that needs external communication.

**Ingress Controller**:

- Need to deploy an Ingress Controller first for the cluster.
- A load balancer such as nginx, traefik, haproxy, etc.
- Then, create an Ingress to tell the Ingress Controller how to reach a service.

In yaml file, specify kind: Ingress and provide the service names for given paths