# Quick Start
Deploy a Pilosa Cluster and an "agent" node from which to run ingest,benchmarks,UI servers, etc. The agent will include the [PDK](github.com/pilosa/pdk), [tools](github.com/pilosa/tools), [Jaeger](https://www.jaegertracing.io), and more.

1. Clone github.com/pilosa/infrastructure and change into it.
2. `cd terraform/examples`
3. Choose a cloud provider and follow the instructions in the [top level README](../../README.md) to get credentials set up.
4. Copy a <cloud>-taxi-template directory to a descriptively named
   directory. e.g. `cp -r oci-taxi-template
   oci-taxi-DenseIO2.16-3node` Don't worry about the "taxi"
   stuff... the Makefile includes some commands specifically for
   running some benchmarks, but also a lot of general purpose tools.
5. Change into that new directory. e.g. `cd oci-taxi-DenseIO2.16-3node`
6. Copy vars.tfvars.example to vars.tfvars and change things (like the
   number of nodes, instance types, etc). Some of the clouds require
   certain things (e.g. resource groups, network subnets, etc.) to be
   created beforehand. If you work at Pilosa, this is all probably set
   up, if you don't, you may have to mess around with some of the
   terraform stuff. Feel free to get in touch, or submit an issue if
   you have trouble.
7. Create a new workspace: e.g. `terraform workspace new taxi-DenseIO16-3node`
8. `make init` This sets up terraform in the local directory.
9. `make apply` This runs terraform and actually makes your infrastructure.
10. `make provision` This runs ansible and installs stuff on all your hosts.

Now you can do things! The most important commands are:
- `make help` See a list of commands with help strings.
- `make output` See the internal and external IP addresses of the infrastructure you provisioned.
- `make ssh-agent` SSH to the agent node with some helpful port forwards.
- `make ssh` SSH to the first Pilosa node.
- `make ssh N=2` SSH to the third Pilosa node.
- `make provision-pilosa` Rerun Ansible just for Pilosa nodes.
- `make provision-agent` Rerun Ansible just for the agent node.
- `make apply` after changing your vars.tf file. You can easily add a
  node to Pilosa by changing the number of nodes, then running `make
  apply` and `make provision`.
- `make provision ANSIBLE_ARGS="-e thing=value"` The Ansible configs
  expose a lot of parameters, specifically the version and source of
  various repositories. If, for example you wanted to check out a
  branch of Pilosa in my personal fork, you could do `make provision
  ANSIBLE_ARGS="-e pilosa_repo=https://github.com/jaffee/pilosa -e
  pilosa_version=cool-branch"`. Look at the `vars:` sections of the
  various `ansible/*.yml` files to see what variables are exposed.
- `make destroy` Remove all infrastructure.
- `make nuke-pilosa` Remove all Pilosa data and restart.

Try running `make ssh-agent`, and generating some data into Pilosa with the `imagine` tool. Then see if you can view the tracing UI by navigating to http://localhost:16686/ (you may need to pass some ANSIBLE_ARGS when provisioning Pilosa like `tracing_sample_type=const` and `tracing_sampler_param=1`).


# Taxi Cab cross provider benchmarks
Goal: Run a standardized set of queries over the billion taxi ride dataset on same sized clusters of VMs.

## methodology
1. Clone github.com/pilosa/infrastructure and change into it.
2. `cd terraform/examples`
3. Copy a *-taxi-template directory to a descriptively named dir e.g. `cp -r oci-taxi-template oci-taxi-DenseIO2.16-3node`
4. Change into that new directory. e.g. `cd oci-taxi-DenseIO2.16-3node`
5. Copy vars.tfvars.example to vars.tfvars and change stuff. Some of the clouds
   require certain things (e.g. resource groups, network subnets, etc.) to be
   created beforehand.
6. Create a new workspace: e.g. `terraform workspace new taxi-DenseIO16-3node`
7. `make init`
8. `make apply`
9. `make provision`
10. `make halfurls`
11. `make halftaxi`
12. Wait for taxi load to complete - use `make halftaxi-log` to check status.
13. `export AGENT_IP=$(make output | jq .agent_public_ip.value)`
14. Optional: Use `make provision-demo-taxi HOSTS=$AGENT_IP,` to provision the
    demo (nice for generating big queries). Note the comma after agent_ip
15. `make bench` This will run the benchmarks and collect the results in this directory.
16. Your results are now in a file named like `rawresults-$(CLOUD)-$(SHAPE)-$(COUNT)-$(USERNAME)-$(shell date -u +%Y%M%dT%H%M).csv`
17. `make bandwidth` will run memory bandwidth microbenchmarks. Use `make bw-log` to track progress.
18. `make bw-results` fetches the bandwidth results and appends them to your other results.
19. You can upload the results directly to a data.world project - you'll have to
    edit the `upload` target in the taxi-include Makefile if you want to use a
    data.world project other than the default:
    - Download your API token from https://data.world/settings/advanced
    - Place it in a file in this directory called `data.world-api-token`. 
    - Run `make upload` from each particular configuration's directory.
