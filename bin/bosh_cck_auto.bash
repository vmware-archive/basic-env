#!/bin/bash


OUR_MANIFESTS=$(find ~/tmp/ |egrep 'dummy.*.yml')

if [[ -z "$OUR_MANIFESTS" ]] ; then
    bosh_download_all_manifests.bash
    exec $0
else 
    parallel -j1 "bosh -n -d {} cck --auto" ::: $OUR_MANIFESTS
fi
