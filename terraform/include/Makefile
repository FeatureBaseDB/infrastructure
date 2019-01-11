.PHONY: require-% init plan apply refresh plan-destroy destroy ssh provision provision-%

PUBLIC_IP=$(shell terraform output -state=$(TF_STATE) -json | jq -r ".public_ip.value")

export TF_VAR_prefix_name=$(PREFIX_NAME)
TF_ARGS=
TF_ARGS_FINAL=-var-file=vars.tfvars $(TF_ARGS)
TF_WORKSPACE=$(shell terraform workspace show)

export ANSIBLE_HOST_KEY_CHECKING=false
ANSIBLE_ARGS=
ANSIBLE_ARGS_FINAL=-i $(HOSTS) $(ANSIBLE_ARGS)
ANSIBLE_DIR=../../../ansible

PREFIX_NAME=$(USER)-$(TF_WORKSPACE)
HOSTS=$(PUBLIC_IP),

PROVISION=

# Halt the process if the command is not present (currently all checked commands have valid "--version" subcommands)
require-%:
	@command -v $* &>/dev/null

init: require-terraform
	terraform init

plan: require-terraform
	terraform plan $(TF_ARGS_FINAL)

apply: require-terraform
	terraform apply $(TF_ARGS_FINAL)

plan-destroy: require-terraform
	terraform plan -destroy $(TF_ARGS_FINAL)

destroy: require-terraform
	terraform destroy $(TF_ARGS_FINAL)

output: require-terraform
	@terraform output -state=$(TF_STATE) -json

ssh: require-terraform require-jq
	ssh -o UserKnownHostsFile=/dev/null \
		-o StrictHostKeyChecking=no \
		-l ubuntu \
		$(PUBLIC_IP) "$(CMD)"

provision-%: require-jq require-terraform require-ansible
	ansible-playbook \
		-e 'ansible_python_interpreter=/usr/bin/python3' \
		$(ANSIBLE_ARGS_FINAL) $(ANSIBLE_DIR)/$*.yml

inventory.json:
	$(MAKE) output | jq '.pilosa_public_ips.value | map({(.): null}) | add | {pilosa: {hosts: .}}' > $@

provision:
	$(MAKE) $(PROVISION)

run:
	ansible \
		all \
		-i $(HOSTS) \
		-e 'ansible_python_interpreter=/usr/bin/python3' \
		-u ubuntu \
		-m shell \
		-a "$(CMD)"
