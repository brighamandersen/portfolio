#!/bin/bash
set -euo pipefail

echo "Deploying portfolio"

sudo ln -sf /home/brig/code/portfolio/deploy/nginx/porfolio.conf /etc/nginx/conf.d/portfolio.conf

sudo nginx -t
sudo systemctl reload nginx

echo "Deployment complete for portfolio"
