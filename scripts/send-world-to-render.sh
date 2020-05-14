#! /bin/bash

set -euo pipefail

zip world-to-render -r ~/minecraft/world
scp -i "minecraft.pem" world-to-render.zip $RENDER_TARGET