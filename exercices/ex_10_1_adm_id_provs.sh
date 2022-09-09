# Create an HTPasswd authentication file named htpasswd in the ~/DO280/labs/
# auth-provider/ directory. Add the admin user with the password of redhat.
# The name of the file is arbitrary, but this exercise use the ~/DO280/labs/auth-
# provider/htpasswd file.
htpasswd -c -B -b ~/DO280/labs/auth-provider/htpasswd \
admin redhat

htpasswd -b ~/DO280/labs/auth-provider/htpasswd \
developer developer

# Log in to the cluster as the kubeadmin user
oc login -u kubeadmin -p ${RHT_OCP4_KUBEADM_PASSWD} \
https://api.ocp4.example.com:6443

# Create a secret from the ~/DO280/labs/auth-provider/htpasswd file. To
# use the HTPasswd identity provider, you must define a secret with a key named
# htpasswd that contains the HTPasswd user file ~/DO280/labs/auth-provider/
# htpasswd.
oc create secret generic localusers \
--from-file htpasswd=~/DO280/labs/auth-provider/htpasswd \
-n openshift-config

# Assign the admin user the cluster-admin role
oc adm policy add-cluster-role-to-user \
cluster-admin admin

# Update the HTPasswd identity provider for the cluster so that your users can authenticate.
# Configure the custom resource file and update the cluster.
# Export the existing OAuth resource to a file named oauth.yaml in the ~/DO280/
# labs/auth-provider directory.
oc get oauth cluster \
-o yaml > ~/DO280/labs/auth-provider/oauth.yaml

# Apply the custom resource defined in the previous step with the oauth.yaml edited
oc replace -f ~/DO280/labs/auth-provider/oauth.yaml

# Log in as admin and as developer to verify the HTPasswd user configuration.
oc login -u admin -p redhat

# Use the oc get nodes command to verify that the admin user has the cluster-
# admin role.
oc get nodes

# Log in to the cluster as the developer user to verify the HTPasswd authentication is
# configured correctly.
oc login -u developer -p developer

# Log as admin and list the current users
oc login -u admin -p redhat && oc get users

# Extract the file data from the secret to the ~/DO280/labs/auth-provider/
# htpasswd file.
oc extract secret/localusers -n openshift-config \
--to ~/DO280/labs/auth-provider/ --confirm