include ../taxi-include/Makefile

CLOUD=Azure
SHAPE=$(shell grep -e "^pilosa_vm_size=" vars.tfvars | cut -d"=" -f 2 | sed 's/"//g')
COUNT=$(shell grep -e "pilosa_cluster_size=" vars.tfvars | cut -d"=" -f 2 | sed 's/"//g')
USERNAME=ubuntu
