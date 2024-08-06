Install-Module -Name ImportExcel
Import-Module ImportExcel
$excelDate = Import-Excel -Path "C:\Users\senraj117\Desktop\Migration Input File_Arras.xlsx" -WorksheetName MetaData 
foreach($item in $excelDate)
{
     Write-Host $item.'CGI - FILEINFO WAS MISSING - USED APPROXIMATE DOC NAME' + "-" + $item.'CGI - MATCHING IN LIST ? -- ACTUAL FILE NAMES !!!'  $item.'Department (M)'
}

