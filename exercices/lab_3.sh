# Create dir
mkdir -vp /home/student/local/mysql

# Add the appropriate SELinux context for the /home/student/local/mysql
# directory and its contents
sudo semanage fcontext -a \
-t container_file_t '/home/student/local/mysql(/.*)?'

# Apply the SELinux policy to the newly created directory
sudo restorecon -R /home/student/local/mysql

# Verify that the SELinux context type for the /home/student/local/mysql
# directory is container_file_t
ls -ldZ /home/student/local/mysql

# Change the owner of the /home/student/local/mysql directory to the mysql
# user and mysql group
podman unshare chown -Rv 27:27 /home/student/local/mysql

# Create and start the container
podman run --name mysql-1 -p 13306:3306 \
 -d -v /home/student/local/mysql:/var/lib/mysql/data \
 -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 \
 -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 \
 registry.redhat.io/rhel8/mysql-80:1

# Verify that the container was started correctly
podman ps --format="{{.ID}} {{.Names}}"

# Load the items database using the /home/student/DO180/labs/manage-review/
# db.sql script.
mysql -uuser1 -h 127.0.0.1 -pmypa55 -P13306 \
 items < /home/student/DO180/labs/manage-review/db.sql

# Use an SQL SELECT statement to output all rows of the Item table to verify that the
# Items database is loaded
mysql -uuser1 -h 127.0.0.1 -pmypa55 -P13306 \
 items -e "SELECT * FROM Item"

# Stop the container gracefully
podman stop mysql-1

# Create and start the container
podman run --name mysql-2 -p 13306:3306 \
 -d -v /home/student/local/mysql:/var/lib/mysql/data \
 -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 \
 -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 \
 registry.redhat.io/rhel8/mysql-80:1

# Save the list of all containers (including stopped ones) to the /tmp/my-containers file
podman ps -a > /tmp/my-containers

# Access the Bash shell inside the container and verify that the items database and the Item
# table are still available. Confirm also that the table contains data
podman exec -it mysql-2 /bin/bash

# Connect to the MySQL server
mysql -uroot

USE items;
SELECT * FROM Item;

# Using port forwarding, insert a new row into the Item table. The row should have a
# description value of Finished lab, and a done value of 1
mysql -uuser1 -h workstation.lab.example.com \
 -pmypa55 -P13306 items

INSERT INTO Item (description, done) VALUES ('Finished lab', 1);

# Remove the first container
podman rm mysql-1