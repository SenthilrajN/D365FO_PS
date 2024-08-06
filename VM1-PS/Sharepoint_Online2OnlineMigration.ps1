<#
    Created By        : Senthil 
    Purpose           : To Move the Files from one SharePoint Online location to Another SharePoint Location
#>

#Install-Module pnp.powershell
#Install-Module SharePointPnPPowershellOnline
#Import-Module SharePointPnPPowershellOnline
#$cred = Get-Credential
#Add-PnPStoredCredential -Name ADM_CRM -Username $cred.UserName -Password $cred.Password 

$SourceURL = "https://crmbc013879.sharepoint.com"
$DestinationURL = "https://crmbc013879.sharepoint.com"
Write-Host "Source files list....." -ForegroundColor DarkGreen
Connect-PnPOnline -Url $SourceURL -UseWebLogin 
Get-PnPList -Identity "Lists/Documents"

$ListItems = Get-PnPListItem -List "Documents" -Fields "Title"

foreach ($item in $ListItems)
{
    Write-Host $item.DisplayName
    
}


Connect-PnPOnline -Url $DestinationURL -UseWebLogin
find-PnPFile -Folder "Shared Documents"  -Match "*.pbix" -Connection $Source_con
foreach ($File in $collection)
{
    Write-Host $File.ServerRelativeUrl
    $mysource = $File.ServerRelativeUrl
    $myDesc =  "/Shared Documents/Des2" #-join $Item.ServerRelativeUrl 
    Copy-PnPFile -SourceUrl $mysource -TargetUrl $myDesc -Force -Connection $Descnation_con
} 

$FolderItems = Get-PnPFolderItem -ItemType File -FolderSiteRelativeUrl "/sites/MSD365/Shared Documents/Research and Development/Assets/PowerBI" -Recursive 
foreach($Item in $FolderItems)
{
   #$i =  $Item[0]
  Write-Host $Item.ServerRelativeUrl "-" $Item.Name
  if($Item.Name -eq "Contoso Q2 Division Sales.pbix")
  {
        $mysource = $Item.ServerRelativeUrl
        $myDesc =  "/Shared Documents/Des2" #-join $Item.ServerRelativeUrl
        Copy-PnPFile -SourceUrl $mysource -TargetUrl $myDesc -Force
  }

}

<#
$Files = Get-ChildItem ($SourceURL + "Sites/Shared Documents")

Write-Host "Destination files list...." -ForegroundColor Green
Connect-PnPOnline -Url $DestimationURL -UseWebLogin
Get-PnPList 
<#
$SourceURL = "https://crmbc013879.sharepoint.com/sites/MSD365"
$DestimationURL = "https://crmbc013879.sharepoint.com/"

Uninstall-Module -Name SharePointPnPPowerShellOnline -AllVersions -Force
Install-Module -Name PnP.PowerShell

Connect-PnPOnline -Url $SourceURL -Credentials $cred

$Source_file = "/sites/MSD365/Shared%20Documents/Research and Development/Adventure Works Copter Camera Overview.docx"
$Destimation_file = "/sites/Shared%20Documents/Destimation/Adventure Works Copter Camera Overview.docx"

$cred = Get-Credential
#$d = Get-Credential
Connect-SPOService -Url $SourceURL -Credential $s
Connect-SPOService -Url $DestimationURL -Credential $s 
#>