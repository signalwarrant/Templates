## Code Source: https://youtu.be/HYDNe_F3tAg 

$ErrorActionPreference = "Stop"

$connected = Get-AzContext
if (!($connected)) {
    Microsoft.PowerShell.Utility\Write-Host "You must Login..."
    Login-AzAccount
}

$subs = Get-AzSubscription
if ($subs.count -gt 1) {
    Write-Output "More than 1 Subscription. Select the subscription to use in the Out-Gridview window that has opened "
    $subtoUse = $subs | Out-GridView -Title 'Select the Subscription to use for this deployment' -PassThru
    $subscriptionId = $SubtoUse.$subscriptionId
} else {
    $subscriptionId = $connected.Subscription.Id
    Write-Host "Selecting Subscription '$subscriptionId'"
    Select-AzSubscription -Subscription $subscriptionId
}

$resourceGroupLocation = "eastus"
$resourceGroupName = "MyTestLab"
$templateFilePath = '.\ADForest-deploy.json'

$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!($resourceGroup)) {
    Write-host "Resource Group '$resourceGroupName' does not exist. To create a new resource group, please enter a location.";
    if (!($resourceGroupLocation)) {
        $resourceGroupLocation = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$resourceGroupName' in location '$resourceGroupLocation'"
    New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
} else {
    Write-Host "Using existing resource group '$resourceGroupName'"
}

# Run the template through the ttk

# Template Validation

# Template Deployment
#$templateFileName = @(".\ADForest-deploy.json", ".\ADForest-deploy.json") # these are the parameter files
foreach ($template in $templateFilePath) {
    New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name MyTestLab$i -TemplateFile $templateFilePath   
}