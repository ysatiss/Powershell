#Name               :  ESXI Inventory
#Description        :  Make the inventory of esxi servers
#Version            :  1.0
#Author             :  Saba BEROL
#Last modification  :  18/04/2019


function menu3
{
    do
    {
        clear-host chcp 1252
        Write-Host "#################################" -ForegroundColor DarkCyan
        Write-Host "##         INVENTORY MODE      ##" -ForegroundColor DarkCyan
        Write-Host "#################################" -ForegroundColor DarkCyan `n

        Write-Host "1. INVENTORY DATASTORE "`n -ForegroundColor Yellow
        Write-Host "2. INVENTORY ESXI"`n -ForegroundColor Yellow
        Write-Host "3. INVENTORY NETWORK" `n -ForegroundColor Yellow
        Write-Host "4. INVENTORY VM" `n -ForegroundColor Yellow
        Write-Host "5. BACK TO THE MAIN MENU" `n -ForegroundColor Cyan
        $menuresponse = read-host [Enter Selection]
        Switch ($menuresponse) {
            "1" {Option3.1}
            "2" {Option3.2}
            "3" {Option3.3}
            "4" {Option3.4}
            "5" {Menu}
        }
    }
    until (1..3 -contains $menuresponse) 
}

function Option3.1
{
        #INVENTORY DATASTORE
        #Get-Datastore | Select-Object Name, FreeSpaceGB, CapacityGB | ConvertTo-Html | Set-Content  .\Datastore_infos.htm
        #$msg.Body = Get-Content .\Datastore_infos.htm
        Get-Datastore | Select-Object Name, FreeSpaceGB, CapacityGB 
        Read-Host = "[ENTER]"
        menu3
}

function Option3.2
{
        #INVENTORY ESXI
        Get-VMHost | Select-Object Name, Version, Manufacturer, NumCpu, ProcessorType
        Read-Host = "[ENTER]"          
        menu3
}
function Option3.3
{
        #INVENTORY NETWORK
        Get-VMHostNetworkAdapter 
        Read-Host = "[ENTER]"
        menu3
}

function Option3.4
{
        #INVENTORY VM
        do
        {
        clear-host chcp 1252
        Write-Host "#################################" -ForegroundColor DarkCyan
        Write-Host "##    INVENTORY MODE / VM      ##" -ForegroundColor DarkCyan
        Write-Host "#################################" -ForegroundColor DarkCyan `n

        Write-Host "1. INVENTORY VM "`n -ForegroundColor Yellow
        Write-Host "2. DELETING VM"`n -ForegroundColor Yellow
        Write-Host "3. BACK TO THE MAIN MENU" `n -ForegroundColor DarkCyan
        $menuresponse = read-host [Enter Selection]
        Switch ($menuresponse) 
                {
                "1" {Sub3.1}
                "2" {Sub3.2}
                "3" {menu3}
                }
        }
        until (1..3 -contains $menuresponse) 
}
function Sub3.1{
        Get-vm | Format-Table Name,VMHost,ResourcePool,NumCpu,MemoryMB,Notes
        Read-Host = "[ENTER]"
        Option3.4
}
function Sub3.2 {
        $VMListe = Get-VM | Select-Object Name
        Write-Host $VMListe
        $VMDelete = Read-Host "Which VM do you want to delete ? "`n
        Remove-VM $VMDelete -DeletePermanently -Confirm
        Option3.4
}


