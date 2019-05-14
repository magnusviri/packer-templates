#!/bin/sh

innodb_buffer_pool_size=1024M # This number is 50%-70% of unused RAM.
mysql_database_name=jamfsoftware
mysql_user=jamfsoftware
mysql_password=jamfsw03
username=james

apt-get update
apt-get upgrade -y

# Create Jamf database (step 2 of installation)
# See https://www.jamf.com/jamf-nation/articles/542/manually-creating-the-jamf-pro-database

echo "CREATE DATABASE $mysql_database_name;" | mysql -u root
echo "CREATE USER '$mysql_user'@'localhost' IDENTIFIED BY '$mysql_password';" | mysql -u root
echo "GRANT ALL ON $mysql_database_name.* TO '$mysql_user'@'localhost';" | mysql -u root

echo '' >> /etc/mysql/my.cnf
echo '[mysqld]' >> /etc/mysql/my.cnf
echo "innodb_buffer_pool_size=$innodb_buffer_pool_size" >> /etc/mysql/my.cnf
echo "innodb_file_per_table=1" >> /etc/mysql/my.cnf
systemctl restart mysql

# Run the Jamf Pro installer (step 3 of installation)

yes | /home/$username/copy/jamfproinstaller.run

exit 0
