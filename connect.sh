#! /bin/bash

set -euo pipefail

url=$1

ssh -i "minecraft.pem" "$url"
