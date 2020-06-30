wget https://github.com/naturkach/mdt/archive/master.zip
unzip master.zip
sudo cp -R mdt-master/www/* /var/www/html/
rm -rf mdt-master/
rm -r master.zip
