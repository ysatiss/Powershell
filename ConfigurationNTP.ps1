#Name           :  Creation of virtual machines
#Description    :  Manage the NTP service
#Version        :  1.0
#Author         :  Saba BEROL

function menu4
{
    do
    {
        clear-host chcp 1252
        Write-Host "#################################" -ForegroundColor DarkGray
        Write-Host "##         INVENTORY MODE      ##" -ForegroundColor DarkGray
        Write-Host "#################################" -ForegroundColor DarkGray `n

        Write-Host "1. STATUS SERVICE NTP "`n -ForegroundColor Yellow
        Write-Host "2. MISE EN PLACE SERVICE NTP"`n -ForegroundColor Yellow
        Write-Host "3. SUPPRESSION SERVICE NTP" `n -ForegroundColor Yellow
        Write-Host "4. RETOUR MENU PRINCIPAL" `n -ForegroundColor Yellow
        $menuresponse = read-host [Enter Selection]
        Switch ($menuresponse) {
            "1" {Option4.1}
            
            "2" {Option4.2}

            "3" {Option4.3}

            "4" {Menu}
        }
    }
    until (1..3 -contains $menuresponse) 
}



function Option4.1
{
        #STATUS NTP
        Get-VMHost | Sort-Object Name | Select-Object Name, @{N="NTPServer";E={$_ |Get-VMHostNtpServer}}, @{N="ServiceRunning";E={(Get-VmHostService -VMHost $_ | Where-Object {$_.key-eq "ntpd"}).Running}}
    menu4
}

function Option4.2
{
       # AJOUTER NTP
       Get-VMHost | Add-VMHostNtpServer -NtpServer NTP.MIDWAY.OVH

    menu4
}

function Option4.3
{
      #SUPPRESSION NTP
      Remove-VmHostNtpServer -NtpServer "NTP.MIDWAY.OVH" -VMHost (Get-VMHost) -Confirm
    menu4
}