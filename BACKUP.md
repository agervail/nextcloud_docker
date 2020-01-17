# BACKUPS

## RCLONE for files

### Installation

[Installation](https://rclone.org/install/)

### Configuration

Remote config
--------------------
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
--------------------

### Usage

```
rclone copy --progress scaleway:/ .
```

## Nextcloud Data

If you really don't want to run it with root privileges...
------------
In order to allow the user antoine to do the backup you need to change the rights on a directory
```
chmod -R a+x /var/lib/docker/volumes/
chmod -R a+r /var/lib/docker/volumes/
```
/!\ you need to check that the data extraction works fine if not adjust the rights

------------

```
backup.sh
```
