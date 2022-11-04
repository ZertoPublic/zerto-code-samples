# Legal Disclaimer
This script is an example script and is not supported under any Zerto support program or service. The author and Zerto further disclaim all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose.

In no event shall Zerto, its authors or anyone else involved in the creation, production or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or the inability to use the sample scripts or documentation, even if the author or Zerto has been advised of the possibility of such damages. The entire risk arising out of the use or performance of the sample scripts and documentation remains with you.

# About these Code Samples

In 9.5U1, Zerto introduced a new Zerto Virtual Manager Appliance (ZVMA) which differs from the "classic" Zerto Virtual Manager installed on a Windows Server. First and foremost, the authentication has changed to use [Keycloak](https://www.keycloak.org), an "Open Source Identity and Access Management" solution which supports a wide range of authentication methods. With that, scripts built for the classic ZVM will not work without modification. Instead of embedding a username and password into a script, an administrator would create a secret within Keycloak, call a Keycloak API with that secret, then receive a token to make calls to the APIs on the ZVML appliance going forward.

These code samples provide sample code in PowerShell showing how one could connect to a ZVM Appliance and perform some common operations, such as list VPGs.

# Code Samples in this Repo:

- [ZVML-simple-list-vpgs.ps1](ZVML-simple-list-vpgs.ps1) - Shows how to connect to ZVM Linux appliance using Keycloak token, then list VPGs of a Zerto site
