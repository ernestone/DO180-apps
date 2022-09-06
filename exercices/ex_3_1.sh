# Registry
podman login registry.redhat.io

# Run container mysql
podman run --name mysql-db registry.redhat.io/rhel8/mysql-80:1

# Logs
podman logs mysql-db

# Run container mysql
podman run --name mysql \
-d -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 \
-e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 \
-d registry.redhat.io/rhel8/mysql-80:1

# Access container via bash
podman cp ~/DO180/labs/manage-lifecycle/db.sql mysql:/

# Run
podman run --name mysql-2 -it registry.redhat.io/rhel8/mysql-80:1 /bin/bash

