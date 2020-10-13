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