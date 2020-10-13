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