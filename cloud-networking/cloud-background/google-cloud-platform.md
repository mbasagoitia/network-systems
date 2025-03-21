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

# Terraform

**Infrastructure as Code** refers to the concept of bringing software practices to the management of infrastructure. We can describe it in a code/textual format, push it to github, do code reviews, etc.

Terraform is a declarative IaC framework.

Used for provisioning infrastructure (infrastructure as code), which includes launching VMs, specifying the network, etc.

To use, install terraform and gcloud

There are cloud-specific tools such as AWS Cloud Formation, Google Deployment Manager, Azure Resource Manager, as well as cloud agnostic tools like Terraform and Pulumi

Architecture:

- DevOps engineer uses Terraform tools to create Terraform manifest files (.tf)
- Terraform manages locally and interfaces with cloud providers (GCP, AWS, etc.)
- Terraform reaches out to the cloud provider and provisions the resources you specified. Runs a reconciliation loop to keep state updated.

## Terraform with GCP Example

A **service account** is a special kind of account typically used by an application or compute workload, such as a Compute Engine instance, rather than a person. You can create a service account under the IAM & Admin tab -> service accounts in the Google Cloud Console. Click on the service account and create a private key that you can download as JSON.

Select a role, which determines specific permissions to run different infrastructure types. For this example we will use Compute Engine Service Agent. Go to keys, create new private key, and download it.

Inside of the main.tf and provider.tf files, resources and providers will be indicated.

Providers: 

We specify credentials, which is the JSON private key that you should have saved. Also specify project (with project id), region, and zone.

Resources:

Name, machine_type, zone, network interface, boot_disk, metadata

To start Terraform:

- terraform init (initializes directory, downloads provider, installs plugins)
- terraform plan (looks at infrastructure and determines which changes to make)
- terraform apply (applies those changes)

Now you should be able to see VM in the Google Cloud Console.

- terraform show (shows info about the infrastructure)
- terraform destroy (deletes all infrastructure)

Note that nat_ip is the same as external ip