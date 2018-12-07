include ../../oci/pilosa/Makefile

PILOSA_PRIVATE_IP=$(shell terraform output -json | jq -r ".pilosa_private_ips.value[$(N)]")
PILOSA_GOSSIP_SEEDS=$(shell terraform output -json | jq -c "[.pilosa_private_ips.value[] | . + \":14000\"]")
PILOSA_PUBLIC_IP=$(shell terraform output -json | jq -r ".pilosa_public_ips.value[$(N)]")
PILOSA_PUBLIC_IPS=$(shell terraform output -json | jq -r ".pilosa_public_ips.value|join(\",\")")
AGENT_PUBLIC_IP=$(shell terraform output -json | jq -r ".agent_public_ip.value")

provision:
	ANSIBLE_HOSTS=$(PILOSA_PUBLIC_IPS), $(MAKE) provision-pilosa 
	ANSIBLE_HOSTS=$(AGENT_PUBLIC_IP), $(MAKE) provision-agent

ssh-agent:
	$(MAKE) ssh PUBLIC_IP=$(AGENT_PUBLIC_IP)
