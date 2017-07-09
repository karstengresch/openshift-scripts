# as per the documentation at https://support.3scale.net/guides/infrastructure/onpremises20-installation
THREESCALE_PROJECTNAME="3scale-amp"
THREESCALE_AMP_TEMPLATE="https://raw.githubusercontent.com/3scale/3scale-amp-openshift-templates/2.0.0.GA-redhat-2/amp/amp.yml"
WILDCARD_DOMAIN="192.168.42.249.nip.io"

oc login -u system:admin
oc new-project $THREESCALE_PROJECTNAME
oc new-app --file $THREESCALE_AMP_TEMPLATE --param WILDCARD_DOMAIN=$WILDCARD_DOMAIN

# Following Nicolas Massé's tutorial

# Client ID e846df74
# Client Secret 19285ed2a5b3ca93d43976faff20394e

