include ../taxi-include/Makefile

CLOUD=OCI
SHAPE=$(shell grep -e "^instance_shape=" vars.tfvars | cut -d"=" -f 2 | sed 's/"//g')
COUNT=$(shell grep -e "pilosa_cluster_size=" vars.tfvars | cut -d"=" -f 2 | sed 's/"//g')
USERNAME=opc

