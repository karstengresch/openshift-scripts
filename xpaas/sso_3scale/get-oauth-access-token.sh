#!/bin/bash
# Origin: https://gist.github.com/nmasse-itix/68c570e5eac9eb714ef4e87835953995
# Author: Nicolas Massé

APICAST_HOSTNAME=""

CLIENT_ID=""
CLIENT_SECRET=""
SCOPE="test"
REDIRECT_URI="https://www.getpostman.com/oauth2/callback"

echo
echo "Copy/Paste the following URL in your web browser :"
echo "https://$APICAST_HOSTNAME/authorize?client_id=$CLIENT_ID&scope=$SCOPE&response_type=code&redirect_uri=$REDIRECT_URI"
echo
echo "You will have to provide the login and password of your test user"
echo 
echo "Once you ends up on a blank page (hint: url starts with $REDIRECT_URI), copy/paste this URL below :"
echo 

URL=""
while [ -z "$URL" ]; do
  read -p "URL: " URL
done

regex='^.*[?&]code=([^&]+)(&|$)' 
if [[ "$URL" =~ $regex ]]; then
  CODE="${BASH_REMATCH[1]}"
else
  echo "OOPS, could not extract authorization code from the given URL. Sorry."
  exit 1
fi

curl --insecure -X POST -d "client_id=$CLIENT_ID" -d "client_secret=$CLIENT_SECRET" -d "grant_type=authorization_code" -d "redirect_uri=$REDIRECT_URI" -d "code=$CODE" "https://$APICAST_HOSTNAME/oauth/token"
