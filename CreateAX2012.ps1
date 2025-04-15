<#
    Owner SenthilRaj 20-May-2019
    Purpose Creating Dynamics 365 VM using Source as template 

#>
$VMName = Read-Host "Please Enter the VM Name"
#Note: Provide the local path name
$childPath = “D:\DAXFO_DevBOX\$VMName\$VMName.vhdx”
#Note: Provide the Templte path name
$parentPath = "D:\Template\OS_TEMP.vhdx"
New-VHD –Path $childPath –ParentPath $parentPath –Differencing
Write-Host "The Differencing Hard Disk is Created Successfully!!!"
New-VM -Name $VMName #-DynamicMemoryEnabled $false 

Write-Host "The New VM is Deployed Successfully!!!"
Add-VMHardDiskDrive -vmname $VMName -Path $childPath 
Set-VM -Name $VMName -ProcessorCount 4 -MemoryStartupBytes 10000MB -CheckpointType Disabled
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $false
#Add-VMNetworkAdapter -Name $VMName -SwitchName 'Default Switch'
Write-Host "The Differencing drive is attached Successfully!!!"
Start-VM $VMName
pause 

#Run the below command to update the servre name.

<#exec sp_dropserver @@serverName
Go
exec sp_addserver 'Test1', local
Go
Select @@servername#>