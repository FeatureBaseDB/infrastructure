#!/bin/bash

# Usage:
# ./tmuxcluster.sh $N     # Replace $N with number of nodes
#
# This script will:
# 1. Start a new tmux session called `pilosa`
# 2. Create a temporary directory for pilosa data files.
# 3. Launch N instances of pilosa, each on a tmux pane.
# 4. Attach to tmux session

function tmux-split() {
    # Name of tmux session
    SESSION=$1
    shift
    # Array of commands
    C=("$@")
    # Number of commands minus one
    N=$((${#C[@]} - 1))

    tmux new-session -d -s $SESSION
    tmux select-window -t $SESSION
    tmux select-layout even-vertical

    for i in $(seq 0 $N); do
        # Select the "Nth" pane and launch pilosa
        tmux select-pane -t $i
        tmux send-keys "${C[i]}" Enter

        # TODO: This splitting logic works up to only about 5 nodes before failing with "create pane failed: pane too small"
        # Split the window after every loop except the last
        if [ ! $i -eq $N ]; then
            tmux split-window -v
            tmux select-layout even-vertical
        fi
    done

    # Uncomment and use `-CC` if using tmux/iterm integration
    tmux -CC attach -t $SESSION
    #tmux attach -t $SESSION
}

function make-cluster() {
    NUMNODES=${1:-3} # Number of nodes, default 3
    DATADIR=$(mktemp -d)

    echo "Data directory is ${DATADIR}"
    echo "Starting ${NUMNODES}-node cluster..."

    # Make seed list for config
    for i in $(seq 0 $(( $NUMNODES - 1 ))); do
        if [ -z $SEEDS ]; then
            SEEDS=localhost:$((14000 + $i))
        else
            SEEDS=$SEEDS,localhost:$((14000 + $i))
        fi
    done

    # Make list of Pilosa commands to run
    declare -a COMMANDS

    # Generate commands
    for i in $(seq 0 $(( $NUMNODES - 1 ))); do
        # Node 0 will be the coordinator
        if [ $i -eq 0 ]; then
            COORD=true
        else
            COORD=false
        fi

        COMMANDS[i]="pilosa server --data-dir=${DATADIR}/node${i} --bind=localhost:$((10101 + $i)) --gossip.port=$((14000 + $i)) --gossip.seeds=${SEEDS} --cluster.coordinator=${COORD}"
    done

    tmux-split pilosa2 "${COMMANDS[@]}"
}

NUMNODES=${1:-3}
make-cluster $NUMNODES
