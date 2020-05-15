#! /bin/bash

set -euo pipefail

cp ~/.aws/config aws_config
cp ~/.aws/credentials aws_cred

packer build \
    -var "aws_access_key=$AWS_ACCESS_KEY" \
    -var "aws_secret_key=$AWS_SECRET_KEY" \
    MCS.json

rm aws_config
rm aws_cred
