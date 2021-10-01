$templateFile = "C:\Users\Dave\OneDrive - SignalWarrant.com\_repos\Templates\BICEP\Sub-RG-Policy\main.bicep"
$location = 'eastus'
$today = Get-Date -Format 'MM-dd-yyyy'
$deploymentName = "Policy-RG-vNet-$today"
$virtualNetworkName = 'PROD-vNet'
$virtualNetworkAddressPrefix = '10.0.0.0/16'
$subnetAddress = '10.0.1.0/24'


# Set-AzDefault -ResourceGroupName 'BicepTraining'

# Validate the deployment
#Test-AzResourceGroupDeployment -TemplateFile $template -Verbose
#cls

# Deploy the Template to a Resource Group
#New-AzResourceGroupDeployment -TemplateFile $template -Verbose

# Deploy the Template to a Subscription	
New-AzSubscriptionDeployment `
  -Name $deploymentName `
  -Location $location `
  -TemplateFile $templateFile `
  -virtualNetworkName $virtualNetworkName `
  -virtualNetworkAddressPrefix $virtualNetworkAddressPrefix `
  -subnetAddress $subnetAddress -Verbose

# Deploy the Template to a Management group	
#New-AzManagementGroupDeployment

# Deploy the Template to a Tenant	
#New-AzTenantDeployment