# EKS CLuster Creation


Create bucket first 
terraform-eks-01

https://argoproj.github.io/argo-cd/getting_started/


aws sts get-caller-identity
aws eks --region us-east-1 update-kubeconfig --name upgrad-dev-eks-cluster
kubectl get svc

aws eks --region us-east-1 update-kubeconfig --name upgrad-dev-eks-cluster
Updated context arn:aws:eks:us-east-1:888662:cluster/upgrad-dev-eks-cluster in /home/swilliams/.kube/config
export KUBE_CONFIG=/home/swilliams/.kube/config  
kubectl get svc                     


Cleanup:
Destroy the cluster 
Destroy the VPC 

Tableau (2021.2.1 & up version) in RHEL7.9 image ONLY no CentOS7.9
Tableau-server-in-Kubernetes - 3 nodes Cluster
-------------------------------------------


## Features

- Infrastructure provision for EKS and VPC creation.

## Tech

This project involves using many open-source tools:

- [Terraform](https://www.terraform.io/) - Tools for infrastructure creation!

## Installation

Follow below links for tools installation
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

## Pre-requisite
- Make sure you create an S3 bucket which will be used for state-management (In this case "terraform-tfstate05082021")
- Make sure you have permission to deploy the infrastructure on AWS platform.
- Make sure you update ECR repo name in user-data.

## Terraform Code Structure

```sh
terraform/
   eks                   # EKS cluster
   networking/           # Network layer
```

#### Terraform Usage
[1] First you need to deploy the networking layer, use below command to do so.
```sh
$ cd networking
$ terraform init
$ terraform plan    # Plan the changes
$ terraform apply   # apply the changes
```
[2] Next, you need to deploy the eks cluster.
```sh
$ cd eks
$ terraform init
$ terraform plan    # Plan the changes
$ terraform apply   # apply the changes


