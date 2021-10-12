$templateFile = 'main.bicep'
$location = 'eastus'
$resourceGroupName = 'SignalWarrant-Domain'
$today = Get-Date -Format 'MM-dd-yyyy'
$deploymentName = "singleVM-$today"
$myIP = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content

$array = @{
  myIP = $myIP
}

$swRG = Get-AzResourceGroup | Where-Object {$_.ResourceGroupName -eq $resourceGroupName}
if (!$swRG) {
  New-AzResourceGroup -Name $resourceGroupName -Location $location
}

#Test-AzResourceGroupDeployment -TemplateFile $templateFile -ResourceGroupName $resourceGroupName -Verbose

New-AzResourceGroupDeployment -TemplateFile $templateFile -ResourceGroupName $resourceGroupName `
  -Name $deploymentName -TemplateParameterObject $array -Verbose