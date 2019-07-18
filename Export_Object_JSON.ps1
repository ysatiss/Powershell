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

function menuE
{

    $InfosVM = Get-VM | Select-Object -Property Name,NumCpu,MemoryMB
    $Results = @()
    $InfosVM = Get-VM
    ForEach($Info in $InfosVM)
    {
        $Results += [PSCustomObject] @{
        VMname = $Info.Name
        NumCpu = $Info.NumCpu
        MemoryMB = $Info.MemoryMB
        CapacityGB = $Info | Get-HardDisk | Select-Object -ExpandProperty CapacityGB
        UsedSpaceGB = [math]::Round($Info.UsedSpaceGB,2)
    }
    }
    $Results | Format-Table -auto
    ConvertTo-Json $Results | Out-File  .\ExportObject.jso
    Menu
}