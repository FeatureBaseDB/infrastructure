include ../../oci/pilosa/Makefile

PILOSA_PRIVATE_IP=$(shell terraform output -json | jq -r ".pilosa_private_ips.value[$(N)]")
PILOSA_GOSSIP_SEEDS=$(shell terraform output -json | jq -c "[.pilosa_private_ips.value[] | . + \":14000\"]")
PILOSA_PUBLIC_IP=$(shell terraform output -json | jq -r ".pilosa_public_ips.value[$(N)]")
PILOSA_PUBLIC_IPS=$(shell terraform output -json | jq -r ".pilosa_public_ips.value|join(\",\")")
AGENT_PUBLIC_IP=$(shell terraform output -json | jq -r ".agent_public_ip.value")
HOSTS=$(PILOSA_PUBLIC_IPS),
ANSIBLE_ARGS_FINAL=-i $(HOSTS) -e version=$(PILOSA_VERSION) -e gossip_seeds='$(PILOSA_GOSSIP_SEEDS)' $(ANSIBLE_ARGS)

provision:
	$(MAKE) provision-pilosa
	$(MAKE) provision-agent provision-pdk ANSIBLE_HOSTS=$(AGENT_PUBLIC_IP),

ssh-agent:
	$(MAKE) ssh PUBLIC_IP=$(AGENT_PUBLIC_IP)

run-agent:
	$(MAKE) run HOSTS=$(AGENT_PUBLIC_IP),
