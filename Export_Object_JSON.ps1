#Name           :  Export JSON
#Description    :  Export informations VMs in JSON
#Version        :  1.0
#Author         :  Bastien RIOS & Nicolas 

#Créer un objet pour l’export
#L’objet doit contenir les objets suivants « vm0X » et « cluster »
#Si le nom de la vm = « vm-0X où X est un nombre paire » bypass l’ajout dans l’objet
#Pousser les infos suivantes dans les bons objets
#Cluster = Name, DrsMode
#vm0X = Name, Cpu, Ram, Disksize, CpuSharesLevel, UsedSpaceGB, ProvisionedSpaceGB, SwapFile
#Pour ProvisionedSpaceGB et UsedSpace, selectionnez uniquement 2 chiffres après la virgule
#Exporter l’objet dans un fichier JSON (non CSV)

function menuE
{
    do
    {
        clear-host chcp 1252
        Write-Host "#################################" -ForegroundColor Blue
        Write-Host "##         EXPORT JSON MODE    ##" -ForegroundColor Blue
        Write-Host "#################################" -ForegroundColor Blue `n

        Write-Host "1. Export VM on JSON "`n -ForegroundColor Yellow
        Write-Host "2. RETOUR MENU PRINCIPAL" `n -ForegroundColor Red
        $menuresponse = read-host [Enter Selection]
        Switch ($menuresponse) {
            "1" {OptionE.1}    
            "2" {Menu}
        }
    } until (1..3 -contains $menuresponse) 
}

#$JsonClusterObject = Get-Cluster | select -Property Name,DrsEnabled
#$JsonVMObject = Get-VM | select -Property Name,NumCpu,MemoryMB | Get-VM | Get-HardDisk | select -Property CapacityGB

#ConvertTo-Json $JsonClusterObject,$JsonVMObject | Out-File .\objects.json


#Get-VM -PipelineVariable vm|
#Select-Object @{N='VM';E={$vm.Name}},
#    @{N='NumCPU';E={$vm.NumCPU}},
#    @{N='MemoryMB';E={$vm.MemoryMB}}


#
#$Output = New-Object -TypeName PSObject -Property @{
#    'CapacityGB' = $InfosDiskVM.CapacityGB
#}


#    'VM Name' = $InfosVM.Name
#    'NumCpu'= $InfosVM.NumCPU
#    'MemoryMB' = $InfosVM.MemoryMB


#$Results = @{}
#$Results.VMname = $InfosVM.Name
#$Results.NumCPU = $InfosVM.NumCpu
#$Results.MemoryMB = $InfosVM.MemoryMB
#$Results.CapacityGB = $InfosDiskVM.CapacityGB
#[PsCustomObject]$Results | Format-Table -Autosize

## Advanced Example - HashTable ##

function OptionE.1
{

    $InfosVM = Get-VM | Select-Object -Property Name,NumCpu,MemoryMB,UsedSpaceGB,ProvisionedSpaceGB,VMSwapfilePolicy
    $Results = @()
    $InfosVM = Get-VM
    ForEach($Info in $InfosVM)
    {
        $Results += [PSCustomObject] @{
        VMname = $Info.Name
        NumCpu = $Info.NumCpu
        MemoryMB = $Info.MemoryMB
        UsedSpaceGB = [math]::Round($Info.UsedSpaceGB,2)
        ProvisionedSpaceGB = [math]::Round($Info.ProvisionedSpaceGB,2)
        VMSwapfilePolicy = $info.VMSwapfilePolicy
        CapacityGB = $Info | Get-HardDisk | Select-Object -ExpandProperty CapacityGB
        CpuSharesLevel = $Info | Get-VMResourceConfiguration | Select-Object -ExpandProperty CpuSharesLevel
    }
    }
    $Results | Format-Table -auto
    ConvertTo-Json $Results | Out-File  .\Export.json
    Read-Host = "[ENTER]"
    Menu
}