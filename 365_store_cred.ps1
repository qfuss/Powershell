Set-ExecutionPolicy unrestricted
$credential = Get-Credential
$credential.Password | ConvertFrom-SecureString | Out-File C:\O365\pw.txt
$credential.UserName | Out-File C:\O365\usr.txt
