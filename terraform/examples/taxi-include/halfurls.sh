#!/bin/bash

i=0
for line in `cat /home/ubuntu/go/src/github.com/pilosa/pdk/usecase/taxi/greenAndYellowUrls.txt`
do
    if [ $(($i % 2)) -eq 0 ]
    then
        echo $line;
    fi
    ((i+=1))
done > /home/ubuntu/go/src/github.com/pilosa/pdk/usecase/taxi/halfURLs.txt
