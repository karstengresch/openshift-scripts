#!/bin/sh
# Origin: https://gist.githubusercontent.com/nmasse-itix/13881e132e327b83cc47a85a62b2e31d
# Original author: Nicolas Massé

# Your Initial Access Token
ACCESS_TOKEN="eyJhbGciOiJSUzI1NiIsImtpZCIgOiAiTXMwV0QtTjljVnJ2TWtjbFJhblBZaUZXVVFrbnRZeTVSY193MWNTNFZIayJ9.eyJqdGkiOiI3MTNiNDRmNy1iN2Y4LTQyYzUtOTE3Zi1jZGNlYTk4NGY0NzgiLCJleHAiOjE1MzEyMzg5MDIsIm5iZiI6MCwiaWF0IjoxNDk5NzAyOTAyLCJpc3MiOiJodHRwOi8vc3NvLXJlZGhhdC1zc28uMTkyLjE2OC40Mi4yNDkubmlwLmlvL2F1dGgvcmVhbG1zL2FwaTAxIiwiYXVkIjoiaHR0cDovL3Nzby1yZWRoYXQtc3NvLjE5Mi4xNjguNDIuMjQ5Lm5pcC5pby9hdXRoL3JlYWxtcy9hcGkwMSIsInR5cCI6IkluaXRpYWxBY2Nlc3NUb2tlbiJ9.Yl6Iw8mZTrDVdvMD00QSl90hDOoVK-NW0qAELM0w5aipSylPCTboA9LHLlMcjMISQs5WAhY0uFSTZ3ikqjz7d87wBYdTK8Gka-ixxjHOLRiDJ-2mBPnp1xzBHgxy7nlW-Lnu_uWxBoQdxP35JOwfP7j0bslRDA1SV2FzRHBiMdPPDCPIXmg70izDp65jvor7v4UlcC--gWp8u9pbFc0xG1I-o1KxoHWl9k1EHEgRAXNKcrUKMDcQRpXjuukcPYxHmkQ2bBeIMpLfFmFSBZLUmAv4O3WUojqUyn3f-wr1HanmjPLOzreQqFs5kYe5_53xYcNDuXVlHDGMniW4nRHwcA"

# The RH-SSO Realm
REALM="api01"

# The Hostname of the Secure Route of RH-SSO
SSO_HOST="sso-redhat-sso.192.168.42.249.nip.io"

# The parameters of the application you created in 3scale
CLIENT_ID="e846df74"
CLIENT_SECRET="19285ed2a5b3ca93d43976faff20394e"
REDIRECT_URL="https://www.getpostman.com/oauth2/callback"
# NB - had to change to http (at the end) as for which reason ever https setup failed.
curl -X POST -d "{ \"clientId\": \"$CLIENT_ID\", \"secret\": \"$CLIENT_SECRET\", \"redirectUris\":[ \"$REDIRECT_URL\" ] }" -H "Content-Type:application/json" -H "Accept: application/json" -H "Authorization: Bearer $ACCESS_TOKEN" --insecure "http://$SSO_HOST/auth/realms/$REALM/clients-registrations/default" 
