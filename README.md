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