oc create deployment loadtest --dry-run=client \
--image quay.io/redhattraining/loadtest:v1.0 \
-o yaml > ~/DO280/labs/schedule-review/loadtest.yaml

# create pod with last config edited
oc create --save-config \
-f ~/DO280/labs/schedule-review/loadtest.yaml

# Verify that your application pod specifies resource requests.
oc describe pod/loadtest-9447597bd-xbzs2 | \
grep -A2 Requests

# Create a horizontal pod autoscaler named loadtest for the loadtest application that
# will scale from 2 pods to a maximum of 40 pods if CPU load exceeds 70%. You can test the
# horizontal pod autoscaler by accessing the following URL to trigger the load test actions
oc autoscale deployment/loadtest --name loadtest \
--min 2 --max 40 --cpu-percent 70

# To get the "horizontal pod autoscaler" (hpa)
oc get hpa/loadtest

# As the admin user, implement a quota named review-quota on the schedule-review
# project. Limit the schedule-review project to a maximum of 1 full CPU, 2G of memory,
# and 20 pods.
oc create quota review-quota \
--hard cpu="1",memory="2G",pods="20"
