# Terraform modules for Pilosa

This is a collection of [Terraform modules](https://www.terraform.io/docs/modules/usage.html) and tooling to create Pilosa clusters.

## Usage

Each module contains a Makefile to simplify interaction with Ansible and Terraform. It is not necessary to use the Makefile, as each directory is a standard Terraform module.

To get started,

1. Copy or modify one of the examples. The `oci-pilosa-agent` module is a good starting point if you need a Pilosa cluster and an accompanying "agent" instance.
2. Rename `vars.tfvars.example` to `vars.tfvars` and set any needed values.
3. Run `make init`, which runs `terraform init`.
4. Run `make apply`, which runs `terraform apply` with some flags.
5. Run `make provision`, which runs `ansible-playbook` with some flags. (Steps 3-5 can be reduced to `make init apply provision`).
6. Run `make ssh` to ssh to the created instance. For Pilosa clusters, run `make ssh N=2` to ssh to node 2. For agent instances, run `make ssh-agent`.
7. Run `make destroy` to destroy the infrastructure.

The following commands are available globally:

* make init  
`terraform init`

* make apply  
`terraform apply` with flags.

* make destroy  
`terraform destroy` with flags.

* make plan  
`terraform plan` with flags.

* make plan-destroy  
`terraform plan -destroy` with flags.

* make output  
`terraform output` with flags.

* make ssh  
Create SSH connection to main instance (depends on module. Uses value of `$(PUBLIC_IP)`).

* make provision  
Provisions the infrastructure with Ansible.

* make provision-* (e.g. "make provision-pilosa")  
Provisions the infrastructure with Ansible using specific Ansible playbook from top-level ansible directory.

## Tips

* Use `make -n` (dry-run) to see the commands that will run.

## Modules

### oci

Terraform modules for Oracle Cloud Infrastructure

#### agent

Single node agent, used by benchmarks

#### codespeed

Module to provision Codespeed instance for tracking benchmark results

#### network

Set up VCN, security lists, and base subnets

#### ops

A basic utility server

#### pilosa

Module to create a Pilosa cluster with variable number of nodes

### examples

Examples of multi-module infrastructure

#### oci-pilosa-fullstack

This sets up a fully isolated Pilosa cluster including the needed VCN and security lists. To launch a cluster in an existing subnet, use the simpler pilosa module in ./oci/pilosa.

#### oci-pilosa-agent

This sets up a pilosa cluster with an accompanying "agent" which can be used to execute benchmarks or run imports against the cluster

### include

This is not a Terraform module. It contains a base Makefile that is included in other Makefiles.
