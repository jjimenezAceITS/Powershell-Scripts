
#################################################################################################################
#                                                                                                               #
# Version 1.0 October 2020                                                                                      #
# Jairo Jimenez Arenas                                                                                          #
#                                                                                                               #
# Script to Extend All Users in an OUs password                                                                 #
# Requires: Windows PowerShell Module for Active Directory                                                      #
#                                                                                                               #
#################################################################################################################

Get-ADOrganizationalUnit -Filter * | Select Name, DistinguishedName | Out-String
$OUSearchBase = Read-Host -Prompt 'Copy & Paste OU'

$Users = get-aduser -Filter "(Enabled -eq 'True') -And (ObjectClass -eq 'user') -And (PasswordNeverExpires -eq 'False')" -SearchBase $OUSearchBase | % {

    Set-ADUser -Identity $_ -Replace @{pwdLastSet=0} 

    Set-ADUser -Identity $_ -Replace @{pwdLastSet=-1} 
}