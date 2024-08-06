<#
    Created By : Senthil Raj
    Created on : 21-APr-2022

Purpose : This Script is used to perfrom some Biztalk Operation like 
    1. Enable and Disable the Ports
    2. Compare Two Nodes 
    3. Compare Two Files between
 #>

 $MyPort = @('Port1',
            'Port2'
            )

Function EnableDisableReceiveLocations($BizTalkMgmtDb,$BiztalkServer,$Action,$ListPorts)
{
    [System.reflection.Assembly]::LoadWithPartialName("Microsoft.Biztalk.ExplorerOM")
    $bto=New-Object  Microsoft.BizTalk.ExplorerOM.BtsCatalogExplorer
    $bto.ConnectionString = "Integrated Security=SSPI;database=$BizTalkMgmtDb;server=$BiztalkServer"
    $rpColl = $bto.ReceivePorts
    foreach($rp in $rpColl)
    {
        $rlColl = $rp.ReceiveLocations
        foreach($rl in $rlColl)
        {
            foreach($port in $ListPorts)
            {
                if($rl.Name -eq $port)
                {
                    if($rl.Enable -eq $false -and $Action -eq "Enable")
                    {
                        #$rl.Enable = $true
                        Write-Host('Receive Location -'+ $rl.Name + ' enabled') -ForegroundColor Green
                    }
                    elseif($rl.Enable -eq $true -and $Action -eq "Disable")
                    {
                        #$rl.Enable = $false
                        Write-Host('Receive Location -'+ $rl.Name + '  Disabled') -ForegroundColor Yellow                   
                    }
                    else
                    {
                        Write-Host('No Operation Perfromed on Receive Location -'+ $rl.Name + '  Enable/Disabled') -ForegroundColor DarkMagenta
                    }
                }
            
            }
        }
    }
        $bto.SaveChanges() 
        $bto.Refresh()
}
#To Compare the File exist in the Path or Note
function compareDir($source_DIR,$Destination_Dir)
{
    $Node1 = Get-ChildItem -Recurse -path $source_DIR

    $Node2 = Get-ChildItem -Recurse -path $Destination_Dir

    Compare-Object -ReferenceObject $Node1 -DifferenceObject $Node2
    

    Write-Host "The <== says the file exist in Source / Node 1 "
    #Write-Host "The ==> says the file exist in Destination / Node 2 "
    #compareDir -source_DIR "\\DEMEESBT0006-1\C$\Windows\Microsoft.NET\assembly\GAC_MSIL" -Destination_Dir "\\DEDUSSBT0006-2\C$\Windows\Microsoft.NET\assembly\GAC_MSIL" 
}

#To Compare the File exist in the Path or Note
function compareFile($source_DIR,$Destination_Dir)
{
    $Node1 = Get-ChildItem -Recurse -path $source_DIR -File

    $Node2 = Get-ChildItem -Recurse -path $Destination_Dir -File

    #Compare-Object -ReferenceObject $Node1 -DifferenceObject $Node2
    Compare-Object -ReferenceObject $Node1 -DifferenceObject $Node2 -Property Name,LastWriteTime -IncludeEqual
    
    Write-Host "The <== says the file exist in Source / Node 1 "
    Write-Host "The ==> says the file exist in Destination / Node 2 "
    #compareFile -source_DIR "\\DEMEESBT0006-1\C$\Windows\Microsoft.NET\assembly\GAC_MSIL" -Destination_Dir "\\DEDUSSBT0006-2\C$\Windows\Microsoft.NET\assembly\GAC_MSIL"
}

function main()
{
   Start-Transcript -Path "D:\CGI\log.txt" -Append
    Write-Host "1. UAT"
    Write-Host "2. PROD"
    Write-Host "3. TEST"
    $x = Read-Host "Enter your Option " 
    switch ($x)
    {
        '1' 
        {
            Write-Host "UAT Biztalk Operation" -ForegroundColor Magenta
            Write-Host "A. Eanable the Biztalk Ports"
            Write-Host "B. Disable the Biztalk Ports"
            Write-Host "C. Compare the Biztalk Assembly Directory"
            Write-Host "D. Compare the Biztalk Assembly File"
            $y= Read-Host "Enter your Option "
            switch ($y.ToUpper())
            {
                'A' 
                {
                    Write-Host "Eanable the Biztalk Ports Operation Started" -ForegroundColor Yellow
                    EnableDisableReceiveLocations -BizTalkMgmtDb EMEA_500_UAT_BizTalkMgmtDb -BiztalkServer DEMEESDB0020\AA_SA3 -Action Enable -ListPorts $MyPort
                    Write-Host "Eanable the Biztalk Ports Operation Completed" -ForegroundColor Yellow
                }
                'B'
                {
                    Write-Host "Disable the Biztalk Ports Operation Started" -ForegroundColor Yellow
                    EnableDisableReceiveLocations -BizTalkMgmtDb EMEA_500_UAT_BizTalkMgmtDb -BiztalkServer DEMEESDB0020\AA_SA3 -Action Disable -ListPorts $MyPort
                    Write-Host "Disable the Biztalk Ports operation Completed" -ForegroundColor Yellow
                }
                'C'
                {
                    Write-Host "Compare the Biztalk Folders & File between two Nodes" -ForegroundColor Yellow
                    compareDir -source_DIR "\\DEMEESBT0006-1\C$\Windows\Microsoft.NET\assembly\GAC_MSIL" -Destination_Dir "\\DEDUSSBT0006-2\C$\Windows\Microsoft.NET\assembly\GAC_MSIL" 
                    Write-Host "Compration Completed Sucessfully!!!" -ForegroundColor Yellow
                }
                'D'
                {
                    Write-Host "Compare the Biztalk File between two Nodes lost modified Date" -ForegroundColor Yellow
                    compareFile -source_DIR "\\DEMEESBT0006-1\C$\Windows\Microsoft.NET\assembly\GAC_MSIL" -Destination_Dir "\\DEDUSSBT0006-2\C$\Windows\Microsoft.NET\assembly\GAC_MSIL"
                    Write-Host "Compration Completed Sucessfully!!!" -ForegroundColor Yellow
                }
            }
        }
        '2'
        {
            Write-Host "PROD Biztalk Operation" -ForegroundColor Magenta
            Write-Host "A. Eanable the Biztalk Ports"
            Write-Host "B. Disable the Biztalk Ports"
            Write-Host "C. Compare the Biztalk Assembly Directory"
            Write-Host "D. Compare the Biztalk Assembly File"
            $y= Read-Host "Enter your Option "
            switch ($y.ToUpper())
            {
                'A' 
                {
                    Write-Host "Eanable the Biztalk Ports Operation Started" -ForegroundColor Yellow
                    EnableDisableReceiveLocations -BizTalkMgmtDb EMEA_500_UAT_BizTalkMgmtDb -BiztalkServer DEMEESDB0020\AA_SA3 -Action Enable -ListPorts $MyPort
                    Write-Host "Eanable the Biztalk Ports Operation Completed" -ForegroundColor Yellow
                }
                'B'
                {
                    Write-Host "Disable the Biztalk Ports Operation Started" -ForegroundColor Yellow
                    EnableDisableReceiveLocations -BizTalkMgmtDb EMEA_500_UAT_BizTalkMgmtDb -BiztalkServer DEMEESDB0020\AA_SA3 -Action Disable -ListPorts $MyPort
                    Write-Host "Disable the Biztalk Ports Operation Completed" -ForegroundColor Yellow
                }
                'C'
                {
                    Write-Host "Compare the Biztalk Folders & File between two Nodes" -ForegroundColor Yellow
                    compareDir -source_DIR "\\DEMEESBT0005-1\C$\Windows\Microsoft.NET\assembly\GAC_MSIL" -Destination_Dir "\\DEDUSSBT0005-2\C$\Windows\Microsoft.NET\assembly\GAC_MSIL" 
                    Write-Host "Compration Completed Sucessfully!!!" -ForegroundColor Yellow
                }
                'D'
                {
                    Write-Host "Compare the Biztalk File between two Nodes" -ForegroundColor Yellow
                    compareFile -source_DIR "\\DEMEESBT0005-1\C$\Windows\Microsoft.NET\assembly\GAC_MSIL" -Destination_Dir "\\DEDUSSBT0005-2\C$\Windows\Microsoft.NET\assembly\GAC_MSIL"
                    Write-Host "Compration Completed Sucessfully!!!" -ForegroundColor Yellow
                }
            }
         }
        '3'
        {
            Write-Host "TEST Biztalk Operation" -ForegroundColor Magenta
            Write-Host "A. Eanable the Biztalk Ports"
            Write-Host "B. Disable the Biztalk Ports"
            $y= Read-Host "Enter your Option "
            switch ($y.ToUpper())
            {
                    'A' 
                    {
                        Write-Host "Eanable the Biztalk Ports Operation Started" -ForegroundColor Yellow
                        EnableDisableReceiveLocations -BizTalkMgmtDb EMEA_500_UAT_BizTalkMgmtDb -BiztalkServer DEMEESDB0020\AA_SA3 -Action Enable -ListPorts $MyPort
                        Write-Host "Eanable the Biztalk Ports Operation Completed" -ForegroundColor Yellow
                    }
                    'B'
                    {
                        Write-Host "Disable the Biztalk Ports Operation Started" -ForegroundColor Yellow
                        EnableDisableReceiveLocations -BizTalkMgmtDb EMEA_500_UAT_BizTalkMgmtDb -BiztalkServer DEMEESDB0020\AA_SA3 -Action Disable -ListPorts $MyPort
                        Write-Host "Disable the Biztalk Ports Operation Completed" -ForegroundColor Yellow
                    }
                    
                }
         }
    }

Stop-Transcript
}
main