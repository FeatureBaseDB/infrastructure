# Pilosa Infrastructure in Azure


# requirements
1. [Go](https://golang.org/doc/install)
2. [Terraform](https://www.terraform.io/intro/getting-started/install.html)
3. [Azure CLI 2.0](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
4. [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
5. An ssh key on your local machine and ssh-agent. 

# usage
For testing and shortlived infrastructure, you may wish to deploy resources
directly from your local development machine. For production, and long lived
resources, especially those that may be shared by multiple users, it is
recommended to first deploy an "ops" host which will act as a bastion and shared
command and control point for the rest of the infrastructure. The `ops`
subdirectory contains terraform and ansible files for deploying and configuring
"ops". Part of the configuration process is pulling this repository on to ops so
that you may run the rest of these instructions from there.

Some general notes:

Both ops and pilosa terraform files support a "prefix" which you can use to
differentiate deployments - if multiple people try to deploy with the same
prefix, things will fail, so it's recommended that you set this to something
unique to you when you're deploying shortlived infrastructure. You can do this
by specifying a var file when doing terraform apply with the `-var-file` option. 
See example.vars for a, uh, example.

## ops

To deploy ops:
```
cd ops
az login
terraform init
terraform apply
# you'll have to type yes at a prompt
export OPS_IP=`terraform output -json | grep value | cut -d\" -f4`
echo $OPS_IP > ans_inventory.ini
```

Now the ops VM exists, but we need to install the various dependencies that are required for provisioning infrastructure. This is done with Ansible like so:

```
ansible-playbook -i ans_inventory.ini opsplaybook.yml
```

Now, confirm that you can log in to ops:

```
ssh ubuntu@$OPS_IP
```

We need to set up what's called a "service principal" so that ops can easily authenticate with Azure to provision resources.
```
az login
# you'll have to open a browser, access the given link, sign into your Azure account, and enter the given code
# that should print out subscription info - choose the one you want to use and substitute its id below.
az account set --subscription="aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeeef"
```

Use the values output by that last command to create a terraform variable file like so:
```
cd ~/go/src/github.com/pilosa/infrastructure/azure-terraform
echo 'client_id = "<appID>"' > credentials-file.tfvars
echo 'client_secret = "<password>"' >> credentials-file.tfvars
echo 'tenant_id = "<tenant>"' >> credentials-file.tfvars
echo 'ops_ip = "OPS_IP"' >> credentials-file.tfvars
echo 'subscription_id = "<id>"' >> credentials-file.tfvars
echo 'prefix_name = "<whatever_you_want>"' >> credentials-file.tfvars
```


## pilosa

We'll provision the infrastructure with terraform - if you're using ops, you
have to pass the credentials file as below. If you're deploying from your local
machine, you just need to run `az login` before running `terraform apply`.

OPS:
```
terraform init
terraform apply -var-file=credentials-file.tfvars
```

LOCAL:
```
az login
terraform init
terraform apply
```

Now we'll set up the ansible inventory file from the terraform outputs so that we can use ansible to configure our infrastructure.

```
go get github.com/pilosa/infrastructure/cmd/ansibilize
terraform output -json | ansibilize
```

Now run Ansible to configure and install everything.

```
ansible-playbook -i ans_inventory.ini playbook.yml -f 10
# you may have to type 'yes' a bunch of times since ansible is sshing to a bunch of unknown hosts.
# you can avoid this either by disabling the check via ansible config, 
# or setting up your known_hosts file properly ahead of time.
```
