# Create a new PHP application using the quay.io/redhattraining/php-hello-
# dockerfile image
oc new-app \
 --image=quay.io/redhattraining/php-hello-dockerfile \
 --name php-helloworld

# Wait until the application finishes deploying by monitoring the progress with the oc
# get pods -w command
oc get pods -w

# Alternatively, monitor the deployment logs with the oc logs -f php-
# helloworld-74bb86f6cb-zt6wl
oc logs -f php-helloworld-74bb86f6cb-zt6wl

# Review the service for this application using the oc describe command
oc describe svc/php-helloworld

# Expose the service, which creates a route. Use the default name and fully qualified domain
# name (FQDN) for the route
oc expose svc/php-helloworld

oc describe route

# Para ver que el servicio sale por la URL expuesta
curl \
 php-helloworld-${RHT_OCP4_DEV_USER}-route.${RHT_OCP4_WILDCARD_DOMAIN}

