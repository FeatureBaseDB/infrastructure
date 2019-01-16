## Usage
0. Install qaz `https://github.com/daidokoro/qaz` (`go get github.com/daidokoro/qaz`). This presumes you have a standard Go setup where `$GOPATH` is set, and also on your `$PATH`.
1. Copy `config.yml.tmpl` to `config.yml`
2. Change values there based on the comments.
   1. You can change "project: cody" to "project: yourname"
   2. The keys under `stacks` are stack names - change to something descriptive. You can define many stacks.
   3. Change profile to the AWS profile you are using.
   4. Change the DomainName to the one you used in cfn-sandbox[-basic].
   5. Change the VPC and Subnet to the IDs of the resources made in cfn-sandbox[-basic].
   6. Change the clustername to something descriptive (often same as stack name).
   7. Change KeyPair to your key pair.
   8. Update number of agents, nodes, instance types, and volume sizes based on your needs.
3. run `qaz deploy stackname` (in this directory)
4. `ssh ubuntu@node0.<ClusterName>.<DomainName>`
5. When you're done, you can run `qaz terminate stackname` (in this directory)
