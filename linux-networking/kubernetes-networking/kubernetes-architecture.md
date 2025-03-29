# Kubernetes Architecture

Control plane:

- Scheduler: waits for newly created pods (API server watch) then assigns each new pod to a node. Does not instruct the selected node to run the pod.
    - Basic operation:
        - filter: finds the set of nodes where it's feasible to schedule the pod (label, up/down status)
        - score: ranks the remaining nodes to choose the most suitable pod placement
- Controller manager: runs multiple controllers as processes performing various reconciliation tasks
    - replication manager
    - replicaset
    - dameonset
    - deployment
    - node
    - service
    - The controller manager watches the API server for changes to resources it cares about and performs operations for each change
        - ReplicaSet watches ReplicaSet resources and Pod resources and creates/deletes Pod resources
        - Endpoints watches services resources and Pod resources and creates endpoint resources
    - Each runs a reconciliation loop (desired state specified / current state as seen from the API server)
- etcd: a distributed key value store
    - stores state for the k8s cluster (info about pods, deployments, etc.)
    - uses RAFT consensus algorithm - each node's state is either what the majority of the nodes agree is the current state or is one of the previously agreed upon states
    - client reads and writes to the etcd and it synchronizes with other nodes' etcd
- kubelet: 
    - register the node it's running on by creating a node resource in the API server
    - watches API server for pods that have been scheduled to its node
    - starts the pod containers by telling the container runtime to run a container from a given image
    - monitors running containers and reports any events
    - runs the liveness probes and restarts containers when probes fail
    - deletes containers when pod is deleted (watches API server)
    - can run pods specified in local pod manifest (for running system components), which are called static pods
- API server: provides a CRUD interface for querying and modifying the cluster state over a REST API
    - client (kubectl) makes http (post) requests to the server which includes authentication plugins, admission control plugins, resource validation that can modify the resource (such as initializing missing fields, rejecting the request, etc.)
    - stores the state in etcd
    - All other components watch the API server through an http session with watch=true. Any time a command changes the API server, state in etcd is updated and etcd sends a modification notification to API server, which updates the watchers. kubectl can also watch.
Workers:

- kubelet
- proxy
- container runtime (such as docker)

Others:

- DNS server
- dashboard
- load balancer (ingress controller, external load balancer)
- CNI plugin

## How Components are Run

- Kubelet is the only component that always runs as a regular system component
- Kubelet then runs all other components as pods. Kubelet runs on the control nodes to launch control plane
- Kubelet runs on worker nodes to communicate with the API server on the control node to create and manage pods. Also interacts with container runtime to create pods.

To explore this,

- docker exec -it <each node> /bin/bash
- ps aux
- crictl ps <-- interacts with control plane node runtime
- kubectl get all -A