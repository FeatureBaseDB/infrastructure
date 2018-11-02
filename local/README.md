# local

Utilities for running Pilosa locally

- tmuxcluster.sh: Run temporary pilosa cluster with N-nodes in tmux as split panes
  Usage: Copy `tmuxcluster.sh` into your $PATH or create a shell alias to it. Then run `tmuxcluster.sh 3` which starts 3 nodes (the number is the number of nodes to run).

## Cluster compatibility tests

To guarantee integrity of data during a Pilosa version migration, I created some tools for testing version changes. The high-level operation of the tool is:

1. Create a Pilosa cluster, using version *A*.
2. Import data into Pilosa. Each of the three container types (run, array, bitmap) are utilized by generating data with a specific pattern and imported with `pilosa import` into three frames.
3. Run a selection of queries that exercise several operations against every container type, returning counts that are collected in `results-old.txt`.
4. Stop the cluster, retaining the data directories.
5. Start Pilosa version *B*, pointing it to the same data files written by version *A*.
6. Run the same queries as step 3, writing the results to `results-new.txt`.
7. Diff the results output (`diff results-old.txt results-new.txt`).
8. If the results are the same, shut down the cluster and consider the test a success.

Usage is `./compat.sh /path/to/old-pilosa-binary /path/to/new-pilosa-binary`.


### Usage

#### Prerequisites

1. Install requirements: `jq`, `curl`, `tmux`, `go`
2. Generate importable CSV files: `make`

#### Install at least two pilosa versions

```
./install-pilosa-versions.sh v0.8.8 master
```

#### Run full compatibility test

```
./compat.sh /path/to/old-pilosa-binary /path/to/new-pilosa-binary [number-of-nodes (default:3)]
```

### Findings

There were three scenerios that produced unexpected results:

1. Killed cluster doesn't retain data. More info below. This is probably not a real issue.
2. Data returned just after startup of new cluster is often incomplete/partial.
3. Pilosa v0.8/v0.9 node ordering data-loss issue.

#### Killed cluster doesn't retain data

In early tests, the clusters were killed with simply `tmux kill-session -t compat`, but it was found that using `tmux kill-session` does not appear to send a graceful `SIGTERM` to the process. Consequently, some data was not getting written.

This was since modified to send Ctrl-C to each node rather than rely on tmux and the problem is no longer reproducable.

*Recommendation:* This is probably not a "real" issue, but it would be useful to know how often data files are flushed to disk, so customers can have some recency guarantee on non-graceful (ie. power-outage) failures.

#### Data returned just after startup is often incomplete/partial

When the cluster has just started, the data returned from queries only represents what is stored on the node.

This is unexpected as you would expect the node to stay in `STARTING` status until all nodes have joined.

*Recommendation:* Revisit node startup and make sure partial data is not returned.

#### Pilosa v0.8/v0.9 node ordering data-loss issue

Clusters created with v0.8 and below, when loaded into v0.9+ are often not created with the same hashring order. This potentially causes data loss during a routine upgrade.

This problem is easiest described with a two-node cluster.

1. Two nodes (A and B) of v0.8 are running. The hashring looks like: `A-B`.
2. Nodes are upgraded to v0.9. On startup, Node IDs are created. If the Node B ID is earlier in alphabtical order than Node B, the hashring will look like: `B-A`.
3. Node A starts up, sees that it is coordinator, and considers itself a one-node cluster with the existing fragments (likely an incomplete dataset).
4. Node B joins, modifying the hashring from just `A` to `B-A`, thus taking the position of A.
5. Per the consistent hash algorithm, ownership of all of A's data now belongs to B.
6. Because B is joining a "new" cluster, its previously stored data is discarded, and it receives all the data from A.
7. A's data, once copied to B, is now discarded, leaving A empty.
8. The final state, compared to the initial state, is that A's data is returned by B, and B's data is discarded.

*Recommendation:* Take steps to prevent accidental data deletion. Ensure smooth upgrade path to new hashring stategy.
