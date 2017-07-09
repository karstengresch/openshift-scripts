#!/bin/bash -
# assuming running on minishift
oc login -u developer -p developer --insecure-skip-tls-verify=true
oc new-project rest-services --display-name="rest-services-ola"
oc new-app service-ola openshift/redhat-openjdk18-openshift:1.1~https://github.com/redhat-helloworld-msa/ola.git 
