+++++++++++++++++++++++++++++++++++++++++++ SCRIPTS +++++++++++++++++++++++++++++++++++++++++++

#####Get expiration dates#####
Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} >> ExpirationDatesForPWDs.csv


#####Get List of users and expiration dates#####
get-aduser -Filter * -SearchBase "OU=Onyx Users,DC=onyxrenewables,DC=com" -Properties * | Select SamAccountName,
 msTSExpireDate | Format-List >> ExpirationDatesAsOf03172020.csv
(edited)

#####Get List of users and expiration dates#####

get-aduser -Filter "(Enabled -eq 'True') -And (ObjectClass -eq 'user') -And (PasswordNeverExpires -eq 'False')" -SearchBase "OU=Users,OU=RENCO,DC=RencoGroup,DC=local" | % {
    Set-ADUser $_ -Replace @{pwdLastSet=0}
    Set-ADUser $_ -Replace @{pwdLastSet=-1}
}

#####Changing Proxy Addresses For All Users#####

$Users=Get-ADUser -SearchBase "OU=Evoke Users,DC=corp,DC=evokewealth,DC=com" -filter * | Select SamAccountName, DistinguishedName
$OldEmail="@Evokewealth.com"
$NewEmail="@Evokeadvisors.com"
Foreach ($User in $Users) { 
$NewSMTP= 'smtp:'+$User.SamAccountName+$NewEmail
$OldSMTP= 'SMTP:'+$User.SamAccountName+$OldEmail
Set-ADUser -Identity $user.DistinguishedName -Replace @{ProxyAddresses= $NewSMTP, $OldSMTP} 
}

#####Add-MailboxFolderPermission#####
Add-MailboxFolderPermission -Identity Aditya.Agarwal@bre-asia.com:\Calendar -User SPAdmin@breasiapteltd.onmicrosoft.com -AccessRights Editor -SharingPermissionFlags Delegate,CanViewPrivateItems

#####Remove-MailboxFolderPermission#####
Remove-MailboxFolderPermission -Identity Aditya.Agarwal@bre-asia.com -User SPAdmin@breasiapteltd.onmicrosoft.com -AccessRights FullAccess -InheritanceType All

?????Extend AzureAD Password?????
Get-AzureADUser -ObjectId 20278681-04a3-47d0-9128-2431d6143e9c | Select-Object UserprincipalName,@{
    N="PasswordNeverExpires";E={$_.PasswordPolicies -contains "DisablePasswordExpiration"}
 }

Set-AzureADUser -ObjectId 20278681-04a3-47d0-9128-2431d6143e9c -PasswordPolicies DisablePasswordExpiration

#####Get Users in a Group#####

Get-ADUser -Filter * -Properties * | ForEach-Object {if($_.MemberOf -contains "CN=Citrix Apps,OU=Sunlight Groups,DC=corp,DC=sunlightfinancial,DC=com"){Write-Output $_.Name, $_.DistinguishedName | Out-File .\Test.csv -Append}}

Get-ADUser -Filter * -Properties * | ForEach-Object {if($_.MemberOf -contains "CN=Citrix Apps,OU=Sunlight Groups,DC=corp,DC=sunlightfinancial,DC=com"){Select Name, DistinguishedName | ft Name, DistinguishedName}}

####Pinging VPN Address#####
While($True) {
   $vpns = 'citrix.','view.', 'portal.', 'remote.', 'vpn.'
   $domain = Read-Host -Prompt 'Enter Company Domain'
   ForEach($vpn in $vpns) {
   if( Test-Connection ($vpn + $domain) -Count 1 -Quiet) {
       Write-Host $domain Is using $vpn
       Start-Process -FilePath ('https:\\' + $vpn + $domain)
       } Else {Write-Host $domain is Not using $vpn}
   }
}

#####Connect to Exchange Online MFA#####
if(!(Get-Module -ListAvailable -Name ExchangeOnlineManagement)){Install-Module ExchangeOnlineManagement}
$Email = Read-Host -Prompt 'Enter O365 Email (For MFA)'
Connect-ExchangeOnline -UserPrincipalName $Email -ShowProgress $true

#####Account Lockout Notification#####
$AccountLockOutEvent = Get-EventLog -LogName "Security" -InstanceID 4740 -Newest 1
$LockedAccount = $($AccountLockOutEvent.ReplacementStrings[0])
$AccountLockOutEventTime = $AccountLockOutEvent.TimeGenerated
$AccountLockOutEventMessage = $AccountLockOutEvent.Message
$messageParameters = @{ 
Subject = "BHGRP-AD1-Account Locked Out: $LockedAccount" 
Body = "Account $LockedAccount was locked out on $AccountLockOutEventTime.`n`nEvent Details:`n`n$AccountLockOutEventMessage"
From = "gandalf@bhgrp.com" 
To = "support@bhgrp.com" 
SmtpServer = "bhgexch01.bhgrp.com" 
} 
Send-MailMessage @messageParameters

#####Admin Login Notification#####
$AccountLogonEvent = Get-EventLog -LogName "Security" -InstanceID 4624 -Newest 1
$Account = $($AccountLockOutEvent.ReplacementStrings[0])
$AccountLogonEventTime = $AccountLogonEvent.TimeGenerated
$AccountLogonEventMessage = $AccountLogonEvent.Message
$messageParameters = @{ 
Subject = "Admin account logon detected: $Account" 
Body = "Account $Account was logged on $AccountLogonEventTime.`n`nEvent Details:`n`n$AccountLogonEventMessage"
From = "gandalf@bhgrp.com" 
To = "czale@rfa.com" 
SmtpServer = "bhgexch01.bhgrp.com" 
} 
Send-MailMessage @messageParameters
--------------------------------------------------------------------------------------------------------------
+++++++++++++++++++++++ SCRIPTS TO TEST +++++++++++++++++++++++++++++++++++++++++++
#####Who still has a file open on the Samba share drive and at which computer.#####
Get-SmbOpenFile | Where-Object -Property ShareRelativePath -Match “filename”

--------------------------------------------------------------------------------------------------------------
+++++++++++++++++++++++++++ LINKS +++++++++++++++++++++++++++++++++++++++++++
https://tech.xenit.se/join-windows-10-computer-azure-active-directory/

Xenit TechnicalXenit Technical
How to join a Windows 10 computer to your Azure Active Directory
Introduction Some of the benefits of having your Windows 10 devices in your Azure AD is that your users can join the computer to your Azure AD without any extra administrator privileges, assuming you have configured this in your Azure AD. They can also login to the computer without the need of bein
Jan 5th, 2018
(207 kB)
https://tech.xenit.se/wp-content/uploads/2018/01/tech-top-post-april-webb.png
10:40
https://superuser.com/questions/982336/how-do-i-add-azure-active-directory-user-to-local-administrators-group

Super UserSuper User
How do I add Azure Active Directory User to Local Administrators Group
With Windows 10 you can join an organisation (=Azure Active Directory) and login with your cloud credentials. Based on the information provided here the first account per computer that joins the

Jairo Jimenez  3:46 PM
https://www.experts-exchange.com/articles/8392/Manually-Update-Global-Address-List-GAL-on-Exchange-2010.html

experts-exchange.comexperts-exchange.com
Manually Update Global Address List (GAL) on Exchange 2010
I picked up that there is a lot of questions on Expert Exchange relating to Global Address Lists (GAL's) not updating so I thought that I would create this article to show you how to manually...(17 kB)
https://www.experts-exchange.com/images/experts-exchange/social/shareLogoEE.jpg

Jairo Jimenez  4:05 PM
UPDATE ADDRESS BOOKS
Update-GlobalAddressList -Identity "Default Global Address List" -DomainController "forosgroup.local"
(edited)

Jairo Jimenez  9:53 AM
https://docs.microsoft.com/en-us/windows-server/storage/dfs-replication/dfsr-overview

Jairo Jimenez  10:04 AM
https://forsenergy.com/en-us/dfs2/html/1fafa56c-ef2e-48dd-bb23-44cead82df34.htm

Jairo Jimenez  10:47 AM
https://techcommunity.microsoft.com/t5/itops-talk-blog/step-by-step-manually-removing-a-domain-controller-server/ba-p/280564

TECHCOMMUNITY.MICROSOFT.COMTECHCOMMUNITY.MICROSOFT.COM
Step-By-Step: Manually Removing A Domain Controller Server
Use of DCPROMO is still the proper way to remove a DC server in an Active Directory infrastructure. The following video provides an example of these steps:     Certain situations, such as server crash or failure of the DCPROMO option, require manual removal of the DC from the system by cleaning up ...
Nov 1st, 2018
(24 kB)
https://gxcuf89792.i.lithium.com/t5/image/serverpage/image-id/58795i4F97EA6E54386773?v=1.0


Jairo Jimenez  3:28 PM
https://www.wincert.net/windows-server/how-to-grant-non-admin-users-permissions-for-managing-scheduled-tasks/

WinCertWinCert
How to grant non-admin users permissions for managing Scheduled Tasks - WinCert
Following the tutorial on how to grant permissions for non-admin users to handle services on the server, here is the tutorial on how to grant non-admin users permission to handle scheduled tasks on the...
Jul 22nd, 2018
(89 kB)
https://www.wincert.net/wp-content/uploads/2015/01/windows-server2.jpg

Jairo Jimenez  4:55 PM
https://community.spiceworks.com/topic/581041-export-list-of-gpos-and-their-associated-settings

Jairo Jimenez  11:50 AM
Reseting MFA in 365
http://techgenix.com/multifactor-authentication-office-365/

TechGenixTechGenix
Multifactor authentication for Office 365: A step-by-step guide
Passwords, no matter how strong, will not keep your systems safe. Fortunately, setting up multifactor authentication for Office 365 is easy. Follow this tutorial, and sleep easy.
Feb 22nd, 2018
(69 kB)
http://techgenix.com/tgwordpress/wp-content/uploads/2018/02/Multifactor-authentication-Pixabay-1024x321.jpg

Jairo Jimenez  4:10 PM
Assigning One drive to user
https://kb.wsu.edu/76414


Jairo Jimenez  8:30 AM
Assigning one drive to someone
https://sharepointmaven.com/how-to-access-someone-elses-onedrive-account/

SharePoint MavenSharePoint Maven
How to access someone else's OneDrive account - SharePoint Maven
Are you trying to access your colleague's OneDrive? Maybe they left the company or about to retire and you do not want to lose the important files they might have. This article explains step by step on how to access someone else's OneDrive
Jul 25th, 2018
(116 kB)
https://sharepointmaven.com/wp-content/uploads/2018/06/keyboard-621830_960_720.jpg

Jairo Jimenez  3:29 PM
Installing Fonts Via GPO
https://community.spiceworks.com/how_to/145419-deploy-new-fonts-via-gpo

community.spiceworks.comcommunity.spiceworks.com
Deploy New Fonts via GPO
Here's how to deploy new fonts via GPO. In this tutorial, I'll be installing this font: Orkney Bold Italic.ttf Pre-requisite: New font. Place new font in a...

Jairo Jimenez  3:34 PM
https://helpdeskgeek.com/help-desk/how-to-fix-rpc-server-is-unavailable-error-in-windows/

Help Desk GeekHelp Desk Geek
How to Fix ‘RPC Server is Unavailable’ Error in Windows
Those of you who have been using Windows for some time may have already bore witness to the “RPC Server is Unavailable” error. This is one of the more common [...]
Sep 13th, 2019
(57 kB)
https://helpdeskgeek.com/wp-content/pictures/2019/09/cropped-Fixing-The-‘RPC-Server-is-Unavailable’-Error-in-Windows-main.jpg.optimal.jpg

Jairo Jimenez  9:16 AM
https://www.grouppolicy.biz/2010/03/group-policy-setting-of-the-week-18-allow-file-downlaod-internet-explorer/


Jairo Jimenez  9:42 PM
https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/exchange-online-powershell-v2/exchange-online-powershell-v2?view=exchange-ps

docs.microsoft.comdocs.microsoft.com
Exchange Online PowerShell V2
Learn how to download and use the Exchange Online PowerShell V2 module to connect to Exchange Online PowerShell.

Jairo Jimenez  10:52 PM
https://docs.microsoft.com/en-us/powershell/module/azuread/set-azureaduser?view=azureadps-2.0
10:52
https://medium.com/gitbit/hide-user-from-address-lists-ad-connect-ee67f2369bc1

MediumMedium
Hide User from Address Lists (AD Connect)
The operation on mailbox failed because it’s out of the current users’s write scope.

https://miro.medium.com/max/712/1*nSGfArEq7cmtEwXqn0Pavg.png
10:52
https://www.reddit.com/r/sysadmin/comments/b9t32d/can_i_add_msexchhidefromaddresslists_attribute/

redditreddit
Can I add msExchHideFromAddressLists attribute without extending schema? Office 365
We use on prem active directory synced with AD Connect. There has not been and is not an on prem exchange server. &#x200B; So I have solutions...
10:52
https://www.tachytelic.net/2017/11/office-365-hide-a-user-from-gal-ad-sync/

Tachytelic.netTachytelic.net
Office 365: How to hide a user from the Global Address List when using Dirsync,AADSync or Azure Active Directory Connect
Hide a user from the Global Address List (GAL) when synchronising your on-premise active directory to Office 365 using ADSI Edit or PowerShell.
Nov 15th, 2017
(8 kB)
http://tachytelic.net/wp-content/uploads/Set-Mailbox-HiddenFromAddressLists-365Gui.png
10:52
https://social.technet.microsoft.com/Forums/office/en-US/89b424a2-85fa-4b6b-b3b2-71eae2455556/msexchhidefromaddresslists-azure-ad-synchronisation?forum=onlineservicesexchange
10:52
https://supertekboy.com/2017/01/01/unable-to-connect-to-the-synchronization-service/

SuperTekBoySuperTekBoy
Unable to connect to the Synchronization Service - Azure AD
If you run into an error regarding the Synchronization Service after installing Azure AD Connect then the fix might be quite simple.
Jan 1st, 2017
(22 kB)
https://cdn.supertekboy.com/wp-content/uploads/2017/01/Unable-to-connect-to-the-Synchronization-Service.jpg
10:56
https://supertekboy.com/2014/07/03/hide-mail-contact-from-global-address-list/

SuperTekBoySuperTekBoy
Hide Mail Contact from Global Address List
That seems a little counterproductive, doesn't it? Isn't the whole point of a Mail Contact to put an external address in your Global Address List? Well, yes and no. There are certain situations where you may not want an external contact to be generally available to your user base. Take this scenario for example. You are the sole IT person at your company. You contract an external company to perform network monitoring 24x7. Your devices email out alerts to a distribution list. This distribution list contains two people. Yourself and the mail contact for the monitoring company. You both get the alerts. They are your safety net when you aren't looking. Their
Jul 3rd, 2014
(134 kB)
https://cdn.supertekboy.com/wp-content/uploads/2014/06/Hide-a-Mail-Contact-from-Address-Lists-B.jpg
10:56
https://jaapwesselius.com/2015/06/23/the-operation-on-mailbox-failed-because-its-out-of-the-current-users-write-scope/

Jaap WesseliusJaap Wesselius | jaapwesselius
The operation on mailbox failed because it’s out of the current user’s write scope
When you want to change an email address on a Mailbox in Office 365 you get the following error message:
The operation on mailbox “” failed because it’s out of the current user’s write scope. The action ‘Set-Mailbox’, ‘EmailAddresses’, can’t be performed on the object ‘Stacey Brown’ because the object is being synchronized from your on-premises organization. This action should be performed on the object in your on-premises organization.
This issue is caused by the fact you’re synchronizing user objects from a local Active Directory using DirSync or WAADSync, and you want to change properties in Office 365. This is not poss… Show more
10:56
https://community.spiceworks.com/topic/2145086-ad-attribute-to-modify-to-hide-a-distro-from-the-gal

The Spiceworks CommunityThe Spiceworks Community
AD attribute to modify to hide a distro from the GAL?
Hi Everyone,We are syncing AD objects to O365 via AAD Connect. What is the AD attribute to modify to hide a distro from the GAL? I tried it from O365 Exchange Admin Center...
10:57
https://365adviser.com/office-365/securely-connect-office-365-azure-ad-using-powershell-mfa/
10:59
https://365adviser.com/office-365/securely-connect-office-365-azure-ad-using-powershell-mfa/

Jairo Jimenez  7:49 AM
https://harborcloud.zendesk.com/hc/en-us/articles/212587466-Click-to-launch-an-app-and-another-local-program-opens-instead

Summit Hosting Seattle SupportSummit Hosting Seattle Support
Click to launch an app and another local program opens instead
Your computer may not be using the correct program to launch your Citrix applications. Typically, you just need to install the Citrix Receiver and then your computer will automatically start using ...(36 kB)
https://theme.zdassets.com/theme_assets/143809/87dc2fd6d0d3558e69186950d2d1bfe6a3b7d612.png

Jairo Jimenez  11:06 AM
When citrix isnt opening ICA files
For Windows Users:
Locate the .ica file downloaded from Chrome (typically in your local Downloads folder)
The .ica file names are a bit ugly -- they usually begin with Q29 and are followed by a string of numbers and upper- and lower-case letters
For example, the .ica file name be something like Q29udHJvbGvlci5RTVIjRKVza3RxcA.ica
Right-click on the .ica and select Open with...
Make sure the Always open with this app box is checked, then click on More apps and scroll down to Look for another app on this PC
Browse to C:\Program Files (x86)\Citrix\ICA Client
If you cannot find that directory, look for C:\Program Files\Citrix\ICA Client instead
Select wfcrun32 from the above directory and click Open to set the Citrix Connection Manager as the default program to launch .ica files
Restart your web browser
Log back in and launch your application again

Slackbot  1:39 PM
You can use these URL directly from your computer, no need for CITRIX, which is the rule until further notice.
ConnectWise Manage: http://shire.rfa.com/
Sconnect: https://rfahelp.com
Citrix: https://remote.rfa.com/
BrightGauge: https://rfacom.brightgauge.co/
Knowledge Base & Glossary: https://rfalondon.sharepoint.com/:o:/s/service_operations/Elp5y4cQbYZLoZpYfzeV6AsBWcTPugS1s2prBI4FADmZSw
Jira: https://rfatech.atlassian.net/secure/RapidBoard.jspa
Confluence: https://rfatech.atlassian.net/wiki/spaces
For ConnectWise Automate: please type !automate
For Logic Monitor: please type !LM
These URL need CITRIX access
SharePoint OnPrem: http://rfasharepntap01/
SecretServer: https://rfasecure01.shire.rfanyc.com/SecretServer/