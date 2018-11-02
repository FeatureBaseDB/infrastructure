#!/bin/bash

# TODO: Modify compat tests to work with pilosa > 1.0.

source pilosa.sh

if [ ${#*} -lt 2 ]; then
    echo Usage: ./compat.sh {old-pilosa-binary} {new-pilosa-binary}
    echo e.g. ./compat.sh bin/pilosa-v0.8.8 bin/pilosa-v0.9.0
    exit 1
fi

for f in $1 $2; do
    if [[ ! -x "$f" ]] ; then
        echo $f is not executable!
        exit 1
    fi
done

OLD=$1
NEW=$2
NUMNODES=${3:-3}

# Clean up old results
rm -f results-*.txt

DATADIR=$(mktemp -d)
echo Data dir: $DATADIR

echo Starting first cluster, $NUMNODES nodes using $OLD
make-cluster $NUMNODES compat $DATADIR $OLD
echo Waiting for cluster to finish joining...
sleep 20

echo Starting import...
$OLD import -e -i compat -f array full-array.csv
$OLD import -e -i compat -f bitmap full-bitmap.csv
$OLD import -e -i compat -f run full-run.csv
$OLD import -e -i compat -f bsi --field val values.csv

echo Import finished, waiting for a bit before starting queries...
sleep 20

echo Performing queries...
do-queries results-old.txt

echo Finished. State of the data directories:
tree $DATADIR

echo Stopping Pilosa gracefully...
tmux select-window -t compat
for i in $(seq 0 $(( $NUMNODES - 1 ))); do
    tmux select-pane -t $i
    tmux send-keys -t compat C-c
done

sleep 10

echo Final state of data directories:
tree $DATADIR

# Copy original state of data files to backup directory just in case
mkdir -p $DATADIR.bak
cp -a $DATADIR $DATADIR.bak

echo Killing cluster...
tmux kill-session -t compat

# Start new-version cluster

echo Starting second cluster, $NUMNODES nodes using $NEW
make-cluster $NUMNODES compat $DATADIR $NEW

echo Waiting for cluster to finish joining...
sleep 60

echo Performing queries...
do-queries results-new.txt

diff results-old.txt results-new.txt

if [ $? -ne 0 ]; then
    echo Diff does not match. Leaving cluster alive. To kill, run "tmux kill-session -t compat"
    exit 1
fi

echo Killing cluster...
tmux kill-session -t compat
