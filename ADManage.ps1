#Name           :  AD Management
#Description    :  Manage the AD service
#Version        :  1.0
#Author         :  Saba BEROL

#	Créer un Utilisateur dans l’AD « toto-0X »
#	Si l’Utilisateur existe, le supprimer et recréer un nouveau en incrémentant 0X par 1
#	Passez le Password en SecureString (Utiliser fonction GeneratePassword)
#	Créer Groupe AD “Admin-$user” (ou $user = nom de l’utilisateur) 

Import-Module ActiveDirectory
function menuAD
{
    do
    {
        clear-host chcp 1252
        Write-Host "#################################" -ForegroundColor Yellow
        Write-Host "##         AD MODE             ##" -ForegroundColor Yellow
        Write-Host "#################################" -ForegroundColor Yellow `n

        Write-Host "1. CREATE USER "`n -ForegroundColor Yellow
        Write-Host "2. RETOUR MENU PRINCIPAL" `n -ForegroundColor Yellow
        $menuresponse = read-host [Enter Selection]
        Switch ($menuresponse) {
            "1" {OptionAD.1}    
            "2" {Menu}
        }
    }
    until (1..3 -contains $menuresponse) 
}


function OptionAD.1 
{
# DECLARATION PART
# ----------------

$path = "OU=Technique,OU=Utilisateurs,OU=Paris,OU=Entreprise,DC=esgi,DC=priv"
$username = "toto"
$myuser = "$username*"
$userlist = Get-ADUser -Filter * | Select-Object Name
$usercheck = Get-ADUser -Filter {Name -like $myuser}


# INSTRUCTION PART
# ----------------
	
	if ($userlist.Name -eq $usercheck.Name)
	{
		$user = $usercheck.Name
        Remove-ADUser $user -Confirm:$false
		Remove-ADGroup "Admin-$user" -Confirm:$false
        
        $countuser = $user -replace "[^0-9]"
        [int]$countuser += 1
        
	    if ($countuser -le 9)
	    {
            $newuser = $username + "-0" + $countuser
            New-AdUser -Name $newuser -Path $path -ChangePasswordAtLogon $true `
            -AccountPassword (Read-Host -AsSecureString "Input Password") -Enabled $True
		    
            New-ADGroup -Name "Admin-$newuser" -groupscope "Global"
	    }
	    else
	    {

            $newuser = $username + "-" + $countuser
            New-AdUser -Name $newuser -Path $path -ChangePasswordAtLogon $true `
            -AccountPassword (Read-Host -AsSecureString "Input Password") -Enabled $True
		    
            New-ADGroup -Name "Admin-$newuser" -groupscope "Global"
	    }
    }
    else
	{
        New-AdUser -Name "toto-00" -Path $path -ChangePasswordAtLogon $true `
        -AccountPassword (Read-Host -AsSecureString "Input Password") -Enabled $True
        
        New-ADGroup -Name "Admin-toto-00" -groupscope "Global"
	}
    menu4
}




