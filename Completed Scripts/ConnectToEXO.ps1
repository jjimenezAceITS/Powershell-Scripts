if(!(Get-Module -ListAvailable -Name ExchangeOnlineManagement)){Install-Module ExchangeOnlineManagement}
$Email = Read-Host -Prompt 'Enter O365 Email (For MFA)'
Connect-ExchangeOnline -UserPrincipalName $Email -ShowProgress $true