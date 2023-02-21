<#
Legal Disclaimer
This script is an example script and is not supported under any Zerto support program or service. The author and Zerto further disclaim all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose.

In no event shall Zerto, its authors or anyone else involved in the creation, production or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or the inability to use the sample scripts or documentation, even if the author or Zerto has been advised of the possibility of such damages. The entire risk arising out of the use or performance of the sample scripts and documentation remains with you.
#>

# Notes:
# - requires ZVM Linux Appliance 9.5U1 or higher, developed and tested on 9.5U3

# Variables to Configure

$zvmAddress = ""                                    # IP address or DNS name
$keycloakClientID = ""                              # defined in Keycloak - string name
$keycloakClientSecret = ""                          # defined in Keycloak - long string

$skipCertificateCheck = $true       # for self-signed certs, so this flag is passed to Invoke-RestMethod to allow it to proceed.

# Nothing below this line needs to be changed

# Setup API string conventions for later use

$keyCloakApiBase = "https://" + $zvmAddress + "/auth/realms/zerto/protocol/openid-connect/token"
$zvmApiBase = "https://" + $zvmAddress + "/v1/" 

# Connect to Keycloak with secret and get token
# Note: using Splat concept to neatly layout the arguments for Headers, Body, Method, and URI before making the call
# Splat is defined like a variable ($ prefix) but referenced in special way (@ prefix) which maps parameter/value for the function as key value pairs

$request = @{

    Headers     = @{
        ContentType  = "application/x-www-form-urlencoded"
    }

    Body        = @{
        client_id = $keycloakClientID
        client_secret = $keycloakClientSecret
        grant_type = "client_credentials"
    }
 
    StatusCodeVariable = "statusCode"

    Method      = "POST"
    URI = $keyCloakApiBase

    SkipCertificateCheck = $skipCertificateCheck
}

try {
    $result = Invoke-RestMethod @request
}
catch {
    Write-Error "Error connecting to Keycloak" -ErrorAction Stop
}

$token = $result.access_token

# Now that we have a token because of successful Keycloak authentication, we can proceed with Zerto REST API calls

$request = @{

    Headers     = @{
        ContentType  = "application/json"
        Authorization = "Bearer ${token}"
    }

    StatusCodeVariable = "statusCode"

    Method      = "GET"
    URI = $zvmApiBase + "vpgs/"

    SkipCertificateCheck = $skipCertificateCheck
}

try {
    $result = Invoke-RestMethod @request
}
catch {
    Write-Error "Error making API call to ZVM" -ErrorAction Stop
}

$result | select VPGName,VMsCount, SourceSite, TargetSite, ActualRPO | format-table
