$vorname = "Vorname"
$nachname = "Nachname"
$ort = "Ort"
$phone = "123"
$abteilung = "Abteilung"
$funktion = "Funktion"
$changepw = $false

# Passwort bauen
function Get-RandomCharacters($length, $characters) {
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
    $private:ofs=""
    return [String]$characters[$random]
}
 
function Scramble-String([string]$inputString){     
    $characterArray = $inputString.ToCharArray()   
    $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length     
    $outputString = -join $scrambledStringArray
    return $outputString 
}
 
$password = Get-RandomCharacters -length 5 -characters 'abcdefghiklmnoprstuvwxyz'
$password += Get-RandomCharacters -length 3 -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
$password += Get-RandomCharacters -length 3 -characters '1234567890'
$password += Get-RandomCharacters -length 3 -characters '!"§$%&/()=?}][{@#*+'
  
$password = Scramble-String $password

# Account für PS
$user = Get-Content C:\O365\usr.txt
$File = "C:\O365\pw.txt"
$MyCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, (Get-Content $File | ConvertTo-SecureString)

# Mail bauen
$mail1 = ($vorname.tolower())
$mail = $mail1[0]+"."+$nachname.tolower()+"@foo.bar"

# Telefon
$phone1 = "Telefon"+$phone

# Logging
try {
    Start-Transcript -Path "C:\O365\$mail.txt"
    }
catch {
    Write-Host "Fehler: Logfile. Script wird beendet"
    pause
    Exit
    }
        

# Module verbinden
Connect-ExchangeOnline -Credential $MyCredential
Connect-MsolService -Credential $MyCredential
Connect-AzureAD -Credential $MyCredential

# Prüfen ob überhaupt eine Lizenz frei ist
$lic= Get-MsolAccountSku | where AccountSkuId -eq "reseller-account:O365_BUSINESS_PREMIUM"
$lic_menge= ($lic.ActiveUnits - $lic.ConsumedUnits)
if ($lic.ActiveUnits -le $lic.ConsumedUnits ){
    write-host "Fehler, keine Lizenzen mehr frei" -ForegroundColor Red
    exit
    }
    else{
    write-host "freie Lizenzen: $lic_menge" -ForegroundColor Green
    }


# User anlegen und Lizenz zuweisen
New-MsolUser -DisplayName $nachname -FirstName $vorname -LastName $nachname -UserPrincipalName $mail -City $ort -PhoneNumber $phone1 -Password $password -ForceChangePassword $changepw -Department $abteilung -Title $funktion -UsageLocation DE -LicenseAssignment reseller-account:O365_BUSINESS_PREMIUM

# 2 Minuten warten, bis die lahmen MS Server das PF fertig haben
start-sleep 120

# Objet ID für Mail holen
$ID=Get-MsolUser -SearchString "$nachname"
$OID= $ID.ObjectId


# Foto hinzufügen     
Set-UserPhoto -Identity "$mail" -PictureData ([System.IO.File]::ReadAllBytes("C:\O365\Logo.jpg"))-Confirm:$false

# Beenden der Sitzung
[Microsoft.Online.Administration.Automation.ConnectMsolService]::ClearUserSessionState()
Disconnect-ExchangeOnline -Confirm:$false
Disconnect-MsolService -Confirm:$false
Disconnect-AzureAD -Confirm:$false
