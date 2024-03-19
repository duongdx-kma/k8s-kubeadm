#!/bin/bash
# Install nginx on your web-01 server
# Nginx should be listening on port 80
# When querying Nginx at its root / with a GET request
# (requesting a page) using curl, it must return a page
# that contains the string Hello World!

sudo apt-get -y update
sudo apt-get -y install nginx
echo 'Hello World' | sudo tee /var/www/html/index.html
sudo systemctl start nginx


cat >> /etc/nginx/modules-available/apiserver.conf <<EOF
stream {
  upstream kubernetes {
    server 192.168.56.2:6443 max_fails=5 fail_timeout=30s;
    server 192.168.56.3:6443 max_fails=5 fail_timeout=30s;
  }

  server {
    listen 6443;
    proxy_pass kubernetes;
  }
}
EOF

sudo ln -s /etc/nginx/modules-available/apiserver.conf /etc/nginx/modules-enabled/
sudo systemctl restart nginx
