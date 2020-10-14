#################################################################################################################
#                                                                                                               #
# Version 1.0 October 2020                                                                                      #
# Jairo Jimenez Arenas                                                                                          #
#                                                                                                               #
# Script to Get List of users and expiration dates                                                              #
# Requires: Windows PowerShell Module for Active Directory                                                      #
#                                                                                                               #
#################################################################################################################

Get-ADOrganizationalUnit -Filter * | Select Name, DistinguishedName | Out-String
$OUSearchBase = Read-Host -Prompt 'Copy & Paste OU'

get-aduser -Filter * -SearchBase $OUSearchBase -Properties * | Select SamAccountName, msTSExpireDate | Format-List >> ExpirationDates.csv