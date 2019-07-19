#Name           :  Creat VM
#Description    :  Creation of vm with powershell
#Version        :  1.0
#Author         :  Bastien RIOS & Nicolas 

#Le script doit demander le nombre de VMs à créer
#Le nom des vms doit être le suivant = « vm-$ClusterName-increment » 
#(ex : vm-mycluster-01,vm-mycluster02,vm-mycluster03, etc ..)
#Le CPU doit être fixe 1
#La RAM doit être fixe 256MB
#Le datastore doit être fixe (datastore de l’esx)
#Le portgroup doit être demander (portgroups présent dans le CSV)
#Avoir une fonction ici serait intéressant
function menuCV
{
    do
    {
        clear-host chcp 1252
        Write-Host "#################################" -ForegroundColor Blue
        Write-Host "##         VM CREATION MODE    ##" -ForegroundColor Blue
        Write-Host "#################################" -ForegroundColor Blue `n

        Write-Host "1. CREATE VM "`n -ForegroundColor Yellow
        Write-Host "2. RETOUR MENU PRINCIPAL" `n -ForegroundColor Red
        $menuresponse = read-host [Enter Selection]
        Switch ($menuresponse) {
            "1" {OptionCV.1}    
            "2" {Menu}
        }
    } until (1..3 -contains $menuresponse) 
}
function OptionCV.1 
{
    $VMCount = Read-Host -Prompt "How many VM do you want create ?"
    $VirtualPG = Get-VirtualPortGroup
    Write-Output $VirtualPG
    $PGchoice = Read-Host -Prompt "Wich portgroup do you want (name)?"
    $ClusterName = $JsonObject.vCenter.Cluster

    0..$VMCount | ForEach-Object { 
        $VMrename = "vm-$ClusterName-{0}" -f $_
        if ((Get-VM -name $VMrename -ErrorAction SilentlyContinue) -eq $null){
        }
        New-VM -Name $VMrename `
            -NumCpu 1 `
            -DiskGB 5 `
            -MemoryMB 256 `
            -Datastore $JsonObject.ESXi.Datastore1 `
            -VMHost $JsonObject.ESXi.Name `
            -NetworkName $PGchoice
            Write-Host "$VMrename will be created" -ForegroundColor Green
    }
    Read-Host = "[ENTER]"
    Menu
}
