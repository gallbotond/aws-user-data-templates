#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)

INDEX_HTML_LOCATION="/var/www/html/index.html"
HTML_CONTENT="<h1> $(hostname -f)</h1>"

{
  sudo yum update -y
  sudo yum install -y httpd
  sudo systemctl start httpd
  sudo systemctl enable httpd
  echo "$HTML_CONTENT" | sudo tee $INDEX_HTML_LOCATION
} >> /var/log/ec2-user-data.log 2>&1