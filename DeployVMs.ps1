#Name               :  Creation of virtual machines
#Description        :  Automatic creation of a virtual machine via the import of a csv file
#Version            :  1.0
#Author             :  Saba BEROL
#Last modification  :  02/06/2019

    #-------------------------------------------------------------------------#
    #                    DEPLOY MENU                                          #
    #-------------------------------------------------------------------------#
function menu1 
{
    do
    {
        clear-host chcp 1252
        Write-Host "#################################" -ForegroundColor Green
        Write-Host "##       DEPLOYMENT MODE       ##" -ForegroundColor Green
        Write-Host "#################################" -ForegroundColor Green `n

        Write-Host "1. Start VMs deployment from the CSV file`n"
        Write-Host "2. Info CSV File"`n
        Write-Host "3. Return to Main Menu"
        $menuresponse = read-host [Enter Selection]
        Switch ($menuresponse) {
            "1" {Option1.1}
            "2" {Option1.2}
            "3" {Menu}
        }
    }
    until (1..3 -contains $menuresponse) 
}

    #-------------------------------------------------------------------------#
    #                    DEPLOY FUNCTION                                      #
    #-------------------------------------------------------------------------#
function Option1.1
{
    set-location $pathDev # We place ourselves in the folder containing the script.
    $vms = Import-Csv ".\VMs.csv" -Delimiter ";" #Import Csv file
    $dateVM = get-date -f "yyyy-MM-dd-H:m:s:ffffff" #Get the date to record it in the vm description, to date the logs etc
    $mess = ".\TmpMess.txt"

    ForEach ($vm in $vms)
    {
        $VMName = $vm.Name
        $VMHost = Get-VMHost -Name $vm.Host
        $Datastore = Get-Datastore -Name $vm.Datastore
        $Disk = $vm.Disk
        $GuestID = $vm.GuestID #[VMware.Vim.VirtualMachineGuestOsIdentifier].GetEnumValues() ->  guestID list
        
        Write-host ""
        Write-host "I will create the following vm :"
        Write-Host "Name : $VMName"
        Write-Host "GuestID : $GuestID"
        Write-Host "Host : $VMHost"
        Write-Host "Datastore : $Datastore"
        Write-Host "Disk storage format : Eager Zero Thick"
        Write-Host "Disk : $Disk'"
        Write-Host "Number of cpu : 2"
        Write-Host "Memory : 1572 MB"
        Write-Host "CD : Yes, has a CD player "
        Write-Host "Floppy : Yes, has a floppy disk drive"
        Write-Host "Note : 'it contains the name and creation date' "`n

        $creatmvs = Read-Host "Do you want to create this vm ? yes or no"`n


            if($creatmvs -like "yes" )
            {   
                if ((Get-VM $VMName -ErrorAction SilentlyContinue).Name -eq $VMName) {  
                    Write-Host "the $VMName already exist" -ForegroundColor Red
                    Write-Log "TRY TO CREATE $VMname BUT ALREADY EXIST" -Criticite "INFO"
                    $Status = "ALREADY EXIST"
                    Add-Content -Path ($pathDev + ".\report.csv") -Value "$VMName,$VMHost,$Disk,$Status"
                    $mailboxdata = "$VMName KO, already exist"
                    $mailboxdata | Out-File $mess
                    SendMail
                }

                else {
                    New-VM -Name $VMName -GuestId $GuestID -VMHost $VMHost -Datastore $Datastore -DiskStorageFormat EagerZeroedThick -NumCPU 2 -MemoryMB 1572 -Notes "$VMName created on $dateVM" -CD -Floppy -DiskGB $Disk
                    #Start-Sleep -s 10
                    if ($? -eq "True"){
                        WriteColor "$VMName OK" -color "Green"
                        Write-Log "$VMName OK" -Criticite "INFO"
                        $mailboxdata = "$VMName OK, Successfully completed deployment"
                        $mailboxdata | Out-File $mess
                        SendMail
                        $Status = "VM OK"
                        Add-Content -Path ($pathDev + ".\report.csv") -Value "$VMName,$VMHost,$Disk,$Status"
                    }
                    else {
                        WriteColor "Error with $VMName" -color "Red"
                        Write-Log -Message "Error with $VMName" -Criticite "HIGH"
                        $mailboxdata = "$VMName KO, Error during deployment"
                        $mailboxdata | Out-File $mess
                        SendMail
                        $Status = "VM KO"
                        Add-Content -Path ($pathDev + ".\report.csv") -Value "$VMName,$VMHost,$Disk,$Status"
                    }
                }
                
            }
            else{
                WriteColor "No creation $VMName" -color "Red"
                Write-Log -Message "No creation $VMName" -Criticite "INFO"
                $mailboxdata = "$VMName The VM was not created by user request"
                $mailboxdata | Out-File $mess
                SendMail
                $Status = "VM No create by user request"
                Add-Content -Path ($pathDev + ".\report.csv") -Value "$VMName,$VMHost,$Disk,$Status"
            }
        }
        menu1 
    }
    

function Option1.2 {

    Import-Csv -Delimiter ";" -Path .\VMs.csv
    Read-Host = "[ENTER]"
    menu1
}

