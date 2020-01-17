#!/bin/bash
now=$(date +"%m_%d_%Y")
# Turn on Maintenance Mode

echo "Turning on maintenance mode for Nextcloud..."
docker exec --user www-data docker_app_1 php occ maintenance:mode --on
echo "Done"
echo

# Backup DB

echo "Backing up Nextcloud database..."
now=$(date +"%m_%d_%Y")
docker exec docker_db_1 sh -c 'exec mysqldump --single-transaction -h localhost -u nextcloud -pPASSWORD nextcloud' > /home/antoine/tmp/nextcloudDB_$now.sql
echo "Done"
echo

# Backup Nextcloud Files/Data

echo "Creating backup of Nextcloud file directory..."
tar -cpzf /home/antoine/tmp/nextcloud_files_$now.tar.gz -C /var/lib/docker/volumes/docker_nextcloud/_data .
echo "Done"
echo


# Turn off Maintenance Mode

echo "Turning off maintenance mode for Nextcloud..."
docker exec --user www-data docker_app_1 php occ maintenance:mode --off
echo "Done"
echo
