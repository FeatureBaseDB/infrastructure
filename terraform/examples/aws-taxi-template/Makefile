include ../taxi-include/Makefile

CLOUD=AWS
SHAPE=$(shell grep -e "^pilosa_instance_type=" vars.tfvars | cut -d"=" -f 2 | sed 's/"//g')
COUNT=$(shell grep -e "pilosa_cluster_size=" vars.tfvars | cut -d"=" -f 2 | sed 's/"//g')
USERNAME=ec2-user

