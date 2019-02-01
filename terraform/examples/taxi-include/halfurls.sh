#!/bin/bash

i=0
for line in `cat $HOME/go/src/github.com/pilosa/pdk/usecase/taxi/greenAndYellowUrls.txt`
do
    if [ $(($i % 2)) -eq 0 ]
    then
        echo $line;
    fi
    ((i+=1))
done > $HOME/go/src/github.com/pilosa/pdk/usecase/taxi/halfURLs.txt
