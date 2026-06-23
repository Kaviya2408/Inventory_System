#!/bin/bash

# This script sets up nginx configuration for the Inventory System
# Run this once on your EC2 instance

echo "Setting up nginx configuration..."

# Backup existing config
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup

# Copy our nginx config
sudo cp nginx.conf /etc/nginx/conf.d/inventory-system.conf

# Test nginx configuration
sudo nginx -t

if [ $? -eq 0 ]; then
    echo "Nginx configuration is valid"
    echo "Reloading nginx..."
    sudo systemctl reload nginx
    echo "Nginx setup completed successfully!"
else
    echo "Nginx configuration has errors. Please check the config file."
    exit 1
fi
