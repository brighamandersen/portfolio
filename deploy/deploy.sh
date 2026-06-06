#!/bin/bash
set -euo pipefail

echo "Deploying portfolio"

# nginx

sudo cp /home/brig/dev/portfolio/deploy/nginx.conf /etc/nginx/conf.d/root.conf

sudo nginx -t
sudo systemctl reload nginx

echo "Deployment complete for portfolio"
