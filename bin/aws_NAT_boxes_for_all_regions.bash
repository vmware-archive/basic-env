#!/bin/bash

for i in ap-northeast-1 ap-southeast-1 ap-southeast-2 eu-west-1 sa-east-1 us-east-1 us-west-1 us-west-2 ; do
    echo "Latest VPC Nat box for region: $i"
    [[ -d ~/tmp ]] || mkdir ~/tmp
    o=~/tmp/outfile
    curl -s "http://thecloudmarket.com/search?region=$i&search_term=amzn\\\\\\\\\\\\\\\-ami\\\\\\\\\\\\\\\-vpc\\\\\\\\\\\\\\\-nat&order=created_at%20desc" > $o
    for type in hvm pv; do
        echo "  for $type instance types"
        echo -n "    "
        cat $o |
           grep amzn-ami-vpc-nat |
           grep ebs | grep title |
           grep $type |
           tr -d "',()" |
           perl -pe 's{\s*title:}{}' |
           sort |
           head -1
    done
    echo '===='
done
