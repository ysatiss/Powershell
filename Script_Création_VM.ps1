#Name               :  Creation of virtual machines
#Description        :  Script Menu for VM Management
#Version            :  1.0
#Author             :  Saba BEROL
#Last modification  :  05/06/2019

#-------------------------------------------------------------------------#
#       Decrypting the password of the vCenter Administrator account      #
#-------------------------------------------------------------------------#
#$PassKey = [byte]95, 13, 58, 45, 22, 11, 88, 82, 11, 34, 67, 91, 19, 20, 96, 82
#$Password = Get-Content .\pwd.txt | Convertto-SecureString -Key $PassKey
#$User = 'root'
#$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Password


#-------------------------------------------------------------------------#
#                    General variables                                    #
#-------------------------------------------------------------------------#
$pathDev = split-path $myinvocation.mycommand.path #Thanks to this, our new Csv file will have a location relative to the one of the script we are running.
Import-Module .\LogsVMs.ps1 
#$date=get-date -f "dd-MM-yy-H-m-s"
$date=get-date -f "yy-MM-dd-H-m-s"


# Variable for our report
Add-Content -Path .\report.csv  -Value '"VMName","Datastore","HardDrive","Status"'
$vms = @(
    
)
$vms | ForEach-Object { Add-Content -Path  .\report.csv -Value $_ } 


#-------------------------------------------------------------------------#
#                    Connection to the vCenter                            #
#-------------------------------------------------------------------------#
#clear-host : This command allows you to delete everything in the console.
#chcp 1252 : Like the UTF-8, it supports accents and special characters.
clear-host chcp 1252
        set-location $pathDev
        Start-Transcript ($pathDev + ".\Transcription\transcription_script_vms_create_$date.txt") #In addition to the logs there will be a transcription
    Write-Host "Hello, my name is Queen, I'll be your assistant all along." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "First connect to your vcenter"
$ipvcenter = Read-Host "Please enter the ip address of your vcenter " #Ask the user to enter a value, here l'IP
    Write-Host "Ok, please wait" -ForegroundColor Yellow

Import-Module VMware.VimAutomation.Core

#if(Connect-VIServer -Server $ipvcenter -Credential $Credentials -force) 
if(Connect-VIServer -Server $ipvcenter) 
{
    Write-Host "Authentication successful to vCenter $ipvcenter" -ForegroundColor Green
    Write-Log "CONNECT TO ESXI" -Criticite "INFO"
    Start-Sleep -s 2 #Wait a few seconds with the functiun Start-Sleep
    clear-host chcp 1252

    #-------------------------------------------------------------------------#
    #                    Import of moduls                                     #
    #-------------------------------------------------------------------------#
    set-location $pathDev # We place ourselves in the folder containing the script.
    #Import my different scripts
    Import-Module .\DeployVMs.ps1
    Import-Module .\ConfigurationNTP.ps1
    Import-Module .\InventoryESXIs.ps1
    Import-Module .\ManagementSSH.ps1
    Import-Module .\SendMail.ps1
    Import-Module .\ADManage.ps1
    Import-Module .\Create_VM.ps1
    Import-Module .\Export_Object_JSON.ps1
    Import-Module .\Manage_dns.ps1
    Import-Module .\Manage_vCenter.ps1
    #-------------------------------------------------------------------------#
    #                    Main MENU                                            #
    #-------------------------------------------------------------------------#
    function Menu 
    {
        do
        {
        clear-host chcp 1252
        Write-Host "#################################" -ForegroundColor Cyan
        Write-Host "##   ADMINISTRATION vCENTER    ##" -ForegroundColor Cyan
        Write-Host "#################################" -ForegroundColor Cyan `n
        
        Write-Host "What do you want to do?" `n
        Start-Sleep -s 1

            Write-Host "1. Virtual machine deployment by csv file `n" -ForegroundColor Yellow
            Write-Host "2. Management of the ssh service `n" -ForegroundColor Yellow
            Write-Host "3. Inventory of esxi servers `n" -ForegroundColor Yellow
            Write-Host "4. Manage the NTP service`n" -ForegroundColor Yellow
            Write-Host "5. Send the mail to BOSS`n" -ForegroundColor Yellow
            Write-Host "6. AD Management `n" -ForegroundColor Yellow
            Write-Host "7. Create VM `n" -ForegroundColor Yellow
            Write-Host "8. Export-Object JSON `n" -ForegroundColor Yellow
            Write-Host "9. Management DNS `n" -ForegroundColor Yellow
            Write-Host "10. Management Vcenter`n" -ForegroundColor Yellow
            Write-Host "11. Exit (disconnect) `n" -ForegroundColor Red
            $menuresponse = read-host "Enter Selection "
            Switch ($menuresponse) 
            {
                "1" {menu1}
                "2" {menu2}
                "3" {menu3}
                "4" {menu4}
                "5" {SendMailBoss}
                "6" {menuAD}
                "7" {menuCV}
                "8" {menuE}
                "9" {menuDNS}
                "10" {menuV}
                "11" {quit}
            }
        }
        until (1..3 -contains $menuresponse) 
    }

    function quit
    {
        $confirmation = Read-Host "`nAre you Sure You Want To Proceed[y\n]"
        if ($confirmation -eq 'y') {
            Disconnect-VIServer -Server $ipvcenter -Confirm:$false
            Write-Host "See you soon !!!!!" -ForegroundColor Cyan
            Stop-Transcript
            Start-Sleep -s 2
            clear-host chcp 1252
            exit
        }
        else {
            Menu
        }
    }
    Menu

}

else {
    Write-Host "Failed to connect to vCenter $ipvcenter."
    Write-Host "See you soon !!!!!"
    Stop-Transcript  
    }


