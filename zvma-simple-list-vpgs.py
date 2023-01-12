# Legal Disclaimer
# This script is an example script and is not supported under any Zerto support program or service. The author and Zerto further disclaim all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose.
# In no event shall Zerto, its authors or anyone else involved in the creation, production or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or the inability to use the sample scripts or documentation, even if the author or Zerto has been advised of the possibility of such damages. The entire risk arising out of the use or performance of the sample scripts and documentation remains with you.
#

# Notes:
# - requires ZVM Linux Appliance 9.5U1 or higher, developed and tested on 9.7U1

# Libraries needed

import requests 
import json 

# Variables to Configure

zvmAddress = ""                                    # IP address or DNS name
keycloakClientID = ""                              # defined in Keycloak - string name
keycloakClientSecret = ""                          # defined in Keycloak - long string
verifyCertificate = False 

# Setup API string conventions for later use

keyCloakApiBase = "https://" + zvmAddress + "/auth/realms/zerto/protocol/openid-connect/token"
zvmApiBase = "https://" + zvmAddress + "/v1/" 

# Connect to Keycloak with secret and get token

uri = keyCloakApiBase

headers = {
     'Content-Type': 'application/x-www-form-urlencoded'
   }

body = {
    'client_id': keycloakClientID,
    'client_secret': keycloakClientSecret,
    'grant_type': 'client_credentials'
}

try:
    response = requests.post(uri, headers=headers, data=body, verify=verifyCertificate)
except BaseException as e:
    print("Exception:", e)
    quit()


if response.ok:
    token = response.json()['access_token']
else:
    print("HTTP %i - %s, Message %s" % (response.status_code, response.reason, response.text))   
    quit()

# Now that we have a token because of successful Keycloak authentication, we can proceed with Zerto REST API calls

uri = zvmApiBase + 'vpgs/'

headers = {
     'Content-Type': 'application/json',
     'Authorization': 'Bearer ' + token
   }

body = {
}

try:
    response = requests.get(uri, headers=headers, data=body, verify=verifyCertificate)
except BaseException as e:
    print("Exception:", e)
    quit()

if response.ok:
    vpgInfo = response.json()
else:
    print("HTTP %i - %s, Message %s" % (response.status_code, response.reason, response.text))   
    quit()

# Print JSON out in a nice way

print ("VPGs:")
print (json.dumps(vpgInfo, indent=1))
