# Google Cloud Platform (GCP)

Gives $300 credit to new users!

Create account and go to console.cloud.google.com

Create a new project

## Creating a VM

Google has lots of datacenters; as developers, we can create a VM on one of them.

Nav menu -> compute engine -> VM instances OR use search bar at top to find VM instances

Create instance

Choose name, region (us-central tends to be cheaper) and zone

Choose E2 machine configuration

Machine type: micro

Leave default settings and create

You now have 2 IP addresses: internal is private, accessible from other VMs that you launch in same network, and external is the public internet address

Press SSH button to connect via ssh; will transfer keys and open a terminal in the browser

## gcloud

gcloud is a CLI provided by google. You can access the VM via a terminal, but you will need to authenticate manually.

- gcloud init
- create new configuration
- name it
- login with new account
- copy url to login and get auth code
- gcloud config configurations list <- shows all configurations
- gcloud config configurations delete <config name> <- deletes configuration
- gcloud config configurations activate default

Now, we can use gcloud to ssh into VM. In google cloud console, click menu button by SSH button and click "view gcloud command"

Type "exit" to exit the VM

## Cloud Shell

There is a button near the top, "activate cloud shell" that creates a restricted VM running Linux with gcloud installed.

## Deleting a VM

Go to VM instances in cloud console, select the VM, stop it, and delete it.