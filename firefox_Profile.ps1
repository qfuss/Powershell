$computer = "Host"

$filesToCopy= "places.sqlite", "key4.db", "logins.json"
cls
Invoke-Command -ComputerName $computer -Script { taskkill /F /IM firefox.exe /T }

$user = Get-WmiObject –ComputerName $computer –Class Win32_ComputerSystem | Select-Object @{N="Username";E={$_.Username.split('\')[1]}}
$usr= $user.Username

$path = "\\$computer\c$\Users\$usr\AppData\Roaming\Mozilla\Firefox\Profiles\"

$n = gci $path | sort LastWriteTime | select -last 1
$a = gci $path | sort LastWriteTime | select -skip 1 -last 1

foreach ($file in $filesToCopy) {
    Copy-Item $path$a\$file -Destination $path$n
}
