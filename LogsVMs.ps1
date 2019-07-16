#Name           	:  LOGs
#Description    	:  Log of creation of mv and sending of mail
#Version        	:  1.0
#Author         	:  Saba BEROL
#Last modification  :  02/06/2019


$LogFile = ".\logs_script_vms_create.txt"

#Instruction
#-------------
Function Write-Log([String]$Message,[String]$Criticite){
	$DDate=Get-date -UFormat %Y%m%d-%H%M%S
	$CUser=$env:Username
	Add-Content -path $LogFile -value "$DDate-$Criticite-$CUser-$Message"
}

Function WriteColor([string]$message,[string]$color){
	Write-Host "$message" -ForegroundColor:$color
	}
