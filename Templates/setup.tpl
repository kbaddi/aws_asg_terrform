#!/bin/bash

sudo apt update -y
sudo apt install apache2 -y
sudo servicectl start apache2
echo "Hello World" > /var/www/html/index.html
