#Name           :  SEND MAIL
#Description    :  Script to send an email
#Version        :  1.0
#Author         :  Saba BEROL
#Last modif     : 02/05/2019

    #-------------------------------------------------------------------------#
    #                   Send MAIL to ME                                       #
    #-------------------------------------------------------------------------#
function SendMail {
    
    set-location $pathDev

    #AUTHENTICATION PART
    $email = "other.autre.exo@gmail.com" 
    $pass = "Vmware2019report"
    $smtpServer = "smtp.gmail.com" 

    #NEW OBJECT
    $smtp = new-object Net.Mail.SmtpClient($smtpServer) 
    $msg = new-object Net.Mail.MailMessage 

    #MAIL OPTION
    $smtp.EnableSsl = $true 
    $msg.From = "$email"  
    $msg.To.Add("$email") 
    $msg.BodyEncoding = [system.Text.Encoding]::Unicode 
    $msg.SubjectEncoding = [system.Text.Encoding]::Unicode 
    $msg.IsBodyHTML = $true  
    
    #MAIL CONTENT    
    $msg.Subject = "Report creation VMs"
    $msg.Body = Get-Content .\TmpMess.txt
    
    $smtp.Credentials = New-Object System.Net.NetworkCredential("$email", "$pass"); 
    $smtp.Send($msg)

    #SATUTS OF THE SENDING
    if ($? -eq "True"){
        Write-Log -Message "MAIL SEND" -Criticite "INFO"
        Write-Host "MAIL SEND" -ForegroundColor Green        
    }
    else {
        Write-Log -Message "MAIL FAIL" -Criticite "MEDIUM"
        Write-Host "MAIL FAIL" -ForegroundColor Red  
    }
}

    #-------------------------------------------------------------------------#
    #                    Send MAIL to BOSS                                    #
    #-------------------------------------------------------------------------#
function SendMailBoss {
    
    #set-location $pathDev
    Write-Host "BE CAREFUL, this process stops the transcription in progress" -ForegroundColor Red `n
    Write-Host "This email is only to be sent at the end of the day" `n
    Write-Host "The script will stop" `n
    $boss = Read-Host "Do you want to continue [y/n]"
    if($boss -like "y" ){

        #Color for the sheet
        $Header = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #6495ED;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@
        Import-Csv ".\report.csv" | ConvertTo-Html -Head $Header | ForEach-Object {
            $PSItem -replace "<td>VM KO</td>", "<td style='background-color:#F61C1C'>VM KO</td>" -replace "<td>VM OK</td>", "<td style='background-color:#80EA32'>VM OK</td>" -replace "<td>ALREADY EXIST</td>", "<td style='background-color:#F8941D'>ALREADY EXIST</td>" -replace "<td>VM No create by user request</td>", "<td style='background-color:#F8941D'>VM No create by user request</td>"
        } | Out-File .\report.html
        $ReportCSV = Get-Content .\report.html

        $email = "other.autre.exo@gmail.com" 
        $pass = "Vmware2019report"
        #$PassKey = [byte]95, 13, 58, 45, 22, 11, 88, 82, 11, 34, 67, 91, 19, 20, 96, 82
        #$pass = Get-Content .\pwd_gmail.txt | Convertto-SecureString -Key $PassKey
        $smtpServer = "smtp.gmail.com" 
        $file1 = ($pathDev + ".\VMs.csv")
        Stop-Transcript 
        $file2 = ($pathDev + ".\Transcription\transcription_script_vms_create_$date.txt") 
        $file3 = ($pathDev +".\logs_script_vms_create.txt")
        $att1 = new-object Net.Mail.Attachment ($file1)
        $att2 = new-object Net.Mail.Attachment ($file2)
        $att3 = new-object Net.Mail.Attachment ($file3)
        
        $smtp = new-object Net.Mail.SmtpClient($smtpServer) 
        $msg = new-object Net.Mail.MailMessage 
        $smtp.EnableSsl = $true 
        $msg.From = "$email"  
        $msg.To.Add("$email") 
        $msg.BodyEncoding = [system.Text.Encoding]::Unicode 
        $msg.SubjectEncoding = [system.Text.Encoding]::Unicode 
        $msg.IsBodyHTML = $true  
        $msg.Subject = "Report creation vms"
        $msg.Body = $ReportCSV
                    

        $msg.Attachments.Add($att1)
        $msg.Attachments.Add($att2)
        $msg.Attachments.Add($att3)
        $smtp.Credentials = New-Object System.Net.NetworkCredential("$email", "$pass"); 

        $smtp.Send($msg)
        #SATUTS OF THE SENDING
            if ($? -eq "True"){
                Write-Host "MAIL SEND" -ForegroundColor Green        
            }
            else {
                Write-Host "MAIL FAIL" -ForegroundColor Red  
            }
            Read-Host = "[ENTER]"
            Disconnect-VIServer -Server $ipvcenter -Confirm:$false
            Write-Host "See you soon !!!!!" -ForegroundColor Cyan
            Start-Sleep -s 2
            clear-host chcp 1252
            Remove-Item -Path .\report.html
            Remove-Item -Path .\report.csv
            exit
    }
    else {
        Menu
    }

}

    #-------------------------------------------------------------------------#
    #                   Send MAIL to User                                     #
    #-------------------------------------------------------------------------#

function SendMailUser {

    set-location $pathDev

    #AUTHENTICATION PART
    $email = "other.autre.exo@gmail.com" 
    $pass = "Vmware2019report"
    $smtpServer = "smtp.gmail.com" 

    #NEW OBJECT
    $smtp = new-object Net.Mail.SmtpClient($smtpServer) 
    $msg = new-object Net.Mail.MailMessage 

    #MAIL OPTION
    $smtp.EnableSsl = $true 
    $msg.From = "$email"  
    $msg.To.Add("$email") 
    $msg.BodyEncoding = [system.Text.Encoding]::Unicode 
    $msg.SubjectEncoding = [system.Text.Encoding]::Unicode 
    $msg.IsBodyHTML = $true  
    
    #MAIL CONTENT    
    $msg.Subject = "Report creation VMs"
    $msg.Body = Get-Content .\TmpMess.txt
    
    $smtp.Credentials = New-Object System.Net.NetworkCredential("$email", "$pass"); 
    $smtp.Send($msg)

    #SATUTS OF THE SENDING
    if ($? -eq "True"){
        Write-Log -Message "MAIL SEND" -Criticite "INFO"
        Write-Host "MAIL SEND" -ForegroundColor Green        
    }
    else {
        Write-Log -Message "MAIL FAIL" -Criticite "MEDIUM"
        Write-Host "MAIL FAIL" -ForegroundColor Red  
    }
}


