include ../taxi-include/Makefile

CLOUD=GCP
SHAPE=$(shell grep -e "pilosa_machine_type=" vars.tfvars | cut -d"=" -f 2 | sed 's/"//g')
COUNT=$(shell grep -e "pilosa_cluster_size=" vars.tfvars | cut -d"=" -f 2 | sed 's/"//g')
