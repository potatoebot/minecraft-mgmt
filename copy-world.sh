#! /bin/bash

set -euo pipefail

file_prefix=$(date +%s)

zip -r $file_prefix-world minecraft/world
scp -i "minecraft.pem" $file_prefix-world.zip URLR
