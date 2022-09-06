# Registry
podman login registry.redhat.io

# Run container mysql
podman run --name mysql-basic \
-e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 \
-e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 \
-d registry.redhat.io/rhel8/mysql-80:1

# Verify status container
podman ps --format "{{.ID}} {{.Image}} {{.Names}}"

# Access container via bash
podman exec -it mysql-basic /bin/bash
