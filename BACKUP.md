# BACKUPS

## RCLONE for files

### Installation

[Installation](https://rclone.org/install/)

### Configuration

Remote config

```
[scaleway]
type = s3
provider = other
env_auth = false
access_key_id = ACCEXX_KEY
secret_access_key = SECRET_KEY
region = fr-par
endpoint = https://s3.fr-par.scw.cloud
location_constraint = fr-par
acl = private
```

### Usage

```
rclone copy --progress scaleway:/ .
```

## Nextcloud Data

If you really don't want to run it with root privileges...
In order to allow the user antoine to do the backup you need to change the rights on a directory
```
chmod -R a+x /var/lib/docker/volumes/
chmod -R a+r /var/lib/docker/volumes/
```
/!\ you need to check that the data extraction works fine if not adjust the rights

```
sudo backup.sh
```

# RESTORE

Stop everything

```
cd docker
docker-compose stop
```

```
sudo rm -rf /var/lib/docker/volumes/docker_nextcloud/_data
sudo mkdir /var/lib/docker/volumes/docker_nextcloud/_data
sudo tar -xvf nextcloud_files_01_17_2020.tar.gz -C /var/lib/docker/volumes/docker_nextcloud/_data
```
Change the configuration file and put the right domain in those two lines 25-45

Then start only the db container and run the backup, you need to have the same password
```
docker-compose start db
cat nextcloudDB_01_17_2020.sql | docker exec -i docker_db_1 /usr/bin/mysql -h localhost -u nextcloud --password=PASSWORD nextcloud
```

Next you can run everything back up
```
docker-compose up -d
```


# DOCKER Volumes COPY Solution

```
docker run --rm --volumes-from docker_app_1 -v $(pwd):/backup ubuntu tar cvfz /backup/app.tar.gz /var/www/html
docker run --rm --volumes-from docker_letsencrypt-companion_1 -v $(pwd):/backup ubuntu tar cvfz /backup/certs.tar.gz /etc/nginx/certs
docker run --rm --volumes-from docker_letsencrypt-companion_1 -v $(pwd):/backup ubuntu tar cvfz /backup/vhost.tar.gz /etc/nginx/vhost.d
docker run --rm --volumes-from docker_proxy_1 -v $(pwd):/backup ubuntu tar cvfz /backup/proxy.tar.gz /usr/share/nginx/html
docker run --rm --volumes-from docker_db_1 -v $(pwd):/backup ubuntu tar cvfz /backup/db.tar.gz /var/lib/mysql
```

```
#UNUSED docker volume create docker_nextcloud
#UNUSED docker volume create docker_db
#to check that the content is fine :
#
docker-compose up -d
#Wait a little bit for the system to create everything and initializethen
docker-compose stop

docker run --rm --volumes-from docker_app_1 -v /home/ambianceur/backups/:/backup ubuntu bash -c "cd /var/www/html/ && tar xvf /backup/app.tar.gz --strip 3"
docker run --rm --volumes-from docker_db_1 -v /home/ambianceur/backups/:/backup ubuntu bash -c "cd /var/lib/mysql/ && tar xvf /backup/db.tar.gz --strip 3"

docker-compose up -d



