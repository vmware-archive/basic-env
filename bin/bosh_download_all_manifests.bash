#!/bin/bash

bosh deployments |
    tr -d '|' |
    egrep -v '^\+|Name.*Re.*Stem|^Deploy' |
    awk '{print $1}' |
    parallel -rt "mkdir -p ~/tmp/ ; bosh -n download manifest {} ~/tmp/{}.yml"
