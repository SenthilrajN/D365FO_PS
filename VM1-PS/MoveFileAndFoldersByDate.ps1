<#

    Created By :  Senthil Raj 
    Purpose    :  Moving the Files & Folder based on Date & Time
    Created Date: 08-Aug-2022
     
#>

function MoveFilesFoldersByDate($SourcePath,$DestinationPath,$NoOfMin)
{
    Write-Host "Moving the Files & Folders From $SourcePath to $DestinationPath for lessthen < $NoOfDays of AddMinutes "

    
    $collection = Get-ChildItem -Path $SourcePath -Recurse -Directory | Where-Object {$_.LastWriteTime -lt (Get-date).AddMinutes(-$NoOfMin)}
    foreach ($item in $collection)
    {
        $folderName = $item.Name
        if(Test-Path -Path $DestinationPath\$foldername)
        {
             Write-Host "Folder Already Exist!!"    
        }
        else
        {
            New-Item -Path $DestinationPath\$foldername -ItemType Directory
        }
    }
    #To move Files

    $collection1 = Get-ChildItem -Path $SourcePath -Recurse -File | Where-Object {$_.LastWriteTime -lt (Get-date).AddMinutes(-$NoOfMin)}

    foreach ($item in $collection1)
    {
        $FileName = $item.FullName.Replace($SourcePath,$DestinationPath)
 
        if(Test-Path -Path $FileName)
        {
             Write-Host "Folder Already Exist!!"    
        }
        else
        {
            Move-Item -Path $item.FullName -Destination $FileName
        }
    }

    
}

MoveFilesFoldersByDate -SourcePath "C:\CGI_TS" -DestinationPath C:\CGI_TS1 -NoOfMin 4