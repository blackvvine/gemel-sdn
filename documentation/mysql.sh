# BASH

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

service mysql restart

# SQL

grant all privileges on *.* to snort@10.142.15.212 identified by 'snort';
flush privileges;


