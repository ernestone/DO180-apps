# Create two deployments and create a route for one of them.
oc new-app --name hello \
--image quay.io/redhattraining/hello-world-nginx:v1.0 && \
oc new-app --name test \
--image quay.io/redhattraining/hello-world-nginx:v1.0 && \
oc expose service hello

# Verify access to the hello pod with the oc rsh and curl commands.
~/DO280/labs/network-policy/display-project-info.sh

oc rsh test-54bc94685b-mr2l4 \
curl 10.9.0.22:8080 | grep Hello

oc rsh test-54bc94685b-mr2l4 \
curl 172.30.239.28:8080 | grep Hello

# Create the network-test project and a deployment named sample-app.
oc new-project network-test && \
oc new-app --name sample-app \
--image quay.io/redhattraining/hello-world-nginx:v1.0

# From the network-policy project, create the deny-all network policy using the
# resource file available at ./network-policy/deny-all.yaml.
oc project network-policy && \
oc create -f /home/student/DO180-apps/exercices/network-policy/deny-all.yaml

# Verify there is no longer access to the hello pod via the exposed route. Wait a few
# seconds, and then press Ctrl+C to exit the curl command that does not reply.
curl -s \
hello-network-policy.apps.ocp4.example.com | grep Hello

# Create a network policy to allow traffic to the hello pod in the network-policy
# namespace from the sample-app pod in the network-test namespace over TCP on
# port 8080. Use the resource file available at ~/DO280/labs/network-policy/allow-
# specific.yaml.
oc create -n network-policy -f /home/student/DO180-apps/exercices/network-policy/allow-specific.yaml

# View the network policies in the network-policy namespace.
oc get networkpolicies -n network-policy

