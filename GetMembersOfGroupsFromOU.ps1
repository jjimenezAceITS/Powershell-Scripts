#################################################################################################################
# 
# Version 1.0 October 2020
# Jairo Jimenez
# 
# Script to get Members in a group from an OU
# Requires: Windows PowerShell Module for Active Directory
#
##################################################################################################################

Get-ADOrganizationalUnit -Filter * | Select Name, DistinguishedName | Out-String
$OUSearchBase = Read-Host -Prompt 'Copy & Paste OU'
$GroupName = Read-Host -Prompt 'Name of Security/Distro Group'
Get-ADUser -Filter * -Properties Name, MemberOf -SearchBase $OUSearchBase| Where{$_.MemberOf -contains (Get-ADGroup $GroupName).distinguishedName} | Select Name