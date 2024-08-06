<#
    Created By : Senthil 
    Created date : 11-Dec-2021
    Purpose: 
#>

Function LogMessage([string]$Message)
{
    if(Test-Path "C:\Windows\CGI")
    {
        $msg = (Get-Date).ToString('dd-MM-yyyy H:mm')  + " :- Executed By $env:USERNAME :-" + $Message
        Add-Content -Path "C:\Windows\CGI\CGI_AXDeploymentLog.txt" $msg 
    }
    else
    {
        New-Item -Path 'C:\Windows\CGI' -ItemType Directory
        $msg = (Get-Date).ToString('dd-MM-yyyy H:mm')  + " :- Executed By $env:USERNAME :-" + $Message
        Add-Content -Path "C:\Windows\CGI\CGI_AXDeploymentLog.txt" $msg
    }
    
}