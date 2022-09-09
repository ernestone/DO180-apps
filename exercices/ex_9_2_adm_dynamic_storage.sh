# Log in to the cluster as the kubeadmin user. If prompted, accept the insecure
# certificate.
oc login -u kubeadmin -p ${RHT_OCP4_KUBEADM_PASSWD} \
https://api.ocp4.example.com:6443

# Create project
oc new-project install-storage

# Verify the storage class
oc get storageclass

# Create a new database deployment using the container image located at
# registry.redhat.io/rhel8/postgresql-13:1-7.
oc new-app --name postgresql-persistent \
--image registry.redhat.io/rhel8/postgresql-13:1-7 \
-e POSTGRESQL_USER=redhat \
-e POSTGRESQL_PASSWORD=redhat123 \
-e POSTGRESQL_DATABASE=persistentdb

# Create a new persistent volume claim to add a new volume to the postgresql-
# persistent deployment
oc set volumes deployment/postgresql-persistent \
--add --name postgresql-storage --type pvc --claim-class nfs-storage \
--claim-mode rwo --claim-size 10Gi --mount-path /var/lib/pgsql \
--claim-name postgresql-storage

# Verify that you successfully created the new PVC.
oc get pvc

# Verify that you successfully created the new PV.
oc get pv \
-o custom-columns=NAME:.metadata.name,CLAIM:.spec.claimRef.name