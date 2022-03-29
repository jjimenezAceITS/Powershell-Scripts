$rooms | % {
$a = $_;
   $users | % {
   $b = $_;
   Write-Host Adding $b to $a
   Add-MailboxFolderPermission -Identity $a":\Calendar" -User $b -AccessRights AvailabilityOnly
   };
};

#$rooms = get-content (exported list of rooms mailbox aliases)
#$users = get-content (Exported list of users mailboxes alises)
