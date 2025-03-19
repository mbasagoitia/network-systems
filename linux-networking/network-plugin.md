# Creating a Network Plugin

Recall that the kubelet, which runs on each node and watches/gets updates from the API server, calls the container runtime on a node if it needs to create a pod. The container runtime calls a network plugin to set up the networking for the pod. The network plugin implements the CNI spec (implements functions like ADD, DEL, CHECK, etc.).

## Config

How it Works:

- Checks /etc/cni/net.d for configuration files and uses the one with the lowest prefix number
- KinD installs a network plugin, and you can see it with the following commands:
    - docker exec -it kind-worker /bin/bash
    - cd /etc/cni/net.d
    - ls
    - cat 10-kindnet.conflist

Note the plugin type, "ptp" <-- executable that implements the CNI's commands. Located in /opt/cni/bin

If you look on each node, both the config and executable will be there. Config may be different on each (such as IP address).

## Creating Our Own Plugin

Pull from the github repo for this module.

- config: 09-nppnet-skel.conflist
- executable: npp-skel (bash script; this will print out to /var/log/nppnet.log)
- install script: install-skel.sh (This involves creating the kind cluster, copying config and executable into each node by copying into the mounted directory. Make sure that directory exists by running ./make-dirs.sh)

In the executable, the parameters it passes in (to adhere to the CNI spec) are:

- CNI_COMMAND
- CNI_CONTAINERID
- CNI_NETNS
- CNI_IFNAME
- CNI_ARGS
- CNI_PATH

## Setup

- ./make-dirs.sh
- kind create cluster --config cluster-configs/1worker2Mount.yaml
- copy bin and conf into tmp/w1
    - cp cni/09-nppnet-skel.conflist tmp/w1
    - cp cnp/nppnet-skel tmp/w1
- exec into worker 1
    - docker exec -it kind-worker /bin/bash
- copy bin and conf into correct locations
    - cp /npp-temp/09-nppnet-skel.conflist /etc/cni/net.d/
    - cp /npp-temp/nppnet-skel /opt/cni/bin

Now the default network plugin should be your custom one

## Testing it Out

Apply a label to worker 1
    - kubectl label node kind-worker node=node1
Launch a pod (it has selector to make it get scheduled on worker1)
    - kubectl apply -f pod configs/simple-nginx-node1.yaml
In host
    - kubectl describe node kind-worker
    - kubectl describe pod mynginx (will show an error)
Inside of kind-worker container
    - journalctl -u kubelet
    - cat /var/log/nppnet.log

Need to make the file executable
- chmod +x nppnet-skel

## Real Network Plugin

What our plugin needs to do:

- Allocate IP address
- Create entry in /var/run/netns/ (for ip netns)
- Create veth pair
- Put veth into namespace
- Set up networking within the namespace (address, route)

Steps:

Setup:

- Make tmp/w1 and tmp/w2 directories for mounting
- Create a cluster: kind create cluster --config ./cluster-configs/1master2workerMount.yaml
- Set labels: kubectl label node kind-worker node=node1/node2

Network plugin installation
- Put config in /etc/cni/net.d (edit unique subnet for each worker)
- Put executable in /opt/cni/bin
- Create cni0 bridge
- Script provided to do all of that (nppnet-install.sh - must be edited)

Sample activities:

- Run pods and look at their info
    - kubectl apply -f pod-configs/forexec1-node1.yaml
    - kubectl get pods -o wide
    - kubectl describe pod forexec1
- Test connectivity with ping
    - kubetcl exec -it forexec3 --ping 10.244.2.2
- Get inside one of the nodes and look at log
    - docker exec -it kind-worker /bin/bash
    - cat /var/log/nppnet.log