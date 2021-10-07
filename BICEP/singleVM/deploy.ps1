$templateFile = 'main.bicep'
$location = 'eastus'
$resourceGroupName = 'SignalWarrant-Domain'
$today = Get-Date -Format 'MM-dd-yyyy'
$deploymentName = "singleVM-$today"
$myIP = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content




$swRG = Get-AzResourceGroup | Where-Object {$_.ResourceGroupName -eq $resourceGroupName}
if (!$swRG) {
  New-AzResourceGroup -Name $resourceGroupName -Location $location
}

#Write-Host -ForegroundColor Green "Testing Deployment File`n`n"
#Test-AzResourceGroupDeployment -TemplateFile $templateFile -ResourceGroupName $resourceGroupName -Verbose

Write-Host -ForegroundColor Green "`n Deployment beginning...`n"

New-AzResourceGroupDeployment -TemplateFile $templateFile -Name $deploymentName -ResourceGroupName $resourceGroupName -Verbose

Write-Host -ForegroundColor Cyan "Mission Compelte!!"


