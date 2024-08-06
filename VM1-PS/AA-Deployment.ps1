<#
    Created BY           : Senthil Raj 
    Created Date         : 26-Nov-2021
    Description          : Admin Script to handle the Non-PROD environment
    Status of the AOS & Dependent Services
    Start the AOS 
    Stop the AOS
    ModelStore Export
    MOdelstore Import
    Optimize the modelstore
#>
Import-Module 'D:\Program Files\Microsoft Dynamics AX\60\ManagementUtilities\Microsoft.Dynamics.ManagementUtilities.ps1'
Function Region()
{
    Write-Host "1. EMEA Region" -ForegroundColor Yellow
    Write-Host "2. UK Region" -ForegroundColor Yellow
    $x= Read-Host "Enter Your Option :" 
    switch ($x)
    {
        '1'
             {
                $Region = "EMEA"
                Write-Host "A. Test Environment"
                Write-Host "B. UAT Environment"
                $x = Read-Host "Enter your option "
                if($x -eq 'A' -or $x -eq 'a')
                {
                    do{
                    Write-Host "Region : $Region - Test Environment" -BackgroundColor Yellow -ForegroundColor Red
                    EMEAOperation -Environment 'Test'
                    $z = Read-Host "Press C to continue "
                    }while($z -eq 'c' -or $z -eq 'C')
                }
                elseif($x -eq 'B' -or $x -eq 'b') 
                {
                    do{
                    Write-Host "Region : $Region - UAT Environment" -BackgroundColor Yellow -ForegroundColor Red
                    EMEAOperation -Environment 'UAT'                    
                    $z = Read-Host "Press C to continue "
                    }while($z -eq 'c' -or $z -eq 'C')
                }
             }
        '2'
             {
                $Region = "UK"
                Write-Host "A. Test Environment"
                Write-Host "B. UAT Environment"
                $x = Read-Host "Enter your option "
                if($x -eq 'A' -or $x -eq 'a')
                {
                    do{
                    Write-Host "Region : $Region - Test Environment" -ForegroundColor Yellow
                    $TestAOS = @('DEMEESAX0019')
                    $z = Read-Host "Press C to continue "
                    }while($z -eq 'c' -or $z -eq 'C')
                }
                elseif($x -eq 'B' -or $x -eq 'b') 
                {
                    do{
                    Write-Host "Region : $Region - UAT Environment" -ForegroundColor Yellow
                    $UATAOS =  @('DEDUSSAX0001','DEMEESAX0012','DEMEESAX0013','DEMEESAX0073')
                    $z = Read-Host "Press C to continue "
                    }while($z -eq 'c' -or $z -eq 'C')
                }
             }
        Default {}
    }
}

#Environment Management 

#EMEA 
Function EMEAOperation($Environment)
{
    switch ($Environment)
    {
        'TEST' 
        {
            $TestAOS = @('DEMEESAX0119','DEMEESAX0011','DEMEESAX0010')
            Write-Host "1. Status Of the Test AOS"
            Write-Host "2. Start Of the Test AOS"
            Write-Host "3. Stop Of the Test AOS"
            Write-Host "4. Re-start Of the Test AOS"
            Write-Host "5. Export Test Environment Modelstore"
            Write-Host "6. Import Test Environment Modelstore"
            Write-Host "7. Optimize Test Environment Modelstore"
            $x = Read-Host "Enter your Option"
            switch ($x)
            {
               '1' 
                {
                    ServicesOperation -ServicesName 'AOS60$01','AOS60$02' -ComputerName $TestAOS -Operation 'Status'
                    #ServicesOperation -ServicesName 'AOS60$02' -ComputerName $TestAOS -Operation 'Status'
                }
                '2' 
                {
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0010' -Operation 'Start'
                        ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0011' -Operation 'Start'
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0019' -Operation 'Start'
                }
                '3' 
                {
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0010' -Operation 'Stop'
                        ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0011' -Operation 'Stop'
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0019' -Operation 'Stop'
                }
                '4' 
                {
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0010' -Operation 'Restart'
                        ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0011' -Operation 'Restart'
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0019' -Operation 'Restart'
                }
                '5' 
                {       
                        Write-Host "Mdetstore Export Operation" -ForegroundColor Yellow
                        $exportPath = Read-Host "Enter the export path (eg., c:\Temp\test\EMEA_102_TETS_DYNAX_ddmmyy.axmodelstore)"                  
                        ExportModelstore -filePath $exportPath -ServerName 'DEDUSSDB0003\AA_SA1' -DatabaseName 'EMEA_102_TEST_DYNAX_model'
                }
                '6' 
                {
                        Write-Host "Mdetstore Import Operation" -ForegroundColor Yellow
                        $importPath = Read-Host "Enter the Import path (eg., c:\Temp\test\EMEA_102_UAT_DYNAX_ddmmyy.axmodelstore)"
                        ImportModelstore -filePath $importPath  -ServerName 'DEDUSSDB0003\AA_SA1' -DatabaseName 'EMEA_102_TEST_DYNAX_model' -Schema_name 'Test' -AOSServer $TestAOS
                }
                '7' 
                {
                        OptimizeModestore -environment 'TEST'
                }
             
                Default {} 
            }
            if($x -ne 1)
            {
                ServicesOperation -ServicesName 'AOS60$01','AOS60$02' -ComputerName $TestAOS -Operation 'Status'
            }
          }
        'UAT' 
        {
            
            $UATAOS =  @('DEDUSSAX0001','DEMEESAX0012','DEMEESAX0013','DEMEESAX0073')
            Write-Host "1. Status Of the UAT AOS"
            Write-Host "2. Start Of the UAT AOS"
            Write-Host "3. Stop Of the UAT AOS"
            Write-Host "4. Re-start Of the UAT AOS"
            Write-Host "5. Export UAT Environment Modelstore"
            Write-Host "6. Import UAT Environment Modelstore"
            Write-Host "7. Optimize UAT Environment Modelstore"
            $x = Read-Host "Enter your Option"
            switch ($x)
            {
               '1' 
                {
                        ServicesOperation -ServicesName 'AOS60$01','AOS60$02' -ComputerName $UATAOS -Operation 'Status'
                }
                '2' 
                {
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0001' -Operation 'Start'
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0012' -Operation 'Start'
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0013' -Operation 'Start'
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0073' -Operation 'Start'
                        ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0073' -Operation 'Start'
                }
                '3' 
                {
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0001' -Operation 'Stop'
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0012' -Operation 'Stop'
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0013' -Operation 'Stop'
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0073' -Operation 'Stop'
                        ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0073' -Operation 'Stop'
                }
                '4' 
                {
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0001' -Operation 'Restart'
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0012' -Operation 'Restart'
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0013' -Operation 'Restart'
                        ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0073' -Operation 'Restart'
                        ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0073' -Operation 'Restart'
                }
                '5' 
                {       
                        Write-Host "Mdetstore Export Operation" -ForegroundColor Yellow
                        $exportPath = Read-Host "Enter the export path (eg., c:\Temp\test\EMEA_102_UAT_DYNAX_ddmmyy.axmodelstore)"                 
                        ExportModelstore -filePath $exportPath -ServerName 'DEMEESDB0002-DB\AA_HA1' -DatabaseName 'EMEA_102_UAT_DYNAX_model'
                }
                '6' 
                {
                        Write-Host "Mdetstore Import Operation" -ForegroundColor Yellow
                        $importPath = Read-Host "Enter the Import path (eg., c:\Temp\test\EMEA_102_UAT_DYNAX_ddmmyy.axmodelstore)"
                        ImportModelstore -filePath $importPath -ServerName 'DEMEESDB0002-DB\AA_HA1' -DatabaseName 'EMEA_102_UAT_DYNAX_model' -Schema_name 'Test' -AOSServer $UATAOS
                }
                '7' 
                {
                        OptimizeModestore -environment 'UAT'
                }
             
                Default {} 
            }

            if($x -ne 1)
            {
                ServicesOperation -ServicesName 'AOS60$01','AOS60$02' -ComputerName $UATAOS -Operation 'Status'
            }
        }
        Default {}
    }
}

#UK Environment 
Function UKOperation($environment)
{
    switch ($Environment)
    {
        'TEST' 
        {
            $TestAOS = @('DEMEESAX0019')
            Write-Host "1. Status Of the Test AOS"
            Write-Host "2. Start Of the Test AOS"
            Write-Host "3. Stop Of the Test AOS"
            Write-Host "4. Re-start Of the Test AOS"
            $x = Read-Host "Enter your Option"
            switch ($x)
            {
               '1' 
                {
                        ServicesOperation -ServicesName 'AOS50$02' -ComputerName $TestAOS -Operation 'Status'
                }
                '2' 
                {
                        ServicesOperation -ServicesName 'AOS50$02' -ComputerName 'DEMEESAX0019' -Operation 'Start'
                }
                '3' 
                {
                        ServicesOperation -ServicesName 'AOS50$02' -ComputerName 'DEMEESAX0019' -Operation 'Stop'
                }
                '4' 
                {
                        ServicesOperation -ServicesName 'AOS50$02' -ComputerName 'DEMEESAX0019' -Operation 'Restart'
                }
             
                Default {} 
            }
          }
        'UAT' 
        {
            $UATAOS =  @('DEDUSSAX0001','DEMEESAX0012','DEMEESAX0013','DEMEESAX0073')
            Write-Host "1. Status Of the UAT AOS"
            Write-Host "2. Start Of the UAT AOS"
            Write-Host "3. Stop Of the UAT AOS"
            Write-Host "4. Re-start Of the UAT AOS"
            $x = Read-Host "Enter your Option"
            switch ($x)
            {
               '1' 
                {
                    ServicesOperation -ServicesName 'AOS50$01' -ComputerName $UATAOS -Operation 'Status'
                    ServicesOperation -ServicesName 'AOS50$02' -ComputerName $UATAOS -Operation 'Status'
                    ServicesOperation -ServicesName 'AOS50$03' -ComputerName $UATAOS -Operation 'Status'
                }
                '2' 
                {
                        ServicesOperation -ServicesName 'AOS50$01' -ComputerName $SysName -Operation 'Start'
                }
                '3' 
                {
                        ServicesOperation -ServicesName 'AOS50$01' -ComputerName $SysName -Operation 'Stop'
                }
                '4' 
                {
                        ServicesOperation -ServicesName 'AOS50$01' -ComputerName $SysName -Operation 'Restart'
                }                         
                Default {} 
            }
        }
        Default {}
    }
}



#Function to Operate services
function ServicesOperation($ServicesName,$ComputerName,$Operation = 'Status')
{
    switch ($Operation)
    {
        'Status'
        {
            Get-Service -Name $ServicesName -ComputerName $ComputerName |Select MachineName,Name,status,StartType,DisplayName |Format-Table -Wrap
        }
        'Start' 
        {
            Get-Service -Name $ServicesName -ComputerName $ComputerName | Set-Service -StartupType Automatic
            Get-Service -Name $ServicesName -ComputerName $ComputerName | Start-Service -PassThru
        }
        'Stop' 
        {
            Get-Service -Name $ServicesName -ComputerName $ComputerName | Stop-Service -PassThru
            Get-Service -Name $ServicesName -ComputerName $ComputerName | Set-Service -StartupType Manual
        }
        'Restart' 
        {
            Get-Service -Name $ServicesName -ComputerName $ComputerName | Restart-Service -PassThru
            Get-Service -Name $ServicesName -ComputerName $ComputerName | Set-Service -StartupType Manual
        }
        Default {}
    }
}

#Export the modelstore 
function ExportModelstore($filePath,$ServerName,$DatabaseName)
{
    Write-Host "Exporting the Modelstore Database $DatabaseName ServerName $ServerName"
    Export-AXModelstore -File $filePath -Server $ServerName -Database $DatabaseName -Verbose
}

#Import the modelstore 
function ImportModelstore($filePath,$ServerName,$DatabaseName,$Schema_name,[string[]]$AOSServer)
{
    Write-Host "Importing the Modelstore Database $DatabaseName ServerName $ServerName"
    Inialize-AXModelStore -SchemaName $Schema_name -Server $ServerName -Database $DatabaseName
    Import-AXModelstore -File $filePath -Server $ServerName -Database $DatabaseName -SchemaName $Schema_name
    $CheckStatus = Get-Service -DisplayName $Schema_name -ComputerName $AOSServer
    foreach ($Status in $CheckStatus)
    {
        if($Status.Status -eq 'Running')
        {
            $imp= 'Not-ok'
        }
        else
        {
            $imp= 'ok' 
        }
    }

    if($imp -eq 'ok')
    {
        Import-AXModelstore -Apply $Schema_name -Server $ServerName -Database $DatabaseName -Idconflict Overwrite
    }
    else
    {
        Write-Host "Unable To Apply the Modelstore - AOS Services is Up & Running" -ForegroundColor DarkRed
        Get-Service -DisplayName $Schema_name -ComputerName $AOSServer
    }
}


#Optimize the Modelstore for perfromance fine tunning

function OptimizeModestore($environment)
{

    switch ($environment)
    {
        'ER' 
        {
            Write-Host "Working on the UAT Environment modelstore" -ForegroundColor Yellow
            Optimize-AXModelstore -Database EMEA_102_UAT_DYNAX_model -Server DEMEESDB0002-DB\AA_HA1
            Write-Host "Modelstore Optimization is completed" -ForegroundColor Yellow            
        }
        'Test' 
        {
            Write-Host "Working on the Test Environment modelstore" -ForegroundColor Yellow
            Optimize-AXModelstore -Database EMEA_102_TEST_DYNAX_model -Server DEDUSSDB0003\AA_SA1
            Write-Host "Modelstore Optimization is completed for Test Environment" -ForegroundColor Yellow
        }
        'UAT' 
        {
            Write-Host "Working on the UAT Environment modelstore" -ForegroundColor Yellow
            Optimize-AXModelstore -Database EMEA_102_UAT_DYNAX_model -Server DEMEESDB0002-DB\AA_HA1
            Write-Host "Modelstore Optimization is completed for UAT Environment" -ForegroundColor Yellow 
        }

    }
    
}
Region