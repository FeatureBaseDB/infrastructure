.PHONY: require-% init plan apply refresh plan-destroy destroy ssh status provision-%

PUBLIC_IP=$(shell terraform output -state=$(TF_STATE) -json | jq -r ".public_ip.value")

export TF_VAR_hostname_prefix=$(HOSTNAME_PREFIX)
TF_ARGS=-var-file=vars.tfvars
export ANSIBLE_HOST_KEY_CHECKING=false

TF_WORKSPACE=$(shell terraform workspace show)
HOSTNAME_PREFIX=$(USER)-$(TF_WORKSPACE)
ANSIBLE_HOSTS=$(PUBLIC_IP),

# Halt the process if the command is not present (currently all checked commands have valid "--version" subcommands)
require-%:
	@$* --version &> /dev/null

init: require-terraform
	terraform init

plan: require-terraform
	terraform plan $(TF_ARGS)

apply: require-terraform
	terraform apply $(TF_ARGS)

plan-destroy: require-terraform
	terraform plan -destroy $(TF_ARGS)

destroy: require-terraform
	terraform destroy $(TF_ARGS)

output: require-terraform
	terraform output -state=$(TF_STATE)

ssh: require-terraform require-jq
	ssh -o UserKnownHostsFile=/dev/null \
		-o StrictHostKeyChecking=no \
		-l ubuntu \
		$(PUBLIC_IP) "$(CMD)"

provision-%: require-jq require-terraform require-ansible
	ansible-playbook \
		-e 'ansible_python_interpreter=/usr/bin/python3' \
		-i $(ANSIBLE_HOSTS) \
		$(ANSIBLE_ARGS) ../../../ansible/$*.yml
