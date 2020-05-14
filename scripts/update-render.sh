#! /bin/bash

set -euo pipefail

cd scripts
render_image_id=$(./get-render-image.sh)

# spin up image
cd ../terraform
terraform apply \
  -var="render_image_id=$render_image_id" \
  -var="phase=render"

render_dns=$(terraform output render_dns | sed s/,// | jq -c 'first')
MCS_dns=$(terraform output MCS_dns)

cd ../
ssh -i "minecraft.pem" "ec2-user@$MCS_dns" "RENDER_TARGET=ubuntu@$render_dns:/home/ubuntu ./send-world-to-render.sh"
echo "DONE"
ssh -i "minecraft.pem" "ubuntu@$render_dns" "python3 Minecraft-Overviewer/overviewer.py --config=render-config.py"

