
$AccountLockOutEvent = Get-EventLog -LogName "Security" -InstanceID 4740 -Newest 1
$LockedAccount = $($AccountLockOutEvent.ReplacementStrings[0])
$AccountLockOutEventTime = $AccountLockOutEvent.TimeGenerated
$AccountLockOutEventMessage = $AccountLockOutEvent.Message
$messageParameters = @{ 
Subject = "GPP-GPPArchive01-Account Locked Out: $LockedAccount" 
Body = "Account $LockedAccount was locked out on $AccountLockOutEventTime.`n`nEvent Details:`n`n$AccountLockOutEventMessage"
From = "GPP Alerts <alerts@gppfunds.com>" 
To = "jjimenez@rfa.com" 
SmtpServer = "gppfunds-com.mail.protection.outlook.com" 
} 
Send-MailMessage @messageParameters