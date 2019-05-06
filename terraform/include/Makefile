.PHONY: require-% init plan apply refresh plan-destroy destroy ssh provision provision-% inventory.json ansible-roles

PUBLIC_IP=$(shell terraform output -state=$(TF_STATE) -json | jq -r ".public_ip.value")

export TF_VAR_prefix_name=$(PREFIX_NAME)
TF_VARS=vars.tfvars
TF_ARGS=
TF_ARGS_FINAL=-var-file=$(TF_VARS) $(TF_ARGS)
TF_WORKSPACE=$(shell terraform workspace show)

export ANSIBLE_HOST_KEY_CHECKING=false
USERNAME=ubuntu
ANSIBLE_DIR=../../../ansible
ANSIBLE_TARGET=all
INVENTORY_GENERATOR_JQ={pilosa:{hosts:(.pilosa_public_ips.value | to_entries | map({("pilosa" + (.key|tostring)): {ansible_host: .value, ansible_user: "$(USERNAME)"}}) | add)}}
HOSTS_LINE_JQ=.pilosa_public_ips.value + [.agent_public_ip.value] | reduce .[] as $$ip (""; . + " " + $$ip)

PREFIX_NAME=$(USER)-$(TF_WORKSPACE)
HOSTS=$(PUBLIC_IP),

PROVISION=

help:           ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed 's/:.*##/: ##/' | awk -F"##" '{printf "%-24s%s\n", $$1, $$2}'


# Halt the process if the command is not present (currently all checked commands have valid "--version" subcommands)
require-%:
	@command -v $* >/dev/null 2>&1

init: require-terraform  ## Initialize terraform in this directory.
	@terraform init

plan: require-terraform  ## Show the Terraform plan.
	@terraform plan $(TF_ARGS_FINAL)

apply: require-terraform  ## Create infrastructure using Terraform.
	@terraform apply $(TF_ARGS_FINAL)

plan-destroy: require-terraform
	terraform plan -destroy $(TF_ARGS_FINAL)

destroy: require-terraform  ## Destroy all infrastructure.
	@terraform destroy $(TF_ARGS_FINAL)

output: require-terraform  ## Runs "terraform output" to see the state of infrastructure. (IP addresses, etc.)
	@terraform output -state=$(TF_STATE) -json

ssh: require-terraform require-jq  ## ssh to Pilosa host. Use N=<int> to specify a particular host.
	@ssh -o UserKnownHostsFile=/dev/null \
		-o StrictHostKeyChecking=no \
		-l $(USERNAME) \
		$(SSH_ARGS) \
		$(PUBLIC_IP) "$(CMD)"

provision-%: require-jq require-terraform require-ansible inventory.json  ## Provision a particular Ansible module. e.g. "make provision-agent" would run agent.yml
	@ansible-playbook -i inventory.json $(ANSIBLE_ARGS_FINAL) $(ANSIBLE_ARGS_EXTRA) $(ANSIBLE_DIR)/$*.yml

ssh-config: require-terraform require-jq
	@echo ""
	@echo "Host	`$(MAKE) -s output | jq -r '$(HOSTS_LINE_JQ)'`"
	@echo "	Port 22"
	@echo "	IdentityFile $$(sed -ne '/ssh_public_key/ { s/.*="//; s/.pub"$$//; p; }' $(TF_VARS))"

update-ssh-config:
	@$(MAKE) -s ssh-config >> ~/.ssh/config

inventory.json: require-terraform require-jq
	@$(MAKE) -s output | jq '$(INVENTORY_GENERATOR_JQ)' > $@ || (echo >&2 "failing terraform output:"; $(MAKE) -s output)

provision:  ## Use Ansible to install software and configuration.
	@$(MAKE) -s ansible-roles $(PROVISION)

ANSIBLE_TARGET=all
ANSIBLE_MODULE=ping

ansible: require-ansible inventory.json
	@ansible -i inventory.json $(ANSIBLE_TARGET) -m $(ANSIBLE_MODULE) $(ANSIBLE_ARGS_EXTRA)

ansible-roles:
	@ansible-galaxy install -r ../../../ansible/requirements.yaml

run:  ## Run command specified as CMD=blah using Ansible on remote hosts.
	@$(MAKE) ansible ANSIBLE_MODULE=shell ANSIBLE_ARGS_EXTRA='-a "$(CMD)"'

ping:  ## Run Ansible ping.
	@$(MAKE) ansible ANSIBLE_MODULE=ping
