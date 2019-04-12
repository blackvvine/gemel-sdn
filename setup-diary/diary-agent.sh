sudo apt-get install build-essential autoconf libtool pkg-config python-opengl python-imaging python-pyrex python-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3 python-dev

sudo apt-get install python3-dev

sudo apt-get install python-dev default-libmysqlclient-dev

pip install mysqlclient


=========================

in: /etc/mysql/mysql.conf.d/mysqld.cnf

bind-address		= 10.142.0.x

or

bind-address		= 0.0.0.0

==========================

in: mysql shell (mysql -u root -p)

GRANT ALL ON *.* to snort@'halsey-vm.us-east1-b.c.phdandpeasant.internal' IDENTIFIED BY 'snort';

FLUSH PRIVILEGES;


==========================



