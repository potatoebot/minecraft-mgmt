#! /bin/bash

set -euo pipefail

aws_resp=$(aws ec2 describe-images --owner self --filters "Name=name,Values=MCS 1*" --query 'Images[*].{id:ImageId, name:Name}')

echo $aws_resp | jq -c 'sort_by(.name)' | jq -c 'last' | jq .id | sed s/\"//g