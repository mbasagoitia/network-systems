# Autoscaling

Uses managed instance groups

Autoscaling:

- Monitors usage and creates or kills instances as needed
- Threshold-based
    - e.g. when CPU utilization gets above 50%, launch a new VM
- Predictive
    - Monitor load, use machine learning to predict next load in next [time]

Need to use an image in an instance template so it can automatically start new VMs with an provisioned image

Creating an image:

Choose a name, source as disk, and then choose your vm as source disk (whatever software is installed on that vm will be used as the image), and choose regional vs multi-regional

Now, create your instance group and choose managed instance group.

Create a new instance template

Configure autoscaling

## Metadata Server

When a VM starts, we want to provide configuration information (script, etc.)

This is done by the metadata service (similar mechanisms in all cloud services)

169.254.169.254 is a reserved IP address. Link local is never routed; it's local to the current network only.

It provides:

- DNS server
- NTP (time) server
- Metadata service as a web interface

To access metadata, we can use any web method (curl, wget)

On boot, startup scripts extract some of the metadata (startup script)

This is useful for auto-provisioning of services (getting custom configuration based on server, etc.)