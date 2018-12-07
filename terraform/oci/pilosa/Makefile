include ../../include/Makefile

N=0
CMD=
PILOSA_VERSION=master
PILOSA_PRIVATE_IP=$(shell terraform output -json | jq -r ".private_ips.value[$(N)]")
PILOSA_GOSSIP_SEEDS=$(shell terraform output -json | jq -c "[.private_ips.value[] | . + \":14000\"]")
PILOSA_PUBLIC_IP=$(shell terraform output -json | jq -r ".public_ips.value[$(N)]")
PILOSA_PUBLIC_IPS=$(shell terraform output -json | jq -r ".public_ips.value|join(\",\")")
PUBLIC_IP=$(PILOSA_PUBLIC_IP)
ANSIBLE_HOSTS=$(PILOSA_PUBLIC_IPS),

TF_ARGS=-var-file=vars.tfvars
ANSIBLE_ARGS=-e version=$(PILOSA_VERSION) -e gossip_seeds='$(PILOSA_GOSSIP_SEEDS)'

status: require-terraform
	$(MAKE) ssh CMD="curl -s $(PILOSA_PRIVATE_IP):10101/status"

provision: provision-pilosa
