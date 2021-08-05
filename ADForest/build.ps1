# Resource Group Info
$rg = Get-AzResourceGroup -Name Signalwarrant-Domain -ErrorAction SilentlyContinue
$location = 'eastus'
# Storage Account Info
$sa = 'signalwarrantdomainsa'
$testSa = Get-AzStorageAccountNameAvailability -Name $sa
$sku = 'Standard_LRS'
$kind = 'StorageV2'
$shareName = 'armfiles'
$sharePath = 'files'

if (!$rg) {
    New-AzResourceGroup -Name SignalWarrant-Domain -Location $location
} else {
    Write-Host -ForegroundColor red $rg.ResourceGroupName "already exists"  
}

if ($testSa.NameAvailable -eq $true) {
    $newSA = New-AzStorageAccount -Name $sa -ResourceGroupName $rg.ResourceGroupName -Location $location -SkuName $sku -Kind $kind -ErrorAction SilentlyContinue
} else {
    Write-Host -ForegroundColor Red $newSA.StorageAccountName "already exists"
}

if ($newSA.StorageAccountName) {
    # Create a fileshare in the SA to hold the nested templates and the DSC files
    $share = New-AzStorageDirectory -ShareName $shareName -Context $newSA.Context -Path $sharePath -ErrorAction SilentlyContinue
} else {
    Write-Host -ForegroundColor Red $share.Name "already exists"
}
 