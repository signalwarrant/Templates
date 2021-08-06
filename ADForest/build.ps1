

# Resource Group Info
$rgName = 'Signalwarrant-Domain'
$rg = Get-AzResourceGroup -Name $rgName -ErrorAction SilentlyContinue
$location = 'eastus'
# Storage Account Info
$sa = 'signalwarrantdomainsa'
$testSa = Get-AzStorageAccountNameAvailability -Name $sa
$sku = 'Standard_LRS'
$kind = 'StorageV2'
$fileShareName = 'armfiles'

# Local Files to upload
$localFiles = 'C:\scripts\ARM'

# Build the Resource Group 
if (!$rg) {
    $newRG = New-AzResourceGroup -Name SignalWarrant-Domain -Location $location -ErrorAction SilentlyContinue
    Write-Host -ForegroundColor Green "Resource Group:" $newRG.ResourceGroupName "created successfully"
} else {
    Write-Host -ForegroundColor red "Resource Group:" $rg.ResourceGroupName "already exists"
    $newRG = Get-AzResourceGroup -Name $rgName -ErrorAction SilentlyContinue  
}

# Build the Storage Account and File Share
if ($testSa.NameAvailable -eq $true) {
    $newSA = New-AzStorageAccount -Name $sa -ResourceGroupName $newRG.ResourceGroupName -Location $location -SkuName $sku -Kind $kind -ErrorAction SilentlyContinue
    Write-Host -ForegroundColor Green "Storage Account:" $newSA.StorageAccountName "created successfully"
} else {
    Write-Host -ForegroundColor Red "Storage Account:" $sa "already exists"
    $newSA = Get-AzStorageAccount -ResourceGroupName $rg.ResourceGroupName -Name $sa
}

# Check for Fileshare
$filesShare = Get-AzRmStorageShare -ResourceGroupName $newRG.ResourceGroupName -StorageAccountName $newSA.StorageAccountName 
# Build the Fileshare in the Storage Account that will house the nested templates files and DSC files
if (!$filesShare) {
    # Create a fileshare in the SA to hold the nested templates and the DSC files
    $share = New-AzRmStorageShare -ResourceGroupName $newRG.ResourceGroupName -StorageAccountName $newSA.StorageAccountName -Name $fileShareName
    Write-Host -ForegroundColor Green "Fileshare:" $share.Name "created successfully"
} else {
    Write-Host -ForegroundColor Red "Fileshare:" $filesShare.Name "already exists"
    $share = Get-AzRmStorageShare -ResourceGroupName $newRG.ResourceGroupName -StorageAccountName $newSA.StorageAccountName  
}

# Copy files to the file share
if ($Share){
    Set-AzStorageFileContent -Context $newSA.Context -ShareName $share.Name -Source $localFiles -Path $share.name
} else {
    Write-Host -ForegroundColor Red "File Share:" $shareName "does NOT exist"
}

# Set-AzStorageFileContent -Context $newSA.Context -ShareName $share.Name -Source $localFiles -Path $share.name
