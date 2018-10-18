.PHONY: require-% init plan apply plan-destroy destroy

TF_ARGS="-var-file=vars.tfvars"

require-%:
	$* --version &> /dev/null

init: require-terraform
	terraform init

plan: require-terraform
	terraform plan $(TF_ARGS)

apply: require-terraform
	terraform apply $(TF_ARGS)

plan-destroy:
	terraform plan -destroy $(TF_ARGS)

destroy:
	terraform destroy $(TF_ARGS)
