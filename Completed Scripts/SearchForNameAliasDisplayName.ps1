##########################################################################
#                                                                        #
# Version 1.0 January 2021                                               #
# Jairo Jimenez Arenas                                                   #
#                                                                        #
# Script to search all mailboxes and return DisplayName, Name and Alias  #                                                 
##########################################################################



$target = "Name"
Get-Mailbox -Filter * | Where {$_.DisplayName -like $target -or $_.Name -like $target -or $_.Alias -like $target} |
  Select Name, DisplayName, Alias
