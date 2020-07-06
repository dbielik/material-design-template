#!/bin/bash

git -C /home/ec2-user/work/mdt-fork pull https://github.com/ludnas/mdt-fork
sudo cp -rv /home/ec2-user/work/mdt-fork/www/* /var/www/html/
