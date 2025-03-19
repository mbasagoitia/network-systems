# Kubernetes

https://www.youtube.com/watch?v=s_o8dwzRlu4&t=104s

Control plane nodes:

- Handful of master processes
- Must include backups because these nodes are very important
- Includes:
    - API server, which is the entry point into the cluster
    - Controller Manager, which keeps track of what is happening in the cluster
    - Scheduler, which ensures Pod placement
    - etcd, which is the k8s backing store. Snapshots can be used to recover cluster state

Worker nodes:

- Include kubelet, the primary node agent to communicate with each other
- Have containers of different applications deployed on them
- Actual work is happening in your application on the worker nodes

## Main Kubernetes Components

- Pod
- Service
- Ingress
- ConfigMap
- Secret
- Deployment
- StatefulSet
- DaemonSet

A **node** is a physical or virtual machine

A **pod** is the smallest unit of k8s. It is an abstraction over a container so that you only need to interact with the k8s layer (not the container runtime, such as Docker). Usually one application per pod.

Kubernetes offers a virtual network out of the box. Each pod gets its own IP address, and pods can communicate with each other with these internal IP addresses. However, pods are ephemeral and can "die" and be replaced, at which point a new IP address will be assigned. To solve this problem, we use a service.

A **service** is a static/permanent IP address that can be attached to each pod. Each pod will have its own service. An **external service** opens communication from external sources, such as the internet. You specify the type of service (internal (such as a database)/external (such as a web application)) on creation. Internal is the default type. A service is also a load balancer, so it forwards a request to a specific pod in some manner. You define blueprints, or **deployments** for pods and specify how many replicas of the pod you want to run. In practice, you don't create pods directly; you work with deployments.

Because we want to have a secure protocol and web address/forwarding, we first go through the **Ingress**, which does forwarding and routing into the cluster, and then into the service (for external communication).

**ConfigMap** is external configuration on your application, including database urls, other services, etc. You connect this to your pod so the pod can use this configuration data. 

IMPORTANT: ConfigMap is for non-confidential data only! If you need to configure secret data such as database credentials, use **Secret**, which is used similarly to ConfigMap. However, this is stored in a non-encrypted format (base 64 encoding) and is meant to be encrypted by a third party. To safely use secrets, do the following:

- Enable encryption at rest for Secrets
- Enable or configure  RBAC rules that restrict reading data in Secrets
- Also used mechanisms such as RBAC to limit which principals are allowed to create new Secrets or replace existing ones.

After connecting ConfigMap/Secret to your pods, you can use data from there as environment variables or as a properties file.

### Data Storage

If we have a database in a container/pod in our app and the container/pod restarts, the data would be lost.

To solve this, we can use **volumes**, which attaches a physical storage on a hard drive to the pod. The storage could be on a local machine or on remote storage (such as cloud or private storage). Storage is external from the k8s cluster. Kubernetes does not manage data persistence!

Databases cannot be replicated via deployment like other pods can, since it contains data (state).

**StatefulSet** is used specifically for stateful apps like databases. These types of apps should be created using StatefulSet, not deployments. This will take care of scaling up/down like deployments, but also makes sure reading/writing is synchronized so as to avoid database inconsistencies. It can be tedious to use StatefulSet, so it is common to host database applications somewhere else and only have the stateless applications in the cluster and communicate with the external database.

## Creating Resources and Configuring the Cluster

All configuration goes through the master node's API server via a UI tool, an API, or CLI (kubectl). Configuration requests are sent to the API server. Requests must be in yaml or json format and are in a declarative format (we declare what we want and Kubernetes Controller Manager tries to reconcile desired state with actual state).

Example yaml file:

apiVerison: apps/v1
kind: Deployment
metadata:
    name: my-app
    labels:
        app: my-app
spec:
    replicas: 2
    selector: 
        matchLabels: 
            app: my-app
    template:
        metadata:
            labels:
                app: my-app
        spec: 
            containers:
                - name: my-app
                  image: my-image
                  env: 
                    - name: SOME_ENV
                      value: $SOME_ENV
                  ports: 
                    - containerPort: 8080

Every configuration file has three main parts:

1. metadata of component (name, labels)
2. spec (replicas, selector, template, ports, etc.) <-- attributes are specific to kind (Service, Deployment, etc.)
    - template defines the pod configuration/blueprint and contains its own metadata and spec
3. status <-- this is automatically generated and added by k8s
    - Compares status of desired state and actual state, will fix if needed
    - How does it get this status data to adhere/continuously update? **etcd** holds the current status of any k8s component.

Store the configuration (yaml) files in your application code.

**Labels** can be given to any k8s component, which are key-value pairs attached to resources. They are identifiers which should be meaningful and relevant to users. Labels do not provide uniqueness; all pod replicas will have the same label. Allows deployment to connect to all pod replicas. Labels are required for pods.

Which pods belong to a deployment? We specify this in the selector -> matchLabels field in deployment spec. All pods that match that label belong to this deployment. It is standard to use the "app" key and the name of the application you're running as the value when defining deployments.

## Minikube and Kubectl

In a production cluster setup, you will have multiple master and worker nodes.

Minikube is a cluster on one virtual node where the master processes and worker processes all run on one node with Docker container runtime pre-installed. This is very helpful for testing/local cluster setup.

**Kubectl** is the command line tool for interacting with the k8s cluster. Sends commands to API server. Kubectl can be used for any type of cluster setup, not just minikube.

Minikube can run either as a container (Docker) or VM on your machine. Install minikube and run minikube start --driver docker

When you do this, kubectl gets installed as a dependency.

- kubectl get node <-- displays all nodes in cluster

Sample project structure:

Web app with database: 4 config files

You can reference Kubernetes documentation for starting points of configuration files to copy

1. ConfigMap with MongoDB endpoint
    - In the config file under "data", we will add our key value pairs. mongo-url: <mongoDB-service-name> (mongo-url: mongo-service)
2. Secret with MongoDB username and password
    - In the config file under "data", we have key-value pairs such as mongo-user: <encoded-value>
        - To encode a value, in the terminal type echo -n mongousername | base64

These Secret and ConfigMap resources (external configurations) can now be referenced by different Deployments.

3. Deployment/service of MongoDB application and internal service (remember you would want to use StatefulSet, but for this example we are using a deployment)
    - It is common to put the configuration for the deployment and service together in one yaml file. Make sure to separate yaml blocks with --- (separate deployment config from service config in the same file)
    - You can find images for MongoDB and other resources in Docker Hub.
    - In service config, name of the service should match the endpoint we defined in mongo-config for secret/configMap
    - selector needs to be defined so that the service can select pods to forward the request to, and should match the label of the pods that belong to the service.
    - port: service port; targetPort: containerPort of deployment. Should match containerPort defined in the deployment config. This is where the service should forward the request to.
4. Deployment/service of a web app with external service
    - Here is where you will define an image (which may be a nodejs application) to deploy

### Configuring Environment Variables in Container Configuration

Inside of your database deployment config, under template -> spec -> containers, add an env field with a list of values (- name: value: ). Each db expects a certain name value, such as MONGO_INITDB_ROOT_USERNAME (check what this value is in image specs in docker hub). Populate the value field by referencing from secret/configMap. Change name of value to valueFrom: secretKeyRef: name: mongo-secret key: mongo-user

Web app also needs to know database endpoint and which username/password to use for authentication. This is defined in web-app config file under template -> spec -> containers -> env as a list of values (name (of env variable): valueFrom: secretKeyRef (for secrets) OR configMapKeyRef (configMap variables): name: key)

### Configuring External Service

We want our app to be accessible from the browser. We will adjust the service configuration to be an external service. In the service config under spec, set type: NodePort (default is ClusterIP, which is internal). Requires a third port under the ports field called nodePort. nodePort exposes a Service on each node's IP at a static port. With the combination of NodeIP and NodePort, we can access this service which will give external access to the pods. nodePort must be between 30000 and 32767.

### Deploying Resources in Minikube Cluster

IMPORTANT: ConfigMap and Secret must exist before Deployments because the other deployments access them during creation. Then database must exist before web app.

- minikube start
- kubectl apply -f mongo-config.yaml
- kubectl apply -f mongo-secret.yaml
- kubectl apply -f mongo.yaml
- kubectl apply -f webapp.yaml

### Interacting with the Cluster

- kubectl get all <-- shows all cluster components
- kubectl get configmap OR kubectl get secret
- kubectl get pod
- kubectl --help
- kubectl describe service webapp-service
- kubectl describe pod <pod-name>
- kubectl logs <pod-name>

### Access the Web App from the Browser

The NodePort Service is accessible on each worker node's IP address.

- kubectl get service; note the NodePort port (if you see something like 3000:30100, use the second half: 30100)
- minikube ip <-- does same as below
- kubectl get node -o wide <-- gives internal IP address of the node