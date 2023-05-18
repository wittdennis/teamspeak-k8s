# Create backup

docker volume create mariadb-backup --driver local --opt device=/var/mariadb/backup --opt type=none --opt o=bind
docker run -v ts-server_db_socket:/var/run/mysqld -v mariadb-backup:/var/mariadb/backup -v ts-server_db_data:/var/lib/mysql --rm -e MYSQL_ROOT_PASSWORD=example mariadb:10.8.3-jammy mariabackup --backup --target-dir=/var/mariadb/backup --user root --password example --socket=/var/run/mysqld/mysqld.sock

# Prepare backup

docker run --rm -v mariadb-backup:/var/mariadb/backup mariadb:10.8.3-jammy mariabackup --prepare --target-dir=/var/mariadb/backup

# Restore backup

docker run --rm -v /my/new/datadir:/var/lib/mysql -v some-mariadb-backup:/backup mariadb:latest mariabackup --copy-back --target-dir=/backup