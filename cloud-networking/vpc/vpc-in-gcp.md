# Creating a VPC in Google Cloud Platform

- Top left menu -> VPC Networks
- Google creates one by default
- To create our own, click "Create VPC Network" at top
- Custom subnet, choose region (US central1)
- Give IP address range (such as 10.0.1.0/24)
- Leave firewall for now, we will create manually later
- Click create

Now we will create a VM to add to the VPC (follow instructions from previous lecture)

- Under advanced options -> networking, choose VirtIO for Network performance configuration and choose the VPC and subnet you just created under Network interfaces
- Leave internal and external IP addresses as ephemeral
- Choose standard network service tier
- Under Management tab, you can specify metadata and startup script if desired

## Firewall Rules in GCP

By default, everything is dropped so we need to explicitly defined what traffic is allowed in our firewall rules

Two ways:
- Search for firewall (will show all rules for all VPCs)
- VPC Networks -> click on the VPC -> click on Firewall tab
    - Go to targets and choose all instances in the network
    - You could also give specific VMs a tag (such as backend, frontend, etc. and target by tag)
    - Specify which traffic to allow from source/destination (0.0.0.0/0 indicates all)
    - Under protocols and ports, choose TCP and add ports 22 (ssh) and 1234 (custom). Also check "other" and type icmp. Best practice not to choose allow all

## Creating VPC in Terraform

We will create the same configuration as above through Terraform

- Code available in course github repo

- In tf-mod2-demo1, open main.tf and provider.tf
- The resource block type should be "google_compute_network" which is a VPC
- The subnet is a resource called "google_compute_subnetwork," under which we can specify name, ip_cidr_range, region, and network
- The firewall rule is the resource "google_compute_firewall" and you can specify which network (VPC) it is part of, what to allow (protocol, ports), and source_ranges
- The VPC needs to be up before you can create the firewall rule
- Next, create the VM "google_compute_instance"
    - network_interface will contain information on the VPC and subnet (instead of standard)

Terraform commands

- terraform init
- terraform plan
- terraform apply (now you can view in GCP console)
- terraform destroy <-- don't forget to run this when you're done testing!!!

## Testing the Firewall Rules

**netcat** is a simple unix utility that reads and writes data across network connections using TCP or UDP

- server> (ssh into the VM) nc -l -p 1234 // listen on port 1234
- client> (from terminal) echo "blah" | nc 1.2.3.4 1234 // connect to port 1234
- Notice that it only works from port 1234 because of our firewall rules

**socat** (socket cat) allows you to specify the src,opt1,op2 and dst,opt1,op2

src: 
- - (for std in)
- tcp-listen:port
- openssl-listen:port

dst:
- - (for std out)
- tcp4, tcp6 -- connect to TCP endpoint

Examples:

- socat - tcp4:1.2.3.4:8080 <-- run on source; everything received on std in will be sent to node 2 port 8080 via tcp
- socat tcp4-listen:8080 - <-- run on sink; everything received on tcp port 8080 will be sent to std out