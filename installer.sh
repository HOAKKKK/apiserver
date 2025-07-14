#!/bin/bash

#Created by NowMeee
# apa mau recode kau kontol?? 
# jangan recode anjing pepek monyet gue cape buat nya 
# recode ga buat lu jadi developer memek
set -e
echo "Starting automated installation script..."
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y
echo "Installing Node.js 20.x..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
echo "Node.js version:"
node -v
echo "npm version:"
npm -v
echo "Installing Nginx..."
sudo apt install -y nginx
echo "Enabling and starting Nginx..."
sudo systemctl enable nginx
sudo systemctl start nginx
echo "Setting up web directory..."
sudo mkdir -p /var/www/html
sudo chown -R $USER:$USER /var/www/html
sudo chmod -R 755 /var/www/html
echo "Creating sample index.html..."
echo "<html><body><h1>Server is running!</h1><p>Nginx has been successfully installed.</p></body></html>" > /var/www/html/index.html
echo "Configuring Nginx..."
sudo tee /etc/nginx/sites-available/default > /dev/null << EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
    
    server_name _;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
echo "Restarting Nginx..."
sudo systemctl restart nginx
SERVER_IP=$(curl -s ifconfig.me)
echo "Installation complete!"
echo "Nginx is running and serving content from /var/www/html"
echo "You can access your server at http://$SERVER_IP"
echo "Registering server with remote service..."
REGISTER_URL="http://v1.nexarium.net:1337/?add=http://$SERVER_IP:1337"
REGISTER_RESPONSE=$(curl -s "$REGISTER_URL")
echo "Registration response: $REGISTER_RESPONSE"
echo "Server registration complete!"