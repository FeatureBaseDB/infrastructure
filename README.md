Pilosa Tools for Infrastructure and Operations
==============================================

Hello!

You probably are here because you want a quick and easy way to deploy
Pilosa and associated utilities on your cloud provider of
choice. You're in the right place. Check out the "getting started"
section just below to see supported cloud providers, and some basic
info on what you'll need to do to use the tools in this repository
with that provider.

The main things provided in this repository are:

1. `terraform` for deploying infrastructure on various cloud
   providers. This includes getting servers/vms, setting up
   networking, firewalls, ssh access, etc.

2. `ansible` configs for installing Pilosa and related utilities once
   you have a set of servers with SSH access.

You can use these tools together, or separately, and there are some
examples of using them together along with some Makefiles to smooth
out the whole process under `terraform/examples`. Check out the
[readme](terraform/examples/README.md) there for more info.

getting started
---------------

### GCP

You need to download a credentials.json from https://console.cloud.google.com/apis/credentials and reference it from your tfvars.

### OCI

You need an OCI api key and set up your tfvars to point to it.

### AWS

You need a .aws/credentials file set up.

### Azure

You need to `az login`.




terraform
-----------

Contains terraform modules for deploying Pilosa infrastructure in various cloud providers.


ansible
-------

Ansible playbooks, used by Makefiles in terraform subdirectory


local
-----

Utilities for running Pilosa locally

deprecated
-----

Contains deprecated tooling for deploying Pilosa et al. using cloudformation and/or terraform.
