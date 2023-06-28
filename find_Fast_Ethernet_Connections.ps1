$Ter = Get-ADComputer -Filter * -SearchBase "OU=Something" | Select Name
foreach ($T in $Ter) {
    $T = $T.Name
    $HostUp = Test-Connection -ComputerName $T -BufferSize 12 -Count 1 -Quiet
        If (!($HostUp)){
		    Write-Host "$T ist nicht erreichbar"	-ForegroundColor Red
        } else {
            $net= get-wmiobject win32_networkadapter -filter "netconnectionstatus = 2" -ComputerName $T | select Name,speed 
            $speed = $net.speed / 1000000
            $name = $net.Name
            if ($speed -lt 1000){
                write-host $T $name $speed
            }
        }
}
