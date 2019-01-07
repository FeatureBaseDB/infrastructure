include ../../oci/pilosa/Makefile

AGENT_PUBLIC_IP=$(shell terraform output -json | jq -r ".agent_public_ip.value")

PROVISION = provision-pilosa-agent

provision-pilosa-agent:
	$(MAKE) provision-pilosa
	$(MAKE) provision-agent provision-pdk HOSTS=$(AGENT_PUBLIC_IP),

ssh-agent:
	$(MAKE) ssh PUBLIC_IP=$(AGENT_PUBLIC_IP)

run-agent:
	$(MAKE) run HOSTS=$(AGENT_PUBLIC_IP),
