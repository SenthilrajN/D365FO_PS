<#
rename XPPIL
#>

$AXFSPAth = @('\\Dedussax0002\D$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX_WCF\Bin\XPPIL','
\\Dedussax0003\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX_WCF\bin\XPPIL',
'\\DEDUSSAX0004\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX_BATCH1\bin\XPPIL',
'\\DEDUSSAX0004\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX_BATCH2\bin\XPPIL',
'\\DEDUSSAX0005\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX_BATCH1\bin\XPPIL',
'\\DEDUSSAX0005\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX_BATCH2\bin\XppIL',
'\\DEDUSSAX0020\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX\bin\XppIL',
'\\DEDUSSAX0021\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX\bin\XppIL',
'\\DEMEESAX0014\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX\bin\XppIL',
'\\DEMEESAX0015\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX\bin\XppIL',
'\\DEMEESAX0016\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX\bin\XppIL',
'\\DEMEESAX0017\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX\bin\XppIL',
'\\Dedussax0021\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX\bin\XppIL',
'\\DEMEESAX0018\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX\bin\XppIL',
'\\DEMEESAX0070\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX_BATCH5\bin\XppIL',
'\\DEMEESAX0071\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX_BATCH3\bin\XppIL',
'\\DEMEESAX0072\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX_BATCH4\bin\XppIL',
'\\DEMEESAX0084\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX\bin\XppIL',
'\\DEMEESAX0099\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX\bin\XppIL',
'\\DEMEESAX0099\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX_BATCH\bin\XppIL',
'\\DEMEESAX0100\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX\bin\XppIL',
'\\DEMEESAX0100\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX_BATCH\bin\XppIL',
'\\DEMEESAX0102\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PREPROD_DYNAX_02\bin\XppIL',
'\\DEMEESAX0103\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX\bin\XppIL',
'\\DEMEESAX0104\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX\bin\XppIL',
'\\DEMEESAX0105\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX\bin\XppIL',
'\\DEMEESAX0116\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX_DAW\bin\XppIL',
'\\DEMEESAX0116\d$\Program Files\Microsoft Dynamics AX\60\Server\EMEA_102_PROD_DYNAX_WCF\bin\XppIL')


function ValidateXPPIL($AXFSPAth = $AXFSPAth)
{
    foreach ($item in $AXFSPAth)
    {
        if(Test-Path -Path $item)
        {
            Write-Host "Path is Available - $item" -ForegroundColor Yellow
        }
        else
        {
            Write-Host "Path is not Available - $item" -ForegroundColor Red
        }
    }
}

function RenameXPPIL($AXFSPAth = $AXFSPAth)
{
    foreach ($item in $AXFSPAth)
    {
        if(Test-Path -Path $item)
        {
            Write-Host "Path is Available - $item" -ForegroundColor Red
            Rename-Item -Path $item -NewName XPPIL20220129
            Write-Host "Path Is renamed to  - $item - XPPIL20220129" -ForegroundColor Red
        }
        else
        {
            Write-Host "Path is not Available - $item" -ForegroundColor Yellow
        }
    }
}

function DeleteXPPIL($AXFSPAth = $AXFSPAth)
{
    foreach ($item in $AXFSPAth)
    {
        $FolderDelete = 'XPPIL20220129'
        $item =$item.ToString().Replace('XPPIL',$FolderDelete)
        if(Test-Path -Path $item)
        {
            Write-Host "Path is Available - $item" -ForegroundColor Red
            #Rename-Item -Path $item -NewName XPPIL20220129
            Write-Host "Path Is renamed to  - $item - XPPIL20220129" -ForegroundColor Red
        }
        else
        {
            Write-Host "Path is not Available - $item" -ForegroundColor Yellow
        }
    }
}