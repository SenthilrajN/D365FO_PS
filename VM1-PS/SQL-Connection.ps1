<#
SQL Connection Template
#>

#Function to execute the query 
Function SQLConnection([string]$query,[string]$environment)
{
    switch ($environment)
    {
        'SBX2' 
        {
                $serverName = 'DTXTESTSQL02\INST2'
                $SQLDB= 'AOS_SB'
               
        }
        'SBX1'
        {
                $serverName = 'DTXTESTSQL02\INST1'
                $SQLDB= 'MicrosoftDynamicsAX'
        }
        'Param' 
        {
                $serverName = 'DTXTESTSQL02\INST2'
                $SQLDB= 'ACA_Toolkit'
               
        }
        
    }
   
    Invoke-sqlcmd -ServerInstance $serverName -Database $SQLDB -Query $query
}


##Function To Backup the parameter table
Function BackupParamTable($SourceDB,$DestinationDB,$envi)
{
    $i = 0
    SQLConnection -query "ALTER DATABASE $DestinationDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE" -environment $envi
    SQLConnection -query "DROP DATABASE $DestinationDB" -environment $envi
    SQLConnection -query "CREATE DATABASE $DestinationDB" -environment $envi

    $res = SQLConnection -query "select TABLENAME from ConfigParameter WHERE EXPORTENABLE='Y'" -environment 'Param'
    FOREACH($r in $res)
    {
        $i++
        $TableName = $r.TableName
        SQLConnection -query "Select * into $DestinationDB.dbo.$TableName from $SourceDB.dbo.$TableName" -environment $envi
        Write-Host $i. $TableName
    }
    Write-Host "Backup Parameter table is completed from $SourceDB to $DestinationDB on $envi"
}