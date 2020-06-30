#update & install dependecies
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt update && sudo apt upgrade -y
sudo apt install git nginx -y 

#download github repo
cd /tmp
git clone https://github.com/Hermesss/mdt.git
sudo mv /tmp/mdt/www/* /var/www/html
sudo systemctl restart nginx

#git sparce-checkout section
#install required apps
sudo apt update
sudo apt install make libssl-dev libghc-zlib-dev libcurl4-gnutls-dev libexpat1-dev gettext unzip
cd /tmp
#download github repo
#git clone https://github.com/Hermesss/mdt.git
cd ./mdt
#git sparce-checkout setup
git sparse-checkout init --cone
git sparse-checkout set 'www/!*'
echo -e "/*\n"'!'"*.php\n"'!'"*.ico" >> .git/info/sparse-checkout
git read-tree -m -u HEAD


#setup cronjob
sudo /bin/bash -c '(echo " * * * * * root cd /tmp/mdt && git pull -q origin master && mv /tmp/mdt/www/* /var/www/html && systemctl restart nginx" >> /etc/crontab )'
