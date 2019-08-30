<####
Get and record the systems public ip address with error and output supression
https://github.com/border-blaster/PublicIPLog
v. 2019-08-30
####>


## Build out where to log the data

$KeyLocation = "HKLM:\SOFTWARE"
$BBName = "Boarder-Blaster"
$PubLogName = "PublicIPLog"
$FullPubLogName = ($KeyLocation + "\" + $BBName + "\" + $PubLogName)

Function PublicIPLogSetup {
    # If needed, create Boarder-Blaster
    if (!(Get-Item -ErrorAction SilentlyContinue -Path ($KeyLocation + "\" + $BBName ) )) {
        New-Item -Path $KeyLocation -Name $BBName  | Out-Null
        New-ItemProperty -Path ($KeyLocation + "\" + $BBName) -Name "ReadMe" -Value ”https://github.com/border-blaster/” -PropertyType "String" -Force  | Out-Null
        }

    # If needed create PublicIPLog
    If (!(Get-Item  -ErrorAction SilentlyContinue -Path ($KeyLocation + "\" + $BBName + "\" + $PubLogName))) {
        New-Item -Path ($KeyLocation + "\" + $BBName) -Name $PubLogName  | Out-Null
        }
    }

## Get date and ip address

Function PublicIPLog {
$currenttime = get-date -Format o
$publicip = (Invoke-WebRequest -ErrorAction SilentlyContinue -uri "http://ifconfig.me/ip"  -UseBasicParsing).Content

If ((Get-ItemProperty  -ErrorAction SilentlyContinue -Path $FullPubLogName -Name PublicIP).PublicIP -ne $publicip) {
    
    New-ItemProperty -Path $FullPubLogName -Name "PublicIP" -Value $publicip -PropertyType "String" -Force  | Out-Null

    New-ItemProperty -Path $FullPubLogName -Name $currenttime -Value $publicip -PropertyType "String"  | Out-Null
    
    }
 
    New-ItemProperty -Path $FullPubLogName -Name "LastRun" -Value $currenttime -PropertyType "String" -Force | Out-Null

}

## Getting some work done

Do {
    PublicIPLogSetup

    PublicIPLog

    Start-Sleep -Seconds 1800

    } While ($True)
