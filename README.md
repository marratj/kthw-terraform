# A Terraform version of Kubernetes The Hard Way

This is my implementation of [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way) in Terraform on Microsoft Azure instead of Google Cloud Platform.

I'm doing this for 

1. The learning experience of setting Kubernetes up the hard way in a different Cloud than GCP (Azure in my case)
2. To see how deep I can dig into Terraform in the process of doing the above
3. To share what I learnt with the world

This is a work in progress and I update it whenever I find time to do so.

Most probably there will be multiple refactors of the Terraform code, every time I think there might be another way to carry out a certain task.

## SSH Agent

The private key to `node_ssh_key` for accessing the VMs needs to be loaded in your SSH agent (for copying over the certificates to the instances).

## Chapter 03 - Provisioning Compute Resources

https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/03-compute-resources.md

This is achieved with the following Terraform modules:

- [modules/vnet](modules/vnet)
  - This module creates the overall resource group with supporting infrastructure, like:
  - a VNET
  - a Subnet
  - some default security groups for SSH & HTTPS access
- [modules/lb](modules/lb)
  - This module creates a load balancer which is either put in front of the: 
  - master nodes for apiserver access
  - worker nodes for later workload access
- [modules/lb_rule](modules/lb_rule)
  - This module creates a rule for an existing load balancer (for now SSH access to provision the certs & consul to our instances)
- [modules/vms](modules/vms)
  - This module creates the actual VMs and takes some parameters for naming, instance size, networking & load-balancer allocation
  - This currently deploys Ubuntu 16.04 VMs with a Consul agent running