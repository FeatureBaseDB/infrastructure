Pilosa Tools for Infrastructure and Operations
==============================================

cfn-sandbox-basic
-----------

Start here. Sets up top level resources to be used by cfn-pilosa-qaz when
creating Pilosa clusters. See the [README](./cfn-sandbox-basic/README.md) in this directory for instructions.

cfn-pilosa-qaz
--------------

Cloudformation tools for creating Pilosa clusters with [Qaz](https://github.com/daidokoro/qaz). Set up your sandbox first, then follow the instructions in this [README](./cfn-pilosa-qaz/readme.md).

cfn-pilosa [deprecated]
----------

Cloudformation tools for creating Pilosa clusters. Deprecated in favor of cfn-pilosa-qaz.


cfn-sandbox [internal]
---------------------

Sandbox Cloudformation template generator for Pilosa Corp's dev sandbox. Outside users can ignore.

cfn-sandbox-dedicated [internal]
---------------------

Sandbox Cloudformation template generator for Pilosa Corp's dev sandbox with
AWS dedicated servers. Outside users can ignore.

local
-----

Utilities for running Pilosa locally

ansible
-------

Ansible playbooks, used by Makefiles in terraform subdirectory

terraform
---------

Terraform modules, including some helper Makefiles
