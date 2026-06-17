#!/bin/bash -ex

dnf update -y
dnf install -y httpd

systemctl enable httpd
systemctl start httpd

HOSTNAME=$(hostname)

echo "<h1>Welcome to Amazon Linux 2023!</h1><p>${HOSTNAME}</p>" > /var/www/html/index.html