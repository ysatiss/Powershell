#Name               :  SSH Management
#Description        :  Management of the ssh service on ESXI server
#Version            :  1.0
#Author             :  Saba BEROL
#Last modification  : 16/04/2019


    #-------------------------------------------------------------------------#
    #                    MANAGEMENT MENU                                      #
    #-------------------------------------------------------------------------#
function menu2
{
    do
    {
        clear-host chcp 1252
        Write-Host "#################################" -ForegroundColor Blue
        Write-Host "##          SSH MODE           ##" -ForegroundColor Blue
        Write-Host "#################################" -ForegroundColor Blue `n
         
        Write-Host "1. STATUS SERVICE SSH SUR LES ESXIs "`n -ForegroundColor Yellow
        Write-Host "2. ACTIVER LE SERVICE SSH SUR LES ESXIs"`n -ForegroundColor Yellow
        Write-Host "3. DESACTIVER LE SERVICE SSH SUR LES ESXIs" `n -ForegroundColor Yellow
        Write-Host "4. RETOUR MENU PRINCIPAL" `n -ForegroundColor Red
        $menuresponse = read-host [Enter Selection]
        Switch ($menuresponse) {
            "1" {Option2.1}
            
            "2" {Option2.2}

            "3" {Option2.3}

            "4" {Menu}
        }
    }
    until (1..3 -contains $menuresponse) 
}

function Option2.1
{
        # 1 - STATUS OF SERVICE SSH
        Write-Host " "
        Get-VMHost | Get-VMHostService | Where-Object { $_.Key -eq "TSM-SSH" } |Select-Object VMHost, Label, Running
        Read-Host = "[ENTER]"
    menu2
}

function Option2.2
{
    # 2 - START SSH SERVICE ON ALL ESXIs
    Get-VMHost | ForEach-Object {Start-VMHostService -HostService ($_ | Get-VMHostService | Where-Object { $_.Key -eq "TSM-SSH"} )}
    menu2
}

function Option2.3
{
    # 3 - STOP SSH SERVICE ON ALL ESXIs
    Get-VMHost | ForEach-Object {Stop-VMHostService -HostService ($_ | Get-VMHostService | Where-Object { $_.Key -eq "TSM-SSH"} )-Confirm:$false} 
    menu2
}
