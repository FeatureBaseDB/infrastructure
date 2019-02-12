#!/bin/bash

DIR=bandwidth-output$(date -u +%Y%m%dT%H%M%S)
echo ${DIR}
mkdir -p ${DIR}
cd ${DIR}

TRIALS="1 16 36 52"

for trial in ${TRIALS}
do
    for (( i = 1 ; i <= ${trial}; i++ ))
    do
        mkdir -p bandwidth${trial}conc-${i}
    done
done

runbw () {
    cd bandwidth${1}conc-${2}
    echo Starting Job ${1}-${2} at `date -u +%H:%M:%S.%N`
    sudo nice -n -2 ${HOME}/bandwidth-1.5.1/bandwidth64 --fast --title ${1}conc-${2} > bandwidth${1}-${2}.out
    sed -n 's/\(.*\) \([0-9]\+\.[0-9]\) MB\/s/\1!\2/p' bandwidth${1}-${2}.out |
        sed 's/, loops = [0-9]\+,//' > ../bandwidth${1}-${2}.out
    echo Finished Job ${1}-${2} at `date -u +%H:%M:%S.%N`
}

> ../allbw.out # truncate
for trial in ${TRIALS}
do
    echo Starting Trial: ${trial}
    for (( i = 1 ; i <= ${trial}; i++ ))
    do
        runbw ${trial} ${i} &
    done
    wait
    cat ../bandwidth-list.txt | while read line
    do
        echo -n BW${line} conc${trial}'!'
        grep "$line" bandwidth${trial}-*.out | awk -F'!' '{ sum+=$2 } END {printf "%.0f", sum}'
        echo ""
    done >> ../allbw.out
done
