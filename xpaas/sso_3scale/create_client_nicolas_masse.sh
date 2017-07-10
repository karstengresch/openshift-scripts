#!/bin/sh
# Origin: https://gist.githubusercontent.com/nmasse-itix/13881e132e327b83cc47a85a62b2e31d
# Original author: Nicolas Massé

# Your Initial Access Token
ACCESS_TOKEN=""

# The RH-SSO Realm
REALM="3scale"

# The Hostname of the Secure Route of RH-SSO
SSO_HOST=""

# The parameters of the application you created in 3scale
CLIENT_ID=""
CLIENT_SECRET=""
REDIRECT_URL="https://www.getpostman.com/oauth2/callback"

curl -X POST -d "{ \"clientId\": \"$CLIENT_ID\", \"secret\": \"$CLIENT_SECRET\", \"redirectUris\":[ \"$REDIRECT_URL\" ] }" -H "Content-Type:application/json" -H "Accept: application/json" -H "Authorization: Bearer $ACCESS_TOKEN" --insecure "https://$SSO_HOST/auth/realms/$REALM/clients-registrations/default" 
