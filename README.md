Pilosa Tools for Infrastructure and Operations
==============================================

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
