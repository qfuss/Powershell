$ids= Get-RDUserSession -ConnectionBroker "FQDN" | where-Object {$_.UserName -notlike "administrator" } | select-object UnifiedSessionID 

foreach ($id in $ids){
    Logoff $id.UnifiedSessionId /server:Hostname
} 
