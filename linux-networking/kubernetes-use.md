# Kubernetes Overview

Open-source container orchestration system for automating computer application deployment, scaling, and management.

Generally, we want to run our containerized application on a distributed cluster (because our applications may be so large that a single machine can't handle it).

Handles following challenges of containers and containerized applications:

- Where to run
- How to communicate with each other
- Scaling the service (load balancing)
- Handling failure (restarting), either containers or physical nodes

Comes with a CLI that interacts with the control plane that can manage worker nodes. Tell k8s the desired state, and it will best figure out how to do that and ensure it stays in that state.

# Use

2 options to create a k8s cluster

1. Launch VMs and install k8s with kubeadm
2. Single VM and use KinD (Kubernetes in Docker) https://kind.sigs.k8s.io/
    - Each node (control plane or worker) is a Docker container

This course will use KinD

## Creating a Cluster with KinD

Show configuration file: kind create cluster --config cluster -configs/1master2worker.yaml

View containers with docker ps

kind delete cluster

To look inside of a docker container, run docker exec -it kind-worker (or kind-control-plane) /bin/bash

## kubectl

Management utility for controlling cluster

.kube/config tells the utility to send API calls to the control plane container

- kubectl run ...
- kubectl get ...
- kubectl get nodes <-- shows name, status, roles, age, version of nodes in the cluster
- kubectl apply
- kubectl delete
- kubectl describe
- kubectl logs

## Pod

A pod is the unit of work in k8s. Often a single container, but can be multiple containers. Receives a unique IP address in the k8s cluster.

kubectl apply -f <pod-config.yaml>

kubectl delete --force -f <pod-config.yaml>

Example yaml:

Base fields for k8s resources:

apiVersion:
kind:
metadata:
spec:

Simple pod example that launches nginx container:

apiVersion: v1
kind: Pod
metadata:
    name: mynginx
spec:
    containers:
        - name: mynginx
          image: nginx

To run this pod, you would run kubectl apply -f simple-nginx.yaml

To see it running: kubectl get pods -o wide
Get logs: kubectl logs mynginx
See details: kubectl describe pod mynginx | less
Delete it: kubectl delete --force pod mynginx

When you run a pod, it gets an IP address which is local to the cluster network.

For simple testing, we will run a port forwarding from where kubectl is being run to the k8s network.

kubectl port-forward pod/mynginx 8000:80

curl 127.0.0.1:8000

## Controllers

We were just creating pods directly by applying a yaml file, but it is better to create another resource which then creates and manages pods.

A **deployment** is a type of controller in which you describe a desired state, and the deployment controller changes the actual state to the desired state at a controlled rate. Uses of a deployment include scale number of pods up or down, controlled upgrade/downgrade, and controlled update of pod spec.

Example yaml file:

apiVersion: apps/v1
kind: Deployment
metadata:
    name: mynginx-deployment
spec:
    replicas: 3
    etc...

**Replicas** specify how many pods to ensure are running
**Selector** says which pods to apply that condition to
**Template** specifies how to create a new pod

**Labels/selectors** are an arbitrary key-value pair you can attach to a resource (such as a Pod) and can be used for label selection.

- In yaml: 
metadata: 
    labels:
        app: nginx

- Via kubectl:
kubectl label pods mynginx app=nginx

kubectl get deployments shows all deployments, get pods shows all pods, or get all shows all resources

## Service

A service is an abstraction which defines a logical set of Pods and a policy by which to access them. It load balances between them and uses a selector to see which nodes should be in set (across scaling and failures). The service gets an IP address and it handles choosing pods to send a request to.

Example yaml:

apiVersion: v1
kind: Service
metadata:
    name: mynginx-service
spec:
    selector:
        app: nginx
    ports: 
        - protocol: TCP
          port: 80
          targetPort: 80

selector matches label of Pod (from deployment template)

kubectl describe service mynginx-service <-- shows info about the service

Endpoints shows IP addresses of the nodes in the service.