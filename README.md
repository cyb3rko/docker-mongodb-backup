# Docker MongoDB Backup

[![Docker hub version badge][dockerhub-version-badge]][dockerhub]
[![Docker hub pulls badge][dockerhub-pulls-badge]][dockerhub]

 [dockerhub-version-badge]: https://img.shields.io/docker/v/cyb3rko/mongodb-backup
 [dockerhub-pulls-badge]: https://img.shields.io/docker/pulls/cyb3rko/mongodb-backup
 [dockerhub]: https://hub.docker.com/repository/docker/cyb3rko/mongodb-backup

- [Example Usage](#example-usage)
  - [Via CLI](#via-cli)
  - [Via Docker Compose](#via-docker-compose)
  - [(Optional) Linking MongoDB and MongoDB Backup](#optional-linking-mongodb-and-mongodb-backup)
- [Parameters](#parameters)  
- [Restore from a backup](#restore-from-a-backup)

## Example Usage:

### Via CLI

```
docker run -d \
    --env MONGODB_HOST=mongodb \
    --env MONGODB_PORT=27017 \       # Optional, default: 27017
    --env MONGODB_USER=admin \       # Optional
    --env MONGODB_PASS=password \    # Optional
    --env CRON_TIME=0 */12 * * * \   # Optional, default: "0 0 * * *" -> everyday at 00:00
    --volume /host/backup:/backup    # Replace '/host/backup' with your backup folder path
    cyb3rko/mongodb-backup
```

### Via Docker Compose

```yml
mongo-backup:
  image: 'cyb3rko/mongodb-backup:latest'
  environment:
    MONGODB_HOST: "mongo"
    MONGODB_PORT: "27017"        # Optional, default: 27017
    CRON_TIME: "0 */12 * * *"    # Optional, default: "0 0 * * *" -> everyday at 00:00
    INIT_BACKUP: "true"          # Optional, default: no initial backup
    MAX_BACKUPS: "14"            # Optional, default: no limit
  volumes:
    - /host/backup:/backup    # Replace '/host/backup' with your backup folder path
```

### (Optional) Linking MongoDB and MongoDB Backup

Moreover, if you link `cyb3rko/mongodb-backup` to a mongodb container with an alias named mongodb, this image will try to auto load the `host`, `port`, `user`, `pass` if possible.

For example...

```bat
docker run -d -p 27017:27017 -p 28017:28017 -e MONGODB_PASS="mypass" --name mongodb mongo
docker run -d --link mongodb:mongodb -v /host/backup:/backup cyb3rko/mongodb-backup
```

## Parameters

```
MONGODB_HOST    the host/ip of your mongodb database
MONGODB_PORT    the port of your mongodb database (default: 27017)
MONGODB_USER    the username of your mongodb database. If MONGODB_USER is empty while MONGODB_PASS is not, the image will use admin as the default username
MONGODB_PASS    the password of your mongodb database
MONGODB_DB      the database name to dump. If not specified, it will dump all the databases
EXTRA_OPTS      the extra options to pass to mongodump command
CRON_TIME       the interval of cron job to run mongodump. '0 0 * * *' by default, which is every day at 00:00
MAX_BACKUPS     the number of backups to keep. When reaching the limit, the old backup will be discarded (default: no limit).
INIT_BACKUP     if set, create a backup when the container launches
```

## Restore from a backup

See the list of backups, you can run:

```
docker exec cyb3rko/mongodb-backup ls /backup
```

To restore database from a certain backup, simply run:

```
docker exec cyb3rko/mongodb-backup /restore.sh /backup/2015.08.06.171901
```
