$server = "Skynet"

$VM = get-vm -ComputerName $server
foreach ($V in $VM){
    Set-VM -Name $V.Name -Notes $V.VMId -ComputerName $server 
    }
