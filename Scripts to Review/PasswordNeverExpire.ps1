##################################################################################################################
# Please Configure the following variables....
$smtpServer = "gppfunds-com.mail.protection.outlook.com"
$from = "GPP Alerts <alerts@gppfunds.com>"
$toadmin = "jjimenez@rfa.com"
$adminlist=""
$smtpPort = 587

$dayssincelastlogon = (Get-Date).AddDays(-90)


###################################################################################################################
#Removing | where { $_.passwordexpired eq $false}
#Get Users From AD who are enabled
Import-Module ActiveDirectory
$users = get-aduser -filter * -properties * |where {$_.Enabled -eq "True"} | where { $_.PasswordNeverExpires -eq $true }

foreach ($user in $users)
{
  $fullname = (Get-ADUser $user | foreach { $_.Name})
  $Name = (Get-ADUser $user | foreach { $_.GivenName})
  $passwordSetDate = (get-aduser $user -properties * | foreach { $_.PasswordLastSet })
  $lastLogonDate = (get-aduser $user -properties * | foreach { $_.LastLogonDate })
  $adminlist="$adminlist<br>$fullname - PasswordDate: $passwordSetDate  - LastLogonDate: $lastLogonDate<br>"
}

$users90 = get-aduser -filter * -properties * |where {$_.Enabled -eq "True"}

foreach ($user2 in $users90)
{
  $fullname = (Get-ADUser $user2 | foreach { $_.Name})
  $Name = (Get-ADUser $user2 | foreach { $_.GivenName})
  $lastLogonDate = (get-aduser $user2 -properties * | foreach { $_.LastLogonDate })
  if ($lastLogonDate -lt $dayssincelastlogon )
  {
  $adminlist2="$adminlist2<br>$fullname LastLogonDate: $lastLogonDate<br>"
  }
}





#Email AdminList
$subject="Password NeverExpire: User passwords are set to never expire"
$body ="
Dear Administrators,
<p>Below is a list of users and their password status that are set to never expire.<br>
<p>$adminlist<br><br>

<p>Below is a list of users who have NOT logged in the past 90 days.<br>
<p>$adminlist2<br>
<br>
<p>Thank you.
</p>"


Send-Mailmessage -smtpServer $smtpServer -from $from -to $toadmin -subject $subject -body $body -bodyasHTML -priority High


