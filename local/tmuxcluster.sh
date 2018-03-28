#!/bin/bash

# Usage:
# ./tmuxcluster.sh $N     # Replace $N with number of nodes
#
# This script will:
# 1. Start a new tmux session called `pilosa`
# 2. Create a temporary directory for pilosa data files.
# 3. Launch N instances of pilosa, each on a tmux pane.
# 4. Attach to tmux session

DATADIR=$(mktemp -d)
NUMNODES=${1:-3}

N=$(( $NUMNODES - 1 ))

echo "Starting ${NUMNODES} node cluster..."
echo "Creating data directories under ${DATADIR}..."

tmux new-session -d -s pilosa
tmux select-window -t pilosa
tmux select-layout even-vertical

# Make seed list
for i in $(seq 0 $N); do
    if [ -z $SEEDS ]; then
        SEEDS=localhost:$((14000 + $i))
    else
        SEEDS=$SEEDS,localhost:$((14000 + $i))
    fi
done

for i in $(seq 0 $N); do
    # Node 0 will be the coordinator
    if [ $i -eq 0 ]; then
        COORD=true
    else
        COORD=false
    fi

    # Select the "Nth" pane and launch pilosa
    tmux select-pane -t $i
    tmux send-keys "pilosa server --data-dir=${DATADIR}/node${i} --bind=localhost:$((10101 + $i)) --gossip.port=$((14000 + $i)) --gossip.seeds=${SEEDS} --cluster.coordinator=${COORD}" Enter

    # Split the window after every loop except the last
    if [ ! $i -eq $N ]; then
        tmux split-window -v
    fi
done

tmux select-layout even-vertical

# Uncomment and use `-CC` if using tmux/iterm integration
#tmux -CC attach -t pilosa
tmux attach -t pilosa
