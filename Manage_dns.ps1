#Name           :  DNS Management
#Description    :  DNS Management
#Version        :  1.0
#Author         :  Bastien RIOS & Nicolas 


#Créer Record DNS en se basant sur l’adresse IP de l’ESXi (que vous aurez renseigner)
#Si le record DNS est existant, le supprimer et le recréer
#Créer un Computer AD en se basant sur le nom de l’ESXi
#Si le computer AD existe le supprimer et le recréer


function menuDNS
{
    do
    {
        clear-host chcp 1252
        Write-Host "#################################" -ForegroundColor DarkCyan
        Write-Host "##         VCenter MODE        ##" -ForegroundColor DarkCyan
        Write-Host "#################################" -ForegroundColor DarkCyan `n

        Write-Host "1. CREATE NEW INFRA via JSON "`n -ForegroundColor Yellow
        Write-Host "2. RETOUR MENU PRINCIPAL" `n -ForegroundColor Red
        $menuresponse = read-host [Enter Selection]
        Switch ($menuresponse) {
            "1" {OptionDNS.1}    
            "2" {Menu}
        }
    } until (1..3 -contains $menuresponse) 
}
function OptionDNS.1
{
    $JsonObject = Get-Content .\variables.json | ConvertFrom-Json

    # MANAGE DNS RECORD TYPE A FOR ESXI
    $checkdnshostname = Get-DnsServerResourceRecord -ZoneName $JsonObject.DNSRecord.Zone # Check if Record DNS of esxi already contains in DNS on Server))
    if ( $checkdnshostname.hostname -contains $JsonObject.DNSRecord.Name ) {
        Write-Host "Record DNS $JsonObject.DNSRecord.Name already exist"
        Write-Host "The DNS entry will be deleted and then recreated"
        Start-Sleep -s 3
        Remove-DnsServerResourceRecord -ZoneName $JsonObject.DNSRecord.Zone -Name $JsonObject.DNSRecord.Name -RRType $JsonObject.DNSRecord.RRType -Force # Remove DNS record
        Add-DnsServerResourceRecordA -Name $JsonObject.DNSRecord.Name -ZoneName $JsonObject.DNSRecord.Zone -AllowUpdateAny -IPv4Address $JsonObject.DNSRecord.IPv4Address -TimeToLive 01:00:00 # Create DNS record

    #If DNS record is not contains in DNS on Server it will be created
    }else {
            Write-Host "Record DNS esxi01 will be created"
            Start-Sleep -s 2
            Add-DnsServerResourceRecordA -Name $JsonObject.DNSRecord.Name -ZoneName $JsonObject.DNSRecord.Zone -AllowUpdateAny -IPv4Address $JsonObject.DNSRecord.IPv4Address -TimeToLive 01:00:00 # Create DNS record
    }


    # MANAGE COMPUTER AD NAME ESXI
    $checkcomputerad = Get-ADComputer -Filter * # Fetch all ComputerAD on AD
    if ( $checkcomputerad.name -contains $JsonObject.ComputerAD.Name ) { # Check if name of esxi already contains in ComputerAD))
        Write-Host "ComputerAD esxi01 already exist"
        Write-Host "ComputerAD esxi01 will be deleted and then recreated"
        Start-Sleep -s 3
        Remove-ADComputer -Identity $JsonObject.ComputerAD.Name -Confirm:$false # Remove esxi01 ComputerAD
        New-ADComputer -Name $JsonObject.ComputerAD.Name -SamAccountName $JsonObject.ComputerAD.SamAccountName -Path $JsonObject.ComputerAD.Path # Create esxi01 ComputerAD

    #If name of esxi is not contains in ComputerAD it will be created
    }else {
            Write-Host "ComputerAD esxi01 will be created"
            Start-Sleep -s 2
            New-ADComputer -Name $JsonObject.ComputerAD.Name -SamAccountName $JsonObject.ComputerAD.SamAccountName -Path $JsonObject.ComputerAD.Path # Create esxi01 ComputerAD
    }
    Read-Host = "[ENTER]"
    Menu
}