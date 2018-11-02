#!/bin/bash

cd $GOPATH/src/github.com/pilosa/pilosa

for version in v0.7.2 v0.8.8 master; do
    git checkout $version
    make install
    cp $GOPATH/bin/pilosa $GOPATH/bin/pilosa-$(git describe --tags 2> /dev/null || echo unknown)
done
