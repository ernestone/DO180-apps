# Create a secret with the credentials and connection information to access a MySQL
# database.
oc create secret generic mysql \
--from-literal user=myuser --from-literal password=redhat123 \
--from-literal database=test_secrets --from-literal hostname=mysql

# Deploy a database and add the secret for user and database configuration.
oc new-app --name mysql \
--image registry.redhat.io/rhel8/mysql-80:1

# Run the oc get pods command with the -w option to retrieve the status of the
# deployment in real time. Notice how the database pod is in a failed state
# FALLA por falta de env vars de usr y psw
oc get pods -w

# Use the mysql secret to initialize environment variables on the mysql deployment.
# The deployment needs the MYSQL_USER, MYSQL_PASSWORD, and MYSQL_DATABASE
# environment variables for a successful initialization. The secret has the user,
# password, and database keys that can be assigned to the deployment as
# environment variables, adding the prefix MYSQL_.
oc set env deployment/mysql --from secret/mysql \
--prefix MYSQL_

# To demonstrate how a secret can be mounted as a volume, mount the mysql secret
# to the /run/secrets/mysql directory within the pod. This step only shows how to
# mount a secret as a volume, it is not required to fix the deployment.
oc set volume deployment/mysql --add --type secret \
--mount-path /run/secrets/mysql --secret-name mysql

# Verify that the database now authenticates using the environment variables initialized from
# the mysql secret.
oc rsh mysql-????????-XXXXX

for FILE in $(ls /run/secrets/mysql)
 do
 echo "${FILE}: $(cat /run/secrets/mysql/${FILE})"
 done
