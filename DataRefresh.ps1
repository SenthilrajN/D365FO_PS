<#

    Organization : CG
    Created date : 17-Feb-2021
    Created By   : Senthilraj
    Product      : Dynamics 365 Finance and Operation
    Purpose: To handle the import export operation from bacpac to Developer SQL

#>

#Organization Folder
$company = "CG"

function Main()
{
    Write-Host "1. Import bacpac"
    Write-Host "2. Export bacpac - Beta"
    Write-Host "3. Stop D365 Dependent server"
    Write-Host "4. Start D365 Dependent server"
    Write-Host "5. Alter the Database"
    Write-Host "6. Synchronize the DB"
    Write-Host "7. Set Maintenance Mode"
    Write-Host "8. Install D365 Nuget"
    Write-Host "9. Drop Retail chennal DB"
    Write-Host "10. Generate CAR Report"

    $x= Read-Host "Enter your option"
    switch ($x)
    {
        '1' 
        {
            Importbacpac
        }
        '2'
        {
            Exportbacpac
        }
        '3' 
        {
            StopD365RelevantService
            get-D365Servicestatus
        }
        '4' 
        {
            StartD365RelevantService
            get-D365Servicestatus
        }
        '5'
        {
            #Alter Database commend 
            $Res = Read-Host "Only in Issue we execute this steps Hit Y"
            if($Res -eq 'y' -or $Res -eq 'Y')
            {
                    $date = Get-Date -Format MMddyyyy
                    $DatabaseName= "AXDB_$date"

                    Alter-D365 -oldDB "AxDB" -newDB "AxDB_Org_$date"
                    Alter-D365 -oldDB $DatabaseName -newDB "AxDB"
            }
        }
        '6'
        {
            $password = Read-Host "Past the AXDBadmin password here"
            if($password -ne "")
            {
                DBSync -pwd $password
                
            }
        }
        '7'
        {
            D365MaintainanceMode
        }
        '8'
        {
            install_NugetPckg
        }
        <#{
            $modelXmlPath = Read-Host "model.xml file path"
            $hasher = [System.Security.Cryptography.HashAlgorithm]::Create("System.Security.Cryptography.SHA256CryptoServiceProvider")
            $fileStream = new-object System.IO.FileStream ` -ArgumentList @($modelXmlPath, [System.IO.FileMode]::Open)
            $hash = $hasher.ComputeHash($fileStream)
            $hashString = ""
            Foreach ($b in $hash) { $hashString += $b.ToString("X2") }
            $fileStream.Close()
            $hashString 
        }#>
        '9'
        {
            $files = Get-ChildItem -Path K:\DeployablePackages\DropAllRetailChannelDbObjects.sql -Recurse
            foreach ($file in $files)
            {
                $pth = $file.FullName
                if($pth.Contains("DropAllRetailChannelDbObjects.sql") -eq $true)
                {
                    Write-Host $file.FullName
                    Write-Host "The Job will complete in 20 min"
                    Write-Host "Please Waite!!!!"
                    Invoke-Sqlcmd -ServerInstance localhost -Database AxDB -InputFile $file.FullName 
                    Write-Host "Drop Channel DB is Completed" -ForegroundColor Green                   
                }
   
            }
            
        }
        '10'
        {
            Write-Host "Customization Analysis Report (CAR)"
            $x = Read-Host "How many custom model e.g. 3/4"
            for ($i = 1; $i -le $x; $i++)
            { 
                $ModelName = Read-Host "Enter the Model Name"
                CARReport -ModelName "$ModelName"
            }
        }
        Default {}
    }

}

function StopD365RelevantService()
{
    Stop-Service -Name Microsoft.Dynamics.AX.Framework.Tools.DMF.SSISHelperService.exe -ErrorAction SilentlyContinue
    Stop-Service -Name DynamicsAxBatch -ErrorAction SilentlyContinue
    Stop-Service -Name W3SVC -ErrorAction SilentlyContinue
    Stop-Service -Name MR2012ProcessService -ErrorAction SilentlyContinue
}

function StartD365RelevantService()
{
    Start-Service -Name Microsoft.Dynamics.AX.Framework.Tools.DMF.SSISHelperService.exe -ErrorAction SilentlyContinue
    Start-Service -Name DynamicsAxBatch -ErrorAction SilentlyContinue
    Start-Service -Name W3SVC -ErrorAction SilentlyContinue
    Start-Service -Name MR2012ProcessService -ErrorAction SilentlyContinue
}

function Importbacpac()
{
    $date = Get-Date -Format MMddyyyy
    get-SQLPacage
    $mypath = "C:\$company\SQLPackage\"
    Set-Location -path $mypath
    $file = Read-Host "Enter the backpac file path"
    $file = $file.Replace('"','')
    $SQLpwd = Read-Host "Enter the axdbadmin pwd"
    $DatabaseName= "AXDB_$date"
    $TargetserverName = 'localhost'
    #.\SqlPackage.exe /TargetTrustServerCertificate:True /a:Import /sf:$file /tsn:$TargetserverName /tdn:$DatabaseName /tu:axdbadmin /tp:$SQLpwd /p:CommandTimeout=15000 /mfp:$modelFile > "C:\$company\log\dbrestore_log$date.txt"
    .\SqlPackage.exe /TargetTrustServerCertificate:True /a:Import /sf:$file /tsn:$TargetserverName /tdn:$DatabaseName /tu:axdbadmin /tp:$SQLpwd /p:CommandTimeout=15000  
    $y = Read-Host "Can we continuee (Press C/c)"
    if($y -eq 'c')
    {
        StopD365RelevantService
        Alter-D365 -oldDB "AxDB" -newDB "AxDB_Org_$date"
        Alter-D365 -oldDB $DatabaseName -newDB "AxDB"
    }
}

function Exportbacpac()
{
    $date = Get-Date -Format MMddyyyy
    get-SQLPacage
    $mypath = "C:\$company\SQLPackage\"
    Set-Location -path $mypath
    $SourceServerName = Read-Host "Enter the Server Name"
    $DatabaseName = Read-Host "Enter the Database Name"
    $TargetFilePath = Read-Host "Enter the SaveLocation Path[e.g c:\tmx\AXDB_YYYYmmDD.bacpac]"
    .\SqlPackage.exe /a:Export /ssn:$SourceServerName /sdn:$DatabaseName /tf:$TargetFilePath /p:CommandTimeout=1200 /p:VerifyFullTextDocumentTypesSupported=false
}

function Get-SQLPacage()
{
    #$url= "https://go.microsoft.com/fwlink/?linkid=2157302" #if the SQL package location changes
    $url="https://aka.ms/sqlpackage-windows" 
    $SQLFilepath = "C:\$company\SQLPackage\"
    $res = Test-Path -Path $SQLFilepath
    if($res.ToString() -eq 'false')
    {
        mkdir -Path $SQLFilepath
        mkdir -Path 'C:\$company\Log'
        mkdir -Path 'C:\$company\NuGet'
    }
    $checkSQLPackage = Test-Path -Path "C:\$company\SQLPackage\sqlpackage.exe"
    if($checkSQLPackage.ToString() -eq 'false')
    {
    $downloadPath = "C:\$company\SQLPackage\SQLpackage.zip"# +  $(split-path -Path $url -Leaf)
    Invoke-WebRequest -Uri $Url -OutFile $downloadPath
    $ExtractShell = New-Object -ComObject Shell.Application
    $ExtractPath =  "C:\$company\SQLPackage\"
    $ExtractFiles = $ExtractShell.Namespace($downloadPath).Items()
    $ExtractShell.NameSpace($ExtractPath).CopyHere($ExtractFiles) 
    #Start-Process $ExtractPath
    }
    return $SQLFilepath
}
function get-D365Servicestatus()
{
    Get-Service -Name "DynamicsAxBatch","Microsoft.Dynamics.AX.Framework.Tools.DMF.SSISHelperService.exe","W3SVC","MR2012ProcessService" | Format-Table
}
function Alter-D365($oldDB,$newDB)
{
    Invoke-Sqlcmd -ServerInstance localhost -Database master -Query "Alter database $oldDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE"
    Invoke-Sqlcmd -ServerInstance localhost -Database master -Query "Alter database $oldDB modify Name=$newDB"
    Invoke-Sqlcmd -ServerInstance localhost -Database master -Query "Alter database $newDB SET MULTI_USER WITH ROLLBACK IMMEDIATE"

}
function DBSync($pwd)
{
    if (Test-Path -Path K:\AosService\PackagesLocalDirectory\bin)
    {
         Set-Location K:\AosService\PackagesLocalDirectory\bin
         .\Microsoft.Dynamics.AX.Deployment.Setup.exe -bindir “K:\AosService\PackagesLocalDirectory” -metadatadir K:\AosService\PackagesLocalDirectory -sqluser axdbadmin -sqlserver localhost -sqldatabase AxDB -setupmode sync -syncmode fullall -sqlpwd $pwd
    }
    if (Test-Path -Path J:\AosService\PackagesLocalDirectory\bin)
    {
        Set-Location J:\AosService\PackagesLocalDirectory\bin
         .\Microsoft.Dynamics.AX.Deployment.Setup.exe -bindir “J:\AosService\PackagesLocalDirectory” -metadatadir J:\AosService\PackagesLocalDirectory -sqluser axdbadmin -sqlserver localhost -sqldatabase AxDB -setupmode sync -syncmode fullall -sqlpwd $pwd
    }
}

function D365MaintainanceMode()
{
    Write-Host "1. Enablle Maintainance model"
    Write-Host "2. Disable Maintainance model"
    $x= Read-Host "Enter your option"
    switch ($x)
    {
        '1'
        {
            Invoke-Sqlcmd -ServerInstance localhost -Database AxDB -Query "update SQLSYSTEMVARIABLES set VALUE=1 where PARM='ConfigurationMode'"
            Write-Host "Set to maintenance mode $env:COMPUTERNAME"
            iisreset
        }
        '2'
        {
            Invoke-Sqlcmd -ServerInstance localhost -Database AxDB -Query "update SQLSYSTEMVARIABLES set VALUE=0 where PARM='ConfigurationMode'"
            Write-Host "Re-Set to Normal mode $env:COMPUTERNAME"
            iisreset
        }
            
    
    }
}

function CARReport($ModelName)
{
    if(Test-Path "J:\AosService")
    {
        $date = Get-Date -Format MMddyyyy
        $pcK_LocalDir = "J:\AosService\PackagesLocalDirectory\bin"
        Set-Location -Path $pcK_LocalDir
        #$ModelName = "IDECPOModel" 
        $XL_FileName = $ModelName+$date 
        $cmd = ".\xppbp.exe -metadata=J:\AosService\PackagesLocalDirectory -all -model=""$ModelName"" -xmlLog=C:\$company\BPCheckLogcd.xml -car=C:\$company\CAR_$XL_FileName.xlsx -Module=""$ModelName"" -packagesroot=J:\AosService\PackagesLocalDirectory"
        Write-Host $cmd
        Invoke-Expression $cmd
    }
    
    if(Test-Path "K:\AosService")
    {
        $pcK_LocalDir = "K:\AosService\PackagesLocalDirectory\bin"
        Set-Location -Path $pcK_LocalDir
        $cmd = ".\xppbp.exe -metadata=K:\AosService\PackagesLocalDirectory -all -model=""$ModelName"" -xmlLog=C:\$company\BPCheckLogcd.xml -car=C:\$company\CAR_$XL_FileName.xlsx -Module= ""$ModelName"" -packagesroot=K:\AosService\PackagesLocalDirectory"
        Invoke-Expression $cmd
    }
}

#D365 install the NuGet pacakge
function install_NugetPckg()
{
    Invoke-WebRequest -Uri "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" -OutFile "c:\$company\Nuget\Nuget2.exe"
    iex "& { $(irm https://aka.ms/install-artifacts-credprovider.ps1) } -AddNetfx"

    #nuget.exe push -Source "IDED365Build-10.0.40" -ApiKey az <packagePath>
    Set-Location "C:\$company\NuGet"
    $NugetPckg = Get-ChildItem -Path C:\$company\NuGet -Filter "*.nupkg" -Recurse
    foreach ($item in $NugetPckg)
    {
        Write-Host "INstalling the Nuget pacakge $item.FullName" -ForegroundColor DarkGreen
        .\nuget.exe push -Source "IDED365Build-10.0.40" -ApiKey az $item.FullName
    }


}
main 
