########################################################
# Version 1.0 January 2021                             #
# Jairo Jimenez Arenas                                 #
#                                                      #
#Getting and setting Max send and receive of mailboxes #
########################################################

Get-Mailbox | Format-List MaxReceiveSize,MaxSendSize,RecipientLimits
Get-Mailbox | Set-Mailbox $_.Name -MaxSendSize 25mb -MaxReceiveSize 35mb

# If you are connecting to an Exchange server, then you do not need to modify anything as Outlook automatically retrieves the limit from the Exchange server.
# To configure the limit, add or modify the following value in the Registry:
# Key: HKEY_CURRENT_USER\Software\Microsoft\Office\<version>\Outlook\Preferences
# Value name: MaximumAttachmentSize
# Value type: REG_DWORD
# The value that you need to use is in KB. So if you know the amount of MB supported by your ISP, then you need to multiply that by 1024 to get the value that you need to enter. To allow for an unlimited size, you can set the value to 0.
# Examples;
# 2MB-> 2048
# 5MB-> 5120
# 10MB-> 10240
# 50MB-> 51200
