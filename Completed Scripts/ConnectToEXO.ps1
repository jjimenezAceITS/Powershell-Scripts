#######################################################################
#                                                                     #
# Version 1.0 January 2021                                            #
# Jairo Jimenez Arenas                                                #
#                                                                     #
# Script to Connect to Exchange Online                                #
# Checks if EXO modules are installed and if not then it installs it  #
# Requires: Windows PowerShell Module for Active Directory            #
#                                                                     #
#######################################################################


﻿if(!(Get-Module -ListAvailable -Name ExchangeOnlineManagement)){Install-Module ExchangeOnlineManagement}
$Email = Read-Host -Prompt 'Enter O365 Email (For MFA)'
Connect-ExchangeOnline -UserPrincipalName $Email -ShowProgress $true
