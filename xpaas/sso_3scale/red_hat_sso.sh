#!/bin/bash -
# globals
# name of the OCP project - all lowercase, only hyphens, no underscore etc.
SSO_PROJECTNAME="redhat-sso"
FILE_KEYSTORE_JKS="keystore.jks"
FILE_KEYSTORE_JGROUPS="jgroups.jceks"
PASSWORD_KEYSTORE_JKS="password123"
PASSWORD_KEYSTORE_JGROUPS="password123"
STOREPASS_KEYSTORE_JKS="password123"
STOREPASS_KEYSTORE_JGROUPS="password123"

# as per https://access.redhat.com/documentation/en-us/red_hat_jboss_middleware_for_openshift/3/html-single/red_hat_jboss_sso_for_openshift/
oc login -u system:admin
oc project openshift
oc create -n openshift -f https://raw.githubusercontent.com/jboss-openshift/application-templates/master/jboss-image-streams.json
oc replace -n openshift -f https://raw.githubusercontent.com/jboss-openshift/application-templates/master/jboss-image-streams.json
for template in sso71-https.json   sso71-mysql-persistent.json   sso71-mysql.json   sso71-postgresql-persistent.json   sso71-postgresql.json; do   oc create -n openshift -f   https://raw.githubusercontent.com/jboss-openshift/application-templates/master/sso/${template}; done
oc -n openshift import-image redhat-sso71-openshift
# project specific stuff
# clean up - thanks to Lutz Lange, see: https://github.com/LutzLange/openshift-cd-demo/blob/ocp-3.5/cicd.sh
echo "Deleting project for clean up first"
oc delete project $SSO_PROJECTNAME
while oc get projects | grep -i terminating; do echo Waiting for project termination; sleep 5; done

oc new-project $SSO_PROJECTNAME
rm -f $FILE_KEYSTORE_JKS $FILE_KEYSTORE_JGROUPS
keytool -genkeypair -alias keystore -storetype jks -keyalg RSA -keysize 2048 -keypass $PASSWORD_KEYSTORE_JKS -keystore $FILE_KEYSTORE_JKS -storepass $STOREPASS_KEYSTORE_JKS -dname "CN=SSL-Keystore,OU=IT,O=IT,L=Berlin,ST=B,C=DE" -validity 730 -v
keytool -genkeypair -alias jgroups -storetype jceks -keyalg RSA -keysize 2048 -keypass $PASSWORD_KEYSTORE_JGROUPS -keystore $FILE_KEYSTORE_JGROUPS -storepass $STOREPASS_KEYSTORE_JGROUPS -dname "CN=JGROUPS,OU=IT,O=IT,L=Berlin,ST=B,C=DE" -validity 730 -v
oc create secret generic sso-app-secret --from-file=keystore.jks --from-file=jgroups.jceks
oc create serviceaccount sso-service-account
oc policy add-role-to-user view system:serviceaccount:$SSO_PROJECTNAME:sso-service-account -n $SSO_PROJECTNAME
oc policy add-role-to-user system:image-puller -z default -n $SSO_PROJECTNAME
oc secret add sa/sso-service-account secret/sso-app-secret
oc secrets new sso-ssl-secret $FILE_KEYSTORE_JKS
oc secret new sso-jgroups-secret $FILE_KEYSTORE_JGROUPS
oc secrets link sso-service-account sso-ssl-secret sso-jgroups-secret
# uncomment to fully automize - you might want adding other envars. For a first start, create from the OCP console.
oc process -f https://raw.githubusercontent.com/jboss-openshift/application-templates/master/sso/sso71-mysql-persistent.json --param HTTPS_SECRET=sso-app-secret --param HTTPS_KEYSTORE=keystore.jks --param HTTPS_PASSWORD=$PASSWORD_KEYSTORE --param JGROUPS_ENCRYPT_KEYSTORE=jgroups.jceks --param JGROUPS_ENCRYPT_PASSWORD=$PASSWORD_KEYSTORE | oc create -n $SSO_PROJECTNAME -f -
# in case the image cannot be pulled, execute e.g. (check the sha hash!):
# oc tag —source=docker registry.access.redhat.com/redhat-sso-7/sso71-openshift@sha256:2c551ed9e5bb669eabd875a52779773e1bd9ab89b22cead3505b640139d02774 openshift/redhat-sso71-openshift:1.1 —insecure=true
# minishift ssh -- oc tag —source=docker registry.access.redhat.com/redhat-sso-7/sso71-openshift@sha256:2c551ed9e5bb669eabd875a52779773e1bd9ab89b22cead3505b640139d02774 openshift/redhat-sso71-openshift:1.1 —insecure=true
# Credits to Nicolas Massé:
# keytool -exportcert -alias ssl -keypass PASSWORD_KEYSTORE_JKS -storepass password123 -keystore keystore.jks -file cacert.pem -rfc
# e.g. keytool -exportcert -alias keystore -keypass password123 -storepass password123 -keystore keystore.jks -file cacert.pem -rfc
# perl -i.bak -pe 'chomp; s/\r//g; print "\\n"' cacert.pem
