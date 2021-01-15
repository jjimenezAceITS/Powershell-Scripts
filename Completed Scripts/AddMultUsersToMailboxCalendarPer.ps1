########################################################
# Version 1.0 January 2021                             #
# Jairo Jimenez Arenas                                 #
#                                                      #
#Adding users to mailbox\Calendar                      #
########################################################

#Adding all users to a calendar\mailbox

#Get-Mailbox | ForEach {Add-MailboxFolderPermission -Identity research@kettlehill.com:\Calendar -User $_.Alias -AccessRights Editor}

#Adding specific users to a mailbox\calendar
$users = Get-Content "Path of txt file"
ForEach($user in $users) {Add-MailboxFolderPermission -Identity research@kettlehill.com:\Calendar -User $user -AccessRights Editor}
