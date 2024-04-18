#!/usr/bin/env bash

# Install Nginx if not already installed
if ! command -v nginx &> /dev/null; then
    sudo apt-get update
    sudo apt-get -y install nginx
fi

# Create necessary directories if they don't exist
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared

# Create a fake HTML file for testing
echo "<html><head><title>Test Page</title></head><body>This is a test page.</body></html>" | sudo tee /data/web_static/releases/test/index.html > /dev/null

# Create symbolic link if it doesn't exist
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Give ownership of /data/ to ubuntu user and group recursively
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
config_file="/etc/nginx/sites-available/default"
sudo sed -i '/server_name _;/a \
\\n\
\\tlocation /hbnb_static {\n\
\\t\talias /data/web_static/current/;\n\
\\t}\n' $config_file

# Restart Nginx
sudo service nginx restart

exit 0
