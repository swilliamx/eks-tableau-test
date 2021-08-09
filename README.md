# EKS CLuster Creation

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


