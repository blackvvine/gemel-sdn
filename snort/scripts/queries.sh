#!/bin/bash

mysql -u root -proot -e "create database snort;"
mysql -u root -proot -D snort -e "source ~/barnyard2/barnyard2-master/schemas/create_mysql"
mysql -u root -proot -D snort -e "CREATE USER 'snort'@'localhost' IDENTIFIED BY 'snort';"
mysql -u root -proot -D snort -e "grant create, insert, select, delete, update on snort.* to 'snort'@'localhost';"