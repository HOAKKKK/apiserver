#!/bin/bash
set -e
echo "Starting installation script..."
echo "Installing system dependencies..."
echo "Installing PM2 globally..."
npm i pm2 -g
echo "Installing npm modules..."
npm i axios cheerio colors commander express header-generator hpack http-proxy-agent http2-wrapper https-proxy-agent jsdom node-fetch randomstring socks socks-proxy-agent user-agents
echo "Installation complete!"
echo "start api integration (pm2)"
pm2 start api.js
pm2 list
echo "api started successfully"
echo "System dependencies have been installed"
echo "PM2 has been installed globally"
echo "All other npm modules have been installed in the current directory"