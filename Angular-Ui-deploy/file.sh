#! /bin/bash
sudo su
sudo apt update --yes
sudo apt-get install nginx --yes
sudo ufw app list
sudo ufw allow 'Nginx HTTP'
systemctl status 
curl -s https://deb.nodesource.com/setup_16.x | sudo bash
sudo apt install nodejs --yes
sudo apt install npm --yes
sudo npm i @angular/cli -g
git clone https://github.com/sir-argupta/HackFSE-tweetapp-frontend.git
cd HackFSE-tweetapp-frontend
sudo npm install
sudo ng build --prod
sudo rm /var/www/html/index.nginx-debian.html
sudo mv ./dist/tweet-app-frontend/* /var/www/html
sudo systemctl restart nginx
nginx -t
sudo systemctl status nginx