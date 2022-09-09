# Create app
oc create -f \
~/DO280/labs/network-ingress/todo-app-v1.yaml

# Run the oc expose command to create a route for accessing the application. Give
# the route a host name of todo-http.apps.ocp4.example.com.
oc expose svc todo-http \
--hostname todo-http.apps.ocp4.example.com

# Retrieve the name of the route and copy it to the clipboard.
oc get routes

# Open a new terminal tab and run the tcpdump command with the following options
# to intercept the traffic on port 80:
#  -i eth0 intercepts traffic on the main interface.
#  -A strips the headers and prints the packets in ASCII format.
#  -n disables DNS resolution.
# port 80 is the port of the application.
# Optionally, the grep command allows you to filter on JavaScript resources.
# Start by retrieving the name of the main interface whose IP is 172.25.250.9.
ip addr | grep 172.25.250.9
sudo tcpdump -i eth0 -A -n port 80 | grep "angular"

# Create a secure edge route. Edge certificates encrypt the traffic between the client and
# the router, but leave the traffic between the router and the service unencrypted. OpenShift
# generates its own certificate that it signs with its CA.
# In later steps, you extract the CA to ensure the route certificate is signed.
oc create route edge todo-https \
--service todo-http \
--hostname todo-https.apps.ocp4.example.com

# From the terminal, use the curl command with the -I and -v options to retrieve the
# connection headers.
# The Server certificate section shows some information about the certificate
# and the alternative name matches the name of the route. The output indicates that
# the remote certificate is trusted because it matches the CA.
curl -I -v https://todo-https.apps.ocp4.example.com

# Although the traffic is encrypted at the edge with a certificate, you can still access the
# insecure traffic at the service level because the pod behind the service does not offer
# an encrypted route.
# Retrieve the IP address of the todo-http service.
oc get svc todo-http \
-o jsonpath="{.spec.clusterIP}{'\n'}"

# Create a debug pod in the todo-http deployment. Use the Red Hat Universal Base
# Image (UBI), which contains some basic tools to interact with containers.
oc debug -t deployment/todo-http \
--image registry.access.redhat.com/ubi8/ubi:8.4