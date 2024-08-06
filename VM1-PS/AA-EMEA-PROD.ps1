<#
    Created BY           : Senthil Raj 
    Created Date         : 26-Nov-2021
    Description          : Admin Script to handle the PROD environment
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
                LogMessage -Message "Login to $Region"
                Write-Host "A. PRE-PROD Environment"
                Write-Host "B. PROD Environment"
                $x = Read-Host "Enter your option "
                if($x -eq 'A' -or $x -eq 'a')
                {
                    LogMessage -Message "PRE-PROD Environment"
                    do{
                    Write-Host " Start Time : " 
                    Get-Date -Format 'dd-MM-yyyy HH:mm:ss'
                    Write-Host "Region : $Region - PRE-PROD Environment" -BackgroundColor Yellow -ForegroundColor Red
                    EMEAOperation -Environment 'PRE-PROD'
                    Write-Host " Stop Time : " 
                    Get-Date -Format 'dd-MM-yyyy HH:mm:ss' 
                    $z = Read-Host "Press C to continue "
                    }while($z -eq 'c' -or $z -eq 'C')
                }
                elseif($x -eq 'B' -or $x -eq 'b') 
                {
                    do{
                    LogMessage -Message "PROD Environment"
                    Write-Host " Start Time : " 
                    Get-Date -Format 'dd-MM-yyyy HH:mm:ss'
                    Write-Host "Region : $Region - PROD Environment" -BackgroundColor Yellow -ForegroundColor Red
                    EMEAOperation -Environment 'PROD'
                    Write-Host " Stop Time : "
                    Get-Date -Format 'dd-MM-yyyy HH:mm:ss'                    
                    $z = Read-Host "Press C to continue "
                    }while($z -eq 'c' -or $z -eq 'C')
                }
             }
        '2'
             {
                $Region = "UK"
                Write-Host "A. PRE-PROD Environment"
                Write-Host "B. PROD Environment"
                $x = Read-Host "Enter your option "
                if($x -eq 'A' -or $x -eq 'a')
                {
                    do{
                        LogMessage -Message "PRE-PROD Environment"
                    Write-Host " Start Time : " 
                    Get-Date -Format 'dd-MM-yyyy HH:mm:ss'
                    Write-Host "Region : $Region - Test Environment" -ForegroundColor Yellow
                    $TestAOS = @('DEMEESAX0019')
                    Write-Host " Stop Time : " 
                    Get-Date -Format 'dd-MM-yyyy HH:mm:ss'
                    $z = Read-Host "Press C to continue "
                    }while($z -eq 'c' -or $z -eq 'C')
                }
                elseif($x -eq 'B' -or $x -eq 'b') 
                {
                    do{
                    LogMessage -Message "PROD Environment"
                    Write-Host " Start Time : "
                     Get-Date -Format 'dd-MM-yyyy HH:mm:ss'
                    Write-Host "Region : $Region - UAT Environment" -ForegroundColor Yellow
                    $UATAOS =  @('DEDUSSAX0001','DEMEESAX0012','DEMEESAX0013','DEMEESAX0073')
                    Write-Host " Stop Time : " 
                    Get-Date -Format 'dd-MM-yyyy HH:mm:ss'
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
        'PRE-PROD' 
        {
            $TestAOS = @('DEMEESAX0102')
            Write-Host "SQL Server : DEMEESDB0195\aa_sa1" -BackgroundColor Yellow -ForegroundColor Blue
            Write-Host "Model DB  : EMEA_102_PREPROD_DYNAX_model" -BackgroundColor Yellow -ForegroundColor Blue
            Write-Host "AOSServer : $TestAOS" -BackgroundColor Yellow -ForegroundColor Blue
            Write-Host "1. Status Of the PREPROD AOS"
            Write-Host "2. Start Of the PREPROD AOS"
            Write-Host "3. Stop Of the PREPROD AOS"
            Write-Host "4. Re-start Of the PREPROD AOS"
            Write-Host "5. Export PRE-PROD Environment Modelstore"
            Write-Host "6. Import PRE-PROD Environment Modelstore"
            Write-Host "7. Apply PRE-PROD Modelstore"
            Write-Host "8. Optimize PRE-PROD Environment Modelstore"
            $x = Read-Host "Enter your Option"
            switch ($x)
            {
               '1' 
                {
                    LogMessage -Message "Status of PRE-PROD AOS"
                    ServicesOperation -ServicesName 'AOS60$01' -ComputerName $TestAOS -Operation 'Status'
                    #ServicesOperation -ServicesName 'AOS60$02' -ComputerName $TestAOS -Operation 'Status'
                }
                '2' 
                {
                    LogMessage -Message "Start PRE-PROD Environment"    
                    ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0102' -Operation 'Start'
                }
                '3' 
                {
                    LogMessage -Message "Stop PRE-PROD Environment"
                    ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0102' -Operation 'Stop'
                }
                '4' 
                {
                    LogMessage -Message "Re-start PRE-PROD Environment"
                    ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0102' -Operation 'Restart'
                }
                '5' 
                {   
                    LogMessage -Message "Export PRE-PROD Modelstore"    
                    Write-Host "Modelstore Export Operation" -ForegroundColor Yellow
                    $exportPath = Read-Host "Enter the export path (eg., c:\Temp\PREPROD\EMEA_102_PREPROD_DYNAX_ddmmyy.axmodelstore)"                  
                    ExportModelstore -filePath $exportPath -ServerName 'DEMEESDB0195\aa_sa1' -DatabaseName 'EMEA_102_PREPROD_DYNAX_model'
                }
                '6' 
                {
                    LogMessage -Message "Import PRE-PROD Modelstore"
                    Write-Host "Modelstore Import Operation" -ForegroundColor Yellow
                    $importPath = Read-Host "Enter the Import path (eg., c:\Temp\PREPROD\EMEA_102_UAT_DYNAX_ddmmyy.axmodelstore)"
                    ImportModelstore -filePath $importPath  -ServerName 'DEMEESDB0195\aa_sa1' -DatabaseName 'EMEA_102_PREPROD_DYNAX_model' -Schema_name 'PrePROD' -AOSServer $TestAOS
                }
                '7' 
                {
                    LogMessage -Message "Apply PRE-PROD Modelstore"
                        Write-Host "Modelstore Apply Operation" -ForegroundColor Yellow
                        ApplyModelstore -ServerName 'DEMEESDB0195\aa_sa1' -DatabaseName 'EMEA_102_PREPROD_DYNAX_model' -Schema_name 'PrePROD' -AOSServer $TestAOS
                }
                '8' 
                {
                    LogMessage -Message "Optimize PRE-PROD Modelstore"
                    OptimizeModestore -environment 'PREPROD'
                }
             
                Default {} 
            }
            if($x -ne 1)
            {
                ServicesOperation -ServicesName 'AOS60$01' -ComputerName $TestAOS -Operation 'Status'
            }
          }
        'PROD' 
        {
            
            $UATAOS =  @('DEDUSSAX0002','DEDUSSAX0003','DEDUSSAX0004','DEDUSSAX0005','DEDUSSAX0020','DEDUSSAX0021','DEMEESAX0014','DEMEESAX0015','DEMEESAX0016','DEMEESAX0017','DEMEESAX0018','DEMEESAX0070','DEMEESAX0071','DEMEESAX0072','DEMEESAX0084','DEMEESAX0099','DEMEESAX0100','DEMEESAX0103','DEMEESAX0104','DEMEESAX0105','DEMEESAX0102','DEMEESAX0116')
            Write-Host "1. Status Of the PROD AOS"
            Write-Host "2. Start Of the PROD AOS"
            Write-Host "3. Stop Of the PROD AOS"
            Write-Host "4. Re-start Of the PROD AOS"
            Write-Host "5. Export PROD Environment Modelstore"
            Write-Host "6. Import PROD Environment Modelstore"
            Write-Host "7. Apply PROD Environment Modelstore"
            Write-Host "8. Optimize PROD Environment Modelstore"
            $x = Read-Host "Enter your Option"
            switch ($x)
            {
               '1' 
                {
                    LogMessage -Message "Status PROD Environment"
                    ServicesOperation -ServicesName 'AOS60$01','AOS60$02','AOS60$03' -ComputerName $UATAOS -Operation 'Status'
                }
                '2' 
                {
                    LogMessage -Message "Start PROD AOS Services"
                    Write-Host "1. Start Set 1 AOSs"
                    Write-Host "2. Start Set 2 AOSs"
                    Write-Host "3. Start Set 3 AOSs"
                    Write-Host "4. Start Set 4 AOSs"
                    Write-Host "5. Start Set 5 AOSs"
                    Write-Host "Parallely execute 5 session in PS" -ForegroundColor red -BackgroundColor Yellow                             
                    $xy = Read-Host "Enter your Option"
                    switch ($xy)
                    {
                        '1'
                        {   Write-Host "Set 1 AOSs" -ForegroundColor red -BackgroundColor Yellow
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0002' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0003' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0004' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0005' -Operation 'Start'
                         }
                        '2'
                         {
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0020' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0021' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0014' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0015' -Operation 'Start'
                        }
                        '3'
                         {
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0016' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0017' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0018' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0070' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0071' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0072' -Operation 'Start'
                        }
                        '4'   
                        {
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0084' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0099' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0100' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0103' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0104' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0105' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEDUSSAX0002' -Operation 'Start'
                        }
                        '5'
                        {
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEDUSSAX0003' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEDUSSAX0004' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEDUSSAX0005' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0099' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0100' -Operation 'Start'
                            #ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0102' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0116' -Operation 'Start'
                            ServicesOperation -ServicesName 'AOS60$03' -ComputerName 'DEMEESAX0116' -Operation 'Start'
                        }
                    }
                }
                '3' 
                {
                    LogMessage -Message "Stop PROD AOS Services"
                    Write-Host "1. Stop Set 1 AOSs"
                    Write-Host "2. Stop Set 2 AOSs"
                    Write-Host "3. Stop Set 3 AOSs"
                    Write-Host "4. Stop Set 4 AOSs"
                    Write-Host "5. Stop Set 5 AOSs"
                    Write-Host "Parallely execute 5 session in PS" -ForegroundColor red -BackgroundColor Yellow                             
                    $xy = Read-Host "Enter your Option"
                    switch ($xy)
                    {
                    '1'{
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0002' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0003' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0004' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0005' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0020' -Operation 'Stop'
                            
                        }
                        '2'
                        {
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0021' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0014' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0015' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0016' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0017' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0018' -Operation 'Stop'
                            
                        }
                        '3'
                        {
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0070' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0071' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0072' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0084' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0099' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0100' -Operation 'Stop'
                            
                         }
                         '4'
                         {
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0103' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0104' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0105' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEDUSSAX0002' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEDUSSAX0003' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEDUSSAX0004' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEDUSSAX0005' -Operation 'Stop'
                          }
                        '5'
                        {
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0099' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0100' -Operation 'Stop'
                            #ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0102' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0116' -Operation 'Stop'
                            ServicesOperation -ServicesName 'AOS60$03' -ComputerName 'DEMEESAX0116' -Operation 'Stop'
                        }
                     }
                }
                '4' 
                {
                    LogMessage -Message "Re-Start PROD AOS Services"
                    Write-Host "1. RE-Start Set 1 AOSs"
                    Write-Host "2. RE-Start Set 2 AOSs"
                    Write-Host "3. RE-Start Set 3 AOSs"
                    Write-Host "4. RE-Start Set 4 AOSs"
                    Write-Host "5. RE-Start Set 5 AOSs"
                    Write-Host "Parallely execute 5 session in PS" -ForegroundColor red -BackgroundColor Yellow                             
                    $xy = Read-Host "Enter your Option"
                    switch($xy)
                    {
                        '1'
                        {
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0002' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0003' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0004' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0005' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0020' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEDUSSAX0021' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0014' -Operation 'Restart'
                        }
                        '2'
                        {
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0015' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0016' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0017' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0018' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0070' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0071' -Operation 'Restart'
                        }
                        '3'
                        {
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0072' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0084' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0099' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0100' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0103' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0104' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$01' -ComputerName 'DEMEESAX0105' -Operation 'Restart'
                        }
                        '4'
                        {
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEDUSSAX0002' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEDUSSAX0003' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEDUSSAX0004' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEDUSSAX0005' -Operation 'Restart'
                        }
                        '5'
                        {
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0099' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0100' -Operation 'Restart'
                           # ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0102' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$02' -ComputerName 'DEMEESAX0116' -Operation 'Restart'
                            ServicesOperation -ServicesName 'AOS60$03' -ComputerName 'DEMEESAX0116' -Operation 'Restart'
                        }
                    }
                }
                '5' 
                {       
                    LogMessage -Message "Export PROD Modelstore"
                    Write-Host "Modelstore Export Operation" -ForegroundColor Yellow
                    $exportPath = Read-Host "Enter the export path (eg., c:\Temp\test\EMEA_102_UAT_DYNAX_ddmmyy.axmodelstore)"                 
                    ExportModelstore -filePath $exportPath -ServerName 'DEMEESDB0002-DB\AA_HA1' -DatabaseName 'EMEA_102_PROD_DYNAX_model'
                }
                '6' 
                {
                    LogMessage -Message "Import PROD Modelstore"
                    Write-Host "Modelstore Import Operation" -ForegroundColor Yellow
                    $importPath = Read-Host "Enter the Import path (eg., c:\Temp\test\EMEA_102_UAT_DYNAX_ddmmyy.axmodelstore)"
                    ImportModelstore -filePath $importPath -ServerName 'DEMEESDB0194-DB\AA_HA1' -DatabaseName 'EMEA_102_PROD_DYNAX_model' -Schema_name 'EMEA_102_PROD' -AOSServer $UATAOS
                }
                '7' 
                {
                    LogMessage -Message "Apply PROD Modelstore"
                    Write-Host "Apply Modelstore Operation" -ForegroundColor Yellow
                    ApplyModelstore -ServerName 'DEMEESDB0194-DB\AA_HA1' -DatabaseName 'EMEA_102_PROD_DYNAX_model' -Schema_name 'EMEA_102_PROD' -AOSServer $UATAOS
                }
                
                '8' 
                {
                    LogMessage -Message "Export PROD Modelstore"
                    OptimizeModestore -environment 'PROD'
                }
             
                Default {} 
            }
            Default {}
       }
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
   # Get-Service -Name $ServicesName -ComputerName $ComputerName |Select MachineName,Name,Status,StartType,DisplayName |Format-Table -Wrap
    switch ($Operation)
    {
        'Status'
        {
            LogMessage -Message "Status of AOS"
            Get-Service -Name $ServicesName -ComputerName $ComputerName |Select MachineName,Name,Status,StartType,DisplayName |Format-Table -Wrap
        }
        'Start' 
        {
            LogMessage -Message "Start of AOS"
            #Invoke-Command -ScriptBlock {Stop-Service -Name 'AOS60$01'} -ComputerName DEMEESAX0119
            <# | Set-Service -StartupType Automatic
            Get-Service -Name $ServicesName -ComputerName $ComputerName | Start-Service#>
            switch ($ServicesName)
            {
                'AOS60$01' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$01' -StartupType Automatic} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Start-Service -Name 'AOS60$01' -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName 
                }
                'AOS60$02' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$02' -StartupType Automatic} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Start-Service -Name 'AOS60$02' -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName
                }
                'AOS60$03' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$03' -StartupType Automatic} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Start-Service -Name 'AOS60$03' -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName
                }
                'AOS60$04' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$04' -StartupType Automatic} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Start-Service -Name 'AOS60$04' -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName
                }
                'AOS60$05' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$05' -StartupType Automatic} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Start-Service -Name 'AOS60$05' -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName
                }
                'AOS60$06' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$06' -StartupType Automatic} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Start-Service -Name 'AOS60$06' -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName
                }
                
            }
        }
        'Stop' 
        {
            LogMessage -Message "Stop of AOS"
            Get-Service -Name $ServicesName -ComputerName $ComputerName |Select MachineName,Name,Status,StartType,DisplayName |Format-Table -Wrap
            switch ($ServicesName)
            {
                'AOS60$01' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$01' -StartupType Manual} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Stop-Service -Name 'AOS60$01' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName 
                }
                'AOS60$02' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$02' -StartupType Manual} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Stop-Service -Name 'AOS60$02' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName
                }
                'AOS60$03' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$03' -StartupType Manual} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Stop-Service -Name 'AOS60$03' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName
                }
                'AOS60$04' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$04' -StartupType Manual} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Stop-Service -Name 'AOS60$04' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName
                }
                'AOS60$05' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$05' -StartupType Manual} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Stop-Service -Name 'AOS60$05' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName
                }
                'AOS60$06' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$06' -StartupType Manual} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Stop-Service -Name 'AOS60$06' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName
                }
             }
            
        }
        'Restart' 
        {
            LogMessage -Message "Re-start of AOS"
            switch ($ServicesName)
            {
                'AOS60$01' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$01' -StartupType Manual} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Restart-Service -Name 'AOS60$01' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName 
                }
                'AOS60$02' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$02' -StartupType Manual} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Restart-Service -Name 'AOS60$02' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName
                }
                'AOS60$03' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$03' -StartupType Manual} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Restart-Service -Name 'AOS60$03' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName
                }
                'AOS60$04' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$04' -StartupType Manual} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Restart-Service -Name 'AOS60$04' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName
                }
                'AOS60$05' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$05' -StartupType Manual -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Restart-Service -Name 'AOS60$05' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName
                }
                'AOS60$06' 
                {
                    Invoke-Command -ScriptBlock {Set-Service -Name 'AOS60$06' -StartupType Manual} -ComputerName $ComputerName
                    Invoke-Command -ScriptBlock {Restart-Service -Name 'AOS60$06' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue} -ComputerName $ComputerName
                }
             }
                         
        }
        Default {}

    }
    #Get-Service -Name $ServicesName -ComputerName $ComputerName |Select MachineName,Name,Status,StartType,DisplayName |Format-Table -Wrap
            
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
    Initialize-AXModelStore -SchemaName $Schema_name -Server $ServerName -Database $DatabaseName
    Import-AXModelstore -File $filePath -Server $ServerName -Database $DatabaseName -SchemaName $Schema_name -Idconflict Overwrite -NoPrompt -Details
    $CheckStatus = Get-Service -DisplayName "*$Schema_name*" -ComputerName $AOSServer
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
        Write-Host "As the services is stopped you are good to processed for Apply modelstore" -ForegroundColor Yellow
    }
    else
    {
        Write-Host "Unable To Apply the Modelstore - AOS Services is Up & Running" -ForegroundColor DarkRed
        Get-Service -DisplayName "*$Schema_name*" -ComputerName $AOSServer
    }
}

function ApplyModelstore($ServerName,$DatabaseName,$Schema_name,[string[]]$AOSServer)
{
    Write-Host "Applying the Modelstore Database $DatabaseName ServerName $ServerName"
    Get-Service -DisplayName '*$Schema_name*' -ComputerName $AOSServer
    pause
    $x= Read-Host "Check the respective AOS are stopped (hit y)"
    if($x -eq 'y' -or $x -eq 'Y')
    {
        Import-AXModelstore -Apply $Schema_name -Server $ServerName -Database $DatabaseName -NoPrompt -Details
    }

    <#$CheckStatus = Get-Service -DisplayName '*$Schema_name*' -ComputerName $AOSServer
    foreach ($Status in $CheckStatus)
    {
        if($Status.Status -eq 'Running')
        {
            $imp= 'Not-ok'y
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
    }#>
}



#Optimize the Modelstore for perfromance fine tunning

function OptimizeModestore($environment)
{

    switch ($environment)
    {
        'PREPROD' 
        {
            Write-Host "Working on the UAT Environment modelstore" -ForegroundColor Yellow
            
            Optimize-AXModelstore -Database EMEA_102_PREPROD_DYNAX_model -Server DEMEESDB0195\aa_sa1
            Write-Host "Modelstore Optimization is completed" -ForegroundColor Yellow            
        }
        'PROD' 
        {            
            Write-Host "Working on the Test Environment modelstore" -ForegroundColor Yellow
            Optimize-AXModelstore -Database EMEA_102_PROD_DYNAX_model -Server DEMEESDB0194-DB\AA_HA1
            Write-Host "Modelstore Optimization is completed for Test Environment" -ForegroundColor Yellow
        }
    }
    
}


#log
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

Region