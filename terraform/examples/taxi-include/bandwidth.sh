#!/bin/bash

for trial in 1 8 16 32 64 104
do
    for (( i = 1 ; i <= ${trial}; i++ ))
    do
        mkdir -p bandwidth${trial}conc-${i}
    done
done

runbw () {
    cd bandwidth${1}conc-${2}
    sudo nice -n -2 ${HOME}/bandwidth-1.5.1/bandwidth64 --faster --title ${trial}conc-${i} > bandwidth${trial}-${i}.out
    cp bandwidth${trial}-${i}.out ..
    echo Finished Job ${1}-${2}
}

for trial in 1 2 4 8 16 32 64
do
    echo Starting Trial: ${trial}
    for (( i = 1 ; i <= ${trial}; i++ ))
    do
        runbw ${trial} ${i} &
    done
    wait
done

echo Done

