##################################################################################################################
# Please Configure the following variables....
$smtpServer = "gppfunds-com.mail.protection.outlook.com"
$from = "GPP Alerts <alerts@gppfunds.com>"
$toadmin = "jjimenez@rfa.com"
$expireindays = 10
$adminlist=""
$numberusers = 0
###################################################################################################################
#Removing | where { $_.passwordexpired eq $false}
#Get Users From AD who are enabled
Import-Module ActiveDirectory
$users = get-aduser -filter * -properties * |where {$_.Enabled -eq "True"} | where { $_.PasswordNeverExpires -eq $false }

foreach ($user in $users)
{
  $fullname = (Get-ADUser $user | foreach { $_.Name})
  $Name = (Get-ADUser $user | foreach { $_.GivenName})
  $emailaddress = $user.emailaddress
#  $emailaddress = "czale@rfa.com"
  $passwordSetDate = (get-aduser $user -properties * | foreach { $_.PasswordLastSet })
  $maxPasswordAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge
  $expireson = $passwordsetdate + $maxPasswordAge
  $today = [datetime]::Today
  $daystoexpire = (New-TimeSpan -Start $today -End $expireson).Days

#For users whose password already expired
  if ($daystoexpire -le 10)
	{
		$numberusers = $numberusers + 1
		$adminlist="$adminlist<br>$fullname - EXPIRED<br>"
  		$subject="Your password is EXPIRED"
  		$body ="
  		Dear $name,
  		<p> Your password is expired.<br>
		<p>Please call the RFA Helpdesk ( 212.867.4600 ) to update your password.<br><br>	
  		<p>Thank you. <br>
  		</P>"
		Send-Mailmessage -smtpServer $smtpServer -from $from -to $emailaddress -subject $subject -body $body -bodyasHTML -priority High
	}
  else	{
	if ($daystoexpire -lt $expireindays)
  		{
		$numberusers = $numberusers + 1
		$adminlist="$adminlist<br>$fullname - $daystoExpire days<br>"
 		$subject="Your password will expire in $daystoExpire days"
  		$body ="
  		Dear $name,
  		<p> Your Password will expire in $daystoexpire days.<br>
  		Prior to the expiration date please log onto the GreatPoint Partners network and press CTRL ALT Delete and choose Change Password.  It is recommended you do this on your laptop.<br>
		<p>Please call or email RFA should you have any questions - help@rfa.com or call 212.867.4600 .<br><br>
  		<p>Thank you. <br> 
  		</P>"

		Send-Mailmessage -smtpServer $smtpServer -from $from -to $emailaddress -subject $subject -body $body -bodyasHTML -priority High

		}
	}
}

#Email AdminList
$subject="Password Notifications: User passwords who have or are about to expire"
$body ="
Dear Administrators,
<p>Below is a list of users and their password status that are about to expire.<br>
<p>$adminlist<br><br>
<p>Thank you.
</p>"

#$toadmin = "czale@rfa.com"
if ($numberusers -gt 0)
{

Send-Mailmessage -smtpServer $smtpServer -from $from -to $toadmin -subject $subject -body $body -bodyasHTML -priority High

}

