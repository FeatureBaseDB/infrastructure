#!/bin/bash

# Usage:
# ./tmuxcluster.sh $N     # Replace $N with number of nodes
#
# This script will:
# 1. Start a new tmux session called `pilosa`
# 2. Create a temporary directory for pilosa data files.
# 3. Launch N instances of pilosa, each on a tmux pane.
# 4. Attach to tmux session

source pilosa.sh

NUMNODES=${1:-3}
NAME=${2:-pilosa}
DATADIR=$3
make-cluster $NUMNODES $NAME $DATADIR
tmux -CC attach -t $NAME
