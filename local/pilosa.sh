source tmux.sh

function make-cluster() {
    NUMNODES=${1:-3} # Number of nodes, default 3
    NAME=${2:-pilosa} # Name of tmux session
    DATADIR=$3 # Data directory path
    PILOSA=${4:-pilosa} # path to pilosa binary

    if [ -z $3 ]; then
        DATADIR=$(mktemp -d)
    fi

    echo "Data directory is ${DATADIR}"
    echo "Starting ${NUMNODES}-node cluster..."

    # Make seed list for config
    SEEDS=localhost:14000
    if [ $NUMNODES -gt 1 ]; then
        for i in $(seq 1 $(( $NUMNODES - 1 ))); do
            SEEDS=$SEEDS,localhost:$((14000 + $i))
        done
    fi

    # Make list of Pilosa commands to run
    declare -a COMMANDS

    # TODO: Remove this block after deprecating v0.8
    CLUSTER_HOSTS=localhost:10101
    if [ $NUMNODES -gt 1 ]; then
        for i in $(seq 1 $(( $NUMNODES - 1 ))); do
            CLUSTER_HOSTS=$CLUSTER_HOSTS,localhost:$((10101 + $i))
        done
    fi

    # Generate commands
    for i in $(seq 0 $(( $NUMNODES - 1 ))); do
        # Node 0 will be the coordinator
        if [ $i -eq 0 ]; then
            COORD=true
        else
            COORD=false
        fi

        # TODO: Remove this top block after deprecating v0.8
        if [[ $PILOSA = *"pilosa-v0.8"* ]]; then
            COMMANDS[i]="sleep $((10 * $i)) && ${PILOSA} server --data-dir=${DATADIR}/node${i} --bind=localhost:$((10101 + $i)) --gossip.port=$((14000 + $i)) --gossip.seed=localhost:14000 --cluster.hosts=$CLUSTER_HOSTS 2>&1 | tee -a $DATADIR/node${i}-stdout.log"
        else
            COMMANDS[i]="${PILOSA} server --data-dir=${DATADIR}/node${i} --bind=localhost:$((10101 + $i)) --gossip.port=$((14000 + $i)) --gossip.seeds=localhost:14000 --cluster.coordinator=${COORD} 2>&1 | tee -a $DATADIR/node${i}-stdout.log"
        fi
    done

    for C in "${COMMANDS[@]}"; do
        echo $C
    done

    tmux-split $NAME "${COMMANDS[@]}"
}

function do-queries() {
    server=${2:-localhost:10101}
    version=$(curl http://${server}/version | jq -r .version)
    filename=$1
    cat queries.txt | while read query; do
        if [[ $version = "v0.8."* ]]; then
            query=$(echo $query | sed s/row/rowID/g | sed s/col/colID/g)
        fi
        echo Running $query
        curl http://${server}/index/compat/query -d "$query" >> $filename
    done
}
