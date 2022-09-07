# Create a new project named ${RHT_OCP4_DEV_USER}-ocp for the resources you
# create during this exercise
oc new-project ${RHT_OCP4_DEV_USER}-ocp

# Create a temperature converter application named temps written in PHP using the php:7.3
# image stream tag.
# The source code is in the Git repository at https://github.com/RedHatTraining/
# DO180-apps/ in the temps directory. You may use the OpenShift command-line interface
# or the web console to create the application
oc new-app \
 php:7.3~https://github.com/RedHatTraining/DO180-apps \
 --context-dir temps --name temps

# Monitor progress of the build
oc logs -f bc/temps

# Verify that the application is deployed.
oc get pods -w

# Expose the temps service to create an external route for the application
oc expose svc/temps

# Determine the URL for the route
oc get route/temps