$complist = (Get-ADComputer -Filter *).Name
foreach($comp in $complist){
    
    $pingtest = Test-Connection -ComputerName $comp -Quiet -Count 1 -ErrorAction SilentlyContinue
    if($pingtest){
         Write-Host($comp + " is online")
     }
     else{
        Write-Host($comp + " is not reachable")
     }
     
}
