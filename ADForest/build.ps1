

# Resource Group Info
$rgName = 'Signalwarrant-Domain'
$rg = Get-AzResourceGroup -Name $rgName -ErrorAction SilentlyContinue
$location = 'eastus'
# Storage Account Info
$sa = 'signalwarrantdomainsa'
$testSa = Get-AzStorageAccountNameAvailability -Name $sa
$sku = 'Standard_LRS'
$kind = 'StorageV2'
$containerName = 'armfiles'

# Local Files to upload
$localFiles = 'C:\scripts\ARM'

# Directories to Create
$dirs = @("DSC", "nestedtemplates")

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

# Check for Blob Container
$container = Get-AzRmStorageContainer -ResourceGroupName $newRG.ResourceGroupName -StorageAccountName $newSA.StorageAccountName -Name $containerName -ErrorAction SilentlyContinue
# Build the Container in the Storage Account that will house the nested templates files and DSC files
if (!$container) {
    # Create a container in the SA to hold the nested templates and the DSC files
    $container = New-AzRmStorageContainer -ResourceGroupName $newRG.ResourceGroupName -StorageAccountName $newSA.StorageAccountName -Name $containerName
    $sasToken = New-AzStorageContainerSASToken -Name "TemplateFiles" -Context $newSA.Context -Permission rl -Protocol HttpsOnly -FullUri
    Write-Host -ForegroundColor Green "Container:" $container.Name "created successfully"
} else {
    Write-Host -ForegroundColor Red "Container:" $container.Name "already exists"
    $container = Get-AzRmStorageContainer -ResourceGroupName $newRG.ResourceGroupName -StorageAccountName $newSA.StorageAccountName -Name $containerName
    $sastoken = New-AzStorageContainerSASToken -Name "TemplateFiles" -Context $newSA.Context -Permission rl -Protocol HttpsOnly -FullUri
}

$sasToken
<#
# Make 2 Directories in the Fileshare
if ($container){
    # Create storage directories
    # ---- TODO 
    # Add another If statement to check for directory existence before running foreach statement. 
    # ---- TODO 
    foreach ($dir in $dirs) {
        $newDir = New-AzStorageDirectory -Context $newSA.Context -ShareName $container.Name -Path $dir 
        Write-Host -ForegroundColor Green "Directory:" $newDir.Name "created successfully"   
    }
} 

#>