#!/bin/bash

mysql -u root -proot -e "create database if not exists snort;"
mysql -u root -proot -D snort -e "source /root/snort_src/barnyard2-master/schemas/create_mysql"
mysql -u root -proot -D snort -e "CREATE USER IF NOT EXISTS 'snort'@'localhost' IDENTIFIED BY 'snort';"
mysql -u root -proot -D snort -e "grant create, insert, select, delete, update on snort.* to 'snort'@'localhost';"
mysql -u root -proot -e "grant all privileges on snort.* to snort@'10.%' identified by 'snort'; flush privileges;"