#!/bin/bash
set -euo pipefail

echo "Deploying portfolio"

# nginx

sudo ln -sf /home/brig/code/portfolio/deploy/nginx.conf /etc/nginx/conf.d/root.conf

sudo nginx -t
sudo systemctl reload nginx

echo "Deployment complete for portfolio"
