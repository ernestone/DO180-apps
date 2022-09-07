# Create application resources with given yaml file.
oc create -f todo-app.yml

# From the workstation machine, configure port forwarding between workstation and
# the database pod running on OpenShift using port 3306. The terminal will hang after
# executing the command.
oc port-forward mysql 3306:3306

# From the workstation machine open another terminal and populate the data to the
# MySQL server using the MySQL client.
mysql -uuser1 \
 -h 127.0.0.1 -pmypa55 -P3306 items < db.sql

# Expose the Service.
oc expose service todoapi

# Use curl to test the REST API for the To Do List application.
curl -w "\n" \
 $(oc status | grep -o "http:.*com")/todo/api/items/1

