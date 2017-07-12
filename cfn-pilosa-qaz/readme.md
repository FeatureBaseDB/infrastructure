## Usage
0. Install qaz `https://github.com/daidokoro/qaz` (`go get github.com/daidokoro/qaz`)
1. Copy `config.yml.tmpl` to `config.yml`
2. Change values there based on the comments.
   1. You can change "project: cody" to "project: yourname"
   2. The keys under `stacks` are stack names - change to something descriptive. You can define many stacks.
   3. Change profile to the aws profile you are using.
   4. Change the clustername to something descriptive (often same as stack name).
   5. Change KeyPair to your key pair.
   6. Update number of agents and nodes based on your needs.
3. run `qaz deploy stackname`
4. `ssh ubuntu@node0.<ClusterName>.sandbox.pilosa.com`
