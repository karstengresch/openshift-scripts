#!/bin/bash -x
# 
# CICD Demo
# https://github.com/OpenShiftDemos/openshift-cd-demo
#
# you need to be loged in with oc for this to work
oc login -u system:admin
# Adjust this to e.g. $HOME/dev/co/openshift-cd-demo - wherever the checkout from...
# git clone https://github.com/OpenShiftDemos/openshift-cd-demo.git
# ...lies
TEMPLATEPATH="."

DEVP="cicd-dev"
STAGEP="cicd-stage"
MGMTP="cicd-mgmt"

echo "CLEANING UP FIRST - delete existing projects"
# cleanup before start
for PROJECT in $DEVP $STAGEP $MGMTP
do
  oc get project $PROJECT &>/dev/null && oc delete project $PROJECT
done

# check if projects are gone
while oc get projects | grep -i terminating; do echo Waiting for Project Deletion; sleep 5; done

echo "CREATING PROJECTS"
# Create the projects
oc new-project $DEVP --display-name="CI/CD Tasks - Dev"
oc new-project $STAGEP --display-name="CI/CD Tasks - Stage"
oc new-project $MGMTP --display-name="CI/CD Management"

# Allow the jenkins to access our projects
oc policy add-role-to-user edit system:serviceaccount:$MGMTP:jenkins -n $DEVP
oc policy add-role-to-user edit system:serviceaccount:$MGMTP:jenkins -n $STAGEP

echo "STARTING ROLL OUT"
# Lets roll
oc process -f $TEMPLATEPATH/cicd-template.yaml -p DEV_PROJECT=$DEVP -p STAGE_PROJECT=$STAGEP | oc create -f - -n $MGMTP
