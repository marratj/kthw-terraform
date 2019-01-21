# A Terraform version of Kubernetes The Hard Way

[![CircleCI](https://circleci.com/gh/marratj/kthw-terraform.svg?style=svg)](https://circleci.com/gh/marratj/kthw-terraform)

This is my implementation of [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way) in Terraform on Microsoft Azure instead of Google Cloud Platform.

I'm doing this for 

1. The learning experience of setting Kubernetes up the hard way in a different Cloud than GCP (Azure in my case)
2. To see how deep I can dig into Terraform in the process of doing the above
3. To share what I learnt with the world

This is a work in progress and I update it whenever I find time to do so.

Most probably there will be multiple refactors of the Terraform code, every time I think there might be another way to carry out a certain task.

## Client tools prerequisites

You need to have kubectl installed for interacting with the cluster and also for Terraform to be able to generate configuration files.

Download the current release from https://storage.googleapis.com/kubernetes-release/release/v1.10.2/bin/linux/amd64/kubectl

Also, you obviously need to have Terraform installed for running the code in this repository.

Download the current version from https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip

Next, for Terraform to be able to authenticate with Azure, you either need to set up a service principal in your Azure account (https://www.terraform.io/docs/providers/azurerm/authenticating_via_service_principal.html) or have Azure CLI installed (https://www.terraform.io/docs/providers/azurerm/authenticating_via_azure_cli.html)

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

## Chapter 04 - Provisioning a CA and Generating TLS Certificates

https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md

This is achieved with the following Terraform module:

[modules/pki](modules/pki)

- This module creates the PKI infrastructure for the cluster:
  - the Certificate Authority
  - an Admin Client certificate
  - a Kubelet Client certificate per node
  - the kube-proxy Client certificate
  - the apiserver Server certificate
- also, it distributes the keys and certificates to the appropriate instances
  - the CA key & cert to the apiserver instances
  - the apiserver key & cert to the apiserver instances
  - the kubelet keys & certs per node to the worker instances
  - the CA cert to each worker instance

## Chapter 05 - Generating Kubernetes Configuration Files for Authentication

https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/05-kubernetes-configuration-files.md

This is achieved with the following Terraform module:

[modules/kubeconfig](modules/kubeconfig)

- This module creates the client authentication configs for the kubelet and kube-proxy
  - it does so by calling the appropriate `kubectl config` commands 
  - and copying the kubeconfig files to each node

## Chapter 06 - Generating the Data Encryption Config and Key

https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/06-data-encryption-keys.md

This is achieved with the following Terraform module:

[modules/encryption_config](modules/encryption_config)

- This module creates the encryption config YAML file and copies it to the master nodes

## Chapter 07 - Bootstrapping etcd

https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/07-bootstrapping-etcd.md

This is achieved with the following Terraform module:

[modules/etcd](modules/etcd)

- This module bootstraps the etcd cluster on the controller nodes

We construct a fake dependency with the apiserver & CA certs here by using the internal resource IDs of those (after their respective creation) as input for the etcd module, so we can ensure that the etcd module will only be created once the certificate files are available (as we need to copy them into the etcd config dir).
