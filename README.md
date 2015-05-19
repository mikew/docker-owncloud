# docker-owncloud

Recent version of ownCloud using nginx, php-fpm and php-apcu. Uses the official
`owncloud.tar.bz2` from https://owncloud.org/install.

The default config supports installing owncloud apps to
`/var/www/owncloud/user-apps/` so you don't have to interfere with any default
apps.

Includes `avconv` for video thumbnails and `libreoffice-writer` for document
previews.

BYO database.

BYO SSL-enabled container.

## Running

```bash
docker run --name owncloud-postgres postgres:9.4
docker run --publish 80 --link owncloud-postgres:postgres mikewhy/owncloud:8.0.3-3
```

Or using docker-compose:

```yaml
web:
  image: mikewhy/owncloud:8.0.3-3
  links:
    - postgres:postgres

postgres:
  image: postgres:9.4
  environment:
    - POSTGRES_USER=owncloud
    - POSTGRES_PASSWORD=owncloud
```

## Configuring

There are only a few environment variables:

```bash
MAX_UPLOAD_SIZE=30G
ADMIN_USER=admin
ADMIN_PASS=changeme
DATA_DIR=/var/www/owncloud/data
DB_TABLE_PREFIX=oc_
DB_TYPE=sqlite3
DB_HOST=localhost
DB_PORT=
DB_NAME=owncloud
DB_USER=owncloud
DB_PASS=owncloud
```

If you link a postgres container as `postgres` or a mysql container as `mysql`
then the `DB_*` settings will be configured for you.

If there's more you would like to do, mount a directory at
`/docker-entrypoint.d/` and any `*.sh` files will be executed when the
container is started.
