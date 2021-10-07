$resourceGroupName = 'learndeploymentscript_exercise_2'
$templateFile = 'main.bicep'
$templateParameterFile = 'azuredeploy.parameters.json'
$today = Get-Date -Format 'MM-dd-yyyy'
$deploymentName = "deploymentscript-$today"

New-AzResourceGroupDeployment `
    -ResourceGroupName $resourceGroupName `
    -Name $deploymentName `
    -TemplateFile $templateFile `
    -TemplateParameterFile $templateParameterFile -Verbose


    $storageAccountName = (Get-AzResourceGroupDeployment -ResourceGroupName 'learndeploymentscript_exercise_2' -Name $deploymentName).Outputs.storageAccountName.Value
    $storageAccount = Get-AzStorageAccount -ResourceGroupName 'learndeploymentscript_exercise_2'
    Get-AzStorageBlob -Context $storageAccount.Context -Container config |
        Select-Object Name