<#
    Created BY : Senthil 
    Created Date: 09-Mar-2022
    SQL Connection Template
#>

#Function to execute the query 
Function SQLConnection([string]$query,[string]$environment)
{
    switch ($environment)
    {
        'PROD' 
        {
                $serverName = 'DEMEESDB0194-DB\AA_HA1'
                $SQLDB= 'EMEA_102_PROD_DYNAX'               
        }
        
    }
   
    Invoke-sqlcmd -ServerInstance $serverName -Database $SQLDB -Query $query
}

function DrainUser()
{
    Write-Host "We are Drainig the PROD AX User"
    SQLConnection -query "UPDATE SYSSERVERSESSIONS SET STATUS=2 WHERE Status=1" -environment PROD
    Write-Host "Drain AX User is complted"    
}
function EnableBatch()
{
    Write-Host "Enabling the Batch Server"
    SQLConnection -query "Update SYSSERVERCONFIG Set ENABLEBATCH ='1' where SERVERID in ('01@DEDUSSAX0002','01@DEDUSSAX0004','01@DEDUSSAX0005','01@DEDUSSAX0020','01@DEDUSSAX0021','01@DEMEESAX0014','01@DEMEESAX0015','01@DEMEESAX0016','01@DEMEESAX0017','01@DEMEESAX0018','01@DEMEESAX0070','01@DEMEESAX0071','01@DEMEESAX0072','01@DEMEESAX0084','01@DEMEESAX0099','01@DEMEESAX0100','01@DEMEESAX0103','01@DEMEESAX0104','01@DEMEESAX0105','02@DEDUSSAX0002','02@DEDUSSAX0003','02@DEDUSSAX0004','02@DEDUSSAX0005','02@DEMEESAX0099','02@DEMEESAX0100','02@DEMEESAX0116','03@DEMEESAX0116')" -environment PROD
    Write-Host "Batch Server Enable"    
}
function DisableBatch()
{
    Write-Host "Disabling the Batch Server"
    SQLConnection -query "Update SYSSERVERCONFIG Set ENABLEBATCH ='1' where SERVERID in ('01@DEDUSSAX0002','01@DEDUSSAX0004','01@DEDUSSAX0005','01@DEDUSSAX0020','01@DEDUSSAX0021','01@DEMEESAX0014','01@DEMEESAX0015','01@DEMEESAX0016','01@DEMEESAX0017','01@DEMEESAX0018','01@DEMEESAX0070','01@DEMEESAX0071','01@DEMEESAX0072','01@DEMEESAX0084','01@DEMEESAX0099','01@DEMEESAX0100','01@DEMEESAX0103','01@DEMEESAX0104','01@DEMEESAX0105','02@DEDUSSAX0002','02@DEDUSSAX0003','02@DEDUSSAX0004','02@DEDUSSAX0005','02@DEMEESAX0099','02@DEMEESAX0100','02@DEMEESAX0116','03@DEMEESAX0116')" -environment PROD
    Write-Host "BatchServer Got disable"    
}

function main()
{
    Write-Host "1. Drain AX PROD User"
    Write-Host "2. Enable the PROD Batch Server"
    Write-Host "3. Disable the PROD Batch Server"
    $x = Read-Host "Enter your option "
    switch ($x)
    {
        '1' {DrainUser}
        '2' {EnableBatch}
        '3' {main}
    }

}
main