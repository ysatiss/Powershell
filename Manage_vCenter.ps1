#Name           :  Vcenter Management
#Description    :  Vcenter Management
#Version        :  1.0
#Author         :  Bastien RIOS & Nicolas 


#Ajouter la permission Admin à l’utilisateur créé (racine vCenter)
#Ajouter l’ESXi au vCenter
#Créer un Cluster
#Activer DRS en mode automatique
#Ajouter l’ESXi au Cluster
#BONUS : Suivre/Attendre la tâche d’ajout de l’ESXi au cluster (pas automatique)
#Créer les Portgoups baser sur le fichier CSV
#Si le portgroup existe, le script doit passer à la suite


function menuDNS 
{
    Connect-VIServer 10.0.0.120 -User "administrator@vcenter.lab" -Password "P@ssw0rd" -Force
    $Datacenter = Get-Datacenter
    $Cluster = Get-Cluster
    $ESXi = Get-VMHost
    $PortgroupCSV = Import-CSV -Delimiter ';' -Encoding UTF7 ".\portgroup.csv"
    $vSwitch = Get-VirtualSwitch
    $VMHosts = Get-VMHost   
    $VirtualPortgroups = Get-VirtualPortGroup

    if ($Datacenter.Name -contains $JsonObject.vCenter.Datacenter) {
        Write-Host "Datacenter "$JsonObject.vCenter.Datacenter" already exist" -ForegroundColor Yellow
    }
    else {
        New-Datacenter -Location $JsonObject.vCenter.Folder -Name $JsonObject.vCenter.Datacenter
        Write-Host "Datacenter "$JsonObject.vCenter.Datacenter" add in progress..." -ForegroundColor Green
    }

    if ($Cluster.Name -contains $JsonObject.vCenter.Cluster) {
        Write-Host "Cluster "$JsonObject.vCenter.Cluster" already exist" -ForegroundColor Yellow
    }
    else {
        New-Cluster -Location $JsonObject.vCenter.Datacenter `
        -Name $JsonObject.vCenter.Cluster `
        -DRSEnabled `
        -DrsAutomationLevel FullyAutomated
        Write-Host "Cluster "$JsonObject.vCenter.Cluster" add in progress..." -ForegroundColor Green
    }

    if ($ESXi.Name -contains $JsonObject.ESXi.Name) {
        Write-Host "ESXi "$JsonObject.ESXi.Name" already exist" -ForegroundColor Yellow
    }
    else {
        $WaitAddHost = Add-VMHost -Name $JsonObject.ESXi.Name -Location $JsonObject.vCenter.Cluster -User "root" -Password "qwertyuiop" -RunAsync
        Wait-Task -Task $WaitAddHost
        Write-Host "ESXi "$JsonObject.ESXi.Name" add in progress... "$JsonObject.vCenter.Name"" -ForegroundColor Yellow
    }

    Foreach ($PG in $PortgroupCSV){
        $NewPortSwitch = $PG.Portgroups
        $VLANID = $PG.ID

        Foreach ($VMHost in $VMHosts)
        {
            if ($VirtualPortgroups.Name -contains $NewPortSwitch) {
                Write-Host "Portgroup $NewPortSwitch already exist" -ForegroundColor Yellow
            }
            else {
                Write-host "Creating $NewPortSwitch on VMhost $VMHost" -ForegroundColor Yellow
                New-VirtualPortGroup -VirtualSwitch $vSwitch.Name -Name $NewPortSwitch -VLanId $VLANID
                Write-Host "Portgroup $NewPortSwitch add in progress..." -ForegroundColor Green 
            }
        }
    } Menu
}