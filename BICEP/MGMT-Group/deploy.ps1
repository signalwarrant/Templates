$templateFile = "C:\Users\Dave\OneDrive - SignalWarrant.com\_repos\Templates\BICEP\MGMT-Group\main.bicep"
$location = 'eastus'
$managementGroupId = 'SecretRND'
$today = Get-Date -Format 'MM-dd-yyyy'
$deploymentName = "Policy-RG-vNet-$today"



# Set-AzDefault -ResourceGroupName 'BicepTraining'

# Validate the deployment
#Test-AzResourceGroupDeployment -TemplateFile $template -Verbose
#cls

# Deploy the Template to a Resource Group
#New-AzResourceGroupDeployment -TemplateFile $template -Verbose

# Deploy the Template to a Subscription	
# New-AzSubscriptionDeployment `
#  -Name $deploymentName `
#  -Location $location `
#  -TemplateFile $templateFile `
#  -virtualNetworkName $virtualNetworkName `
#  -virtualNetworkAddressPrefix $virtualNetworkAddressPrefix `
#  -subnetAddress $subnetAddress -Verbose

# Deploy the Template to a Management group	

New-AzManagementGroupDeployment `
  -ManagementGroupId $managementGroupId `
  -Name $deploymentName `
  -Location $location `
  -TemplateFile $templateFile `
  -managementGroupName $managementGroupId

# Deploy the Template to a Tenant	
#New-AzTenantDeployment