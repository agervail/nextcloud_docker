# Server configuration scaleway

## Sudo 

Because scaleway run a weird ubuntu instance you don't have sudo installed
```
apt install sudo
usermod -aG sudo antoine
mkdir /home/antoine/.ssh
cp /root/.ssh/authorized_keys /home/antoine/.ssh
chown -R antoine:antoine /home/antoine/.ssh
```
If there's a problem with sudo you then need to modify the sudoers file
```
chmod +w /etc/sudoers
vim /etc/sudoers
```
Add this line at the end of the file
```
%sudo   ALL=(ALL:ALL) ALL
```
then put it back on readonly
```
chmod -w /etc/sudoers
```

After that you can log as antoine

## Docker

Install docker https://docs.docker.com/install/linux/docker-ce/ubuntu/

Don't forget to add your user in docker group

And to run docker on boot :
```
sudo systemctl enable docker
```
then install docker-compose
https://docs.docker.com/compose/install/

## Configuration

* Add password in db.env __l1__ and docker-compose.yml __l11__
* Change the VIRTUAL_HOST, LETSENCRYPT_HOST and LETSENCRYPT_EMAIL __l21-23__ in docker-compose.yml

## RUN

to run the docker :
```
cd nextcloud_docker/docker
docker-compose build --pull
docker-compose up -d
```

## Bucket Storage scaleway

In order to use bucket storage provided by scaleway you need to do some more steps
* Create a bucket (Storage -> Object Storage)
* Then create a Access Token via :
  https://www.scaleway.com/en/docs/generate-an-api-token/
* Then log in as root (as the file are owned by www-data) and change the config.php
```
vim /var/lib/docker/volumes/docker_nextcloud/_data/config/config.php
```
add those lines :
```
'objectstore' => array(
      'class' => '\\OC\\Files\\ObjectStore\\S3',
      'arguments' => array(
              'bucket' => 'tenup-bucket',
              'autocreate' => true,
              'key'    => 'ACCESS-KEY',
              'secret' => 'SECRET-KEY',
              'hostname' => 's3.fr-par.scw.cloud',
              // The hostname depends on the geographical location of your bucket: It can be either s3.fr-par.scw.cloud or s3.nl-ams.scw.cloud
              'port' => 443,
              'use_ssl' => true,
              'region' => 'fr-par',
              // Region can be either fr-par or nl-ams
      ),
),
```

wait a moment and the changes should happen
