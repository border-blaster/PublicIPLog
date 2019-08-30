<####
Get and record the systems public ip address
https://github.com/border-blaster/PublicIPLog
v. 2019-08-30
####>


## Build out where to log the data

$KeyLocation = "HKLM:\SOFTWARE"
$BBName = "Boarder-Blaster"
$PubLogName = "PublicIPLog"
$FullPubLogName = ($KeyLocation + "\" + $BBName + "\" + $PubLogName)

# If needed, create Boarder-Blaster
if (!(Get-Item -Path ($KeyLocation + "\" + $BBName))) {
    New-Item -Path $KeyLocation -Name $BBName 
    }

# Fill in the current read me info
New-ItemProperty -Path ($KeyLocation + "\" + $BBName) -Name "ReadMe" -Value ”https://github.com/border-blaster/” -PropertyType "String" -Force


# If needed create PublicIPLog
If (!(Get-Item -Path ($KeyLocation + "\" + $BBName + "\" + $PubLogName))) {
    New-Item -Path ($KeyLocation + "\" + $BBName) -Name $PubLogName
    }


## Get date and ip address

Function PublicIPLog {
$currenttime = get-date -Format o
$publicip = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content

New-ItemProperty -Path $FullPubLogName -Name $currenttime -Value $publicip -PropertyType "String"

}


PublicIPLog
