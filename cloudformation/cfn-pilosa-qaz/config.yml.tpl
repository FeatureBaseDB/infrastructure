region: us-east-1
project: cody # usually just change this to your name - this plus the stack name
              # below will be the stack name in aws

global:

stacks:
  pilosa: # a stack will be created called cody-pilosa if you do `qaz deploy pilosa` in this directory
    source: templates/pilosa.yml
    profile: default # AWS profile from ~/.aws/config
    cf:
      agents: 1
      nodes: 3
    parameters:
      - ClusterName: pilosa # cluster nodes will be nodeX.pilosa.sandbox.pilosa.com
      - KeyPair: cody@soyland.org # name of keypair you use for AWS
      - Subnet: subnet-e44333be
      - VPC: vpc-cb80d5b2
      - AgentInstanceType: c4.large
      - InstanceType: m4.large
      - VolumeSize: 10
      - Replicas: 1