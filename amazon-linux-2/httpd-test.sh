#!/bin/bash
# This script installs and starts an Apache web server.
# It also creates a simple HTML file to display the hostname of the instance.

INDEX_HTML_LOCATION="/var/www/html/index.html"
HTML_CONTENT="<h1>Hello from $(hostname -f)</h1>"

{
  sudo yum update -y
  sudo yum install -y httpd
  sudo systemctl start httpd
  sudo systemctl enable httpd
  echo "$HTML_CONTENT" | sudo tee $INDEX_HTML_LOCATION
} >> /var/log/ec2-user-data.log 2>&1