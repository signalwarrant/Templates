
# Source: https://www.powershellbros.com/powershell-function-create-azure-storage-account/
function New-AzureStorageAccount {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "Resource group name", ValueFromPipeline = $false)] 
        $ResourceGroupName = 'Signalwarrant-Domain',
        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "Location name", ValueFromPipeline = $false)] 
        [ValidateSet("centralus", "eastus", "eastus2", "westus", "northcentralus", "southcentralus", "westcentralus", "westus2")]
        $Location = 'eastus',
        [Parameter(Position = 2, Mandatory = $true, HelpMessage = "SKU name", ValueFromPipeline = $false)] 
        [ValidateSet("Standard_LRS", "Standard_GRS", "Standard_ZRS", "Premium_LRS", "Standard_RAGRS")]
        $SkuName = 'Standard_LRS',
        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Prefix for storage account name", ValueFromPipeline = $false)] 
        $sa = 'signalwarrantdomainsa'
    )
             
    If (!(Get-AzContext)) {
        Write-Host "Please login to your Azure account"
        Login-AzureRmAccount
    }
 
    try {
        Get-AzResourceGroup $ResourceGroupName
    }
    catch {
        $exc = $_.Exception.Message
        $CreateNewResourceGroup = Read-Host "Resource Group $ResourceGroupName does not exist. Do you want to create it?(Y/N)"
        if ($CreateNewResourceGroup -eq "Y") {
            New-AzResourceGroup -Name $ResourceGroupName -Location $Location
            Wrtie-Host "Resource group $ResourceGroupName has been created."
        }
        else {
            Write-Host "Creation of new storage account will be stopped!"
            break
        }
    }
     
    do {
        $Availability = Get-AzStorageAccountNameAvailability -Name $sa
    }
    while ($Availability.NameAvailable -eq $false)
    
    try {
        New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $SAName -Location $Location -SkuName $SkuName
        Write-Host "Storage account $SAName created"
    }
    catch {
        $Exc = $_.Exception.Message
        Write-Error "Unexpected error occured during storage account creation. Error: $Exc"
    }
     
     
}