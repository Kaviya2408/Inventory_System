# AWS EC2 Deployment Guide

## Current Issue: 413 Request Entity Too Large

This error occurs when uploading large bill images. Here's how to fix it:

## Quick Fix

### Option 1: Run on EC2 (Recommended)

SSH into your EC2 instance and run:

```bash
cd /home/ec2-user/Inventory_System

# Pull latest code
git pull origin main

# Make script executable
chmod +x setup-nginx.sh

# Run nginx setup (this will update nginx to allow 100MB uploads)
./setup-nginx.sh
```

### Option 2: Manual nginx Configuration

SSH into your EC2 instance and edit nginx config:

```bash
sudo nano /etc/nginx/conf.d/inventory-system.conf
```

Add or update this line inside the `server` block:

```nginx
client_max_body_size 100M;
```

Then test and reload nginx:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

### Option 3: Edit main nginx.conf

If you don't have a separate config file:

```bash
sudo nano /etc/nginx/nginx.conf
```

Add `client_max_body_size 100M;` inside the `http` block:

```nginx
http {
    client_max_body_size 100M;
    
    # ... rest of config
}
```

Test and reload:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

## Verify the Fix

After updating nginx:

1. Go to your app: http://16.170.94.198
2. Try uploading a bill image
3. The 413 error should be gone

## Environment Variables on EC2

Make sure your `/home/ec2-user/Inventory_System/backend/.env` file has all required variables:

```env
PORT=3000
MONGODB_URI=your_mongodb_connection_string
JWT_SECRET=your-jwt-secret
TWILIO_ACCOUNT_SID=your_twilio_sid
TWILIO_AUTH_TOKEN=your_twilio_token
TWILIO_PHONE_NUMBER=your_twilio_phone
GEMINI_API_KEY=your_gemini_api_key
```

## PM2 Process Management

Check if backend is running:

```bash
pm2 list
```

Restart backend:

```bash
pm2 restart inventory-backend
```

View logs:

```bash
pm2 logs inventory-backend
```

## Nginx Status

Check nginx status:

```bash
sudo systemctl status nginx
```

View nginx error logs:

```bash
sudo tail -f /var/log/nginx/error.log
```

## Troubleshooting

### Still getting 413 error?

1. Check if nginx config was applied:
   ```bash
   sudo nginx -T | grep client_max_body_size
   ```

2. Make sure nginx reloaded:
   ```bash
   sudo systemctl reload nginx
   ```

3. Clear browser cache and try again (Ctrl+Shift+R)

### Backend not starting?

```bash
cd /home/ec2-user/Inventory_System/backend
npm install
pm2 restart inventory-backend
pm2 logs inventory-backend
```

### Frontend not building?

```bash
cd /home/ec2-user/Inventory_System/frontend
rm -rf node_modules dist
npm install
npm run build
```
