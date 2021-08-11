## This template will create the following infrastructure

1. A Server 2019 Domain Controller
   - No users or groups are created, it's a blank slate
2. X number of Server 2019 Member Servers joined to the domain
3. X number of Windows 10 Clients also joined to the domain
4. A bastion host to access the VMs, NO RDP ALLOWED HERE!!!

## Prerequisites

1. Create your resource group before running the template
   - I should also automate this as well 
## Usage

1. Create a password to pass into the template

```Powershell
$pass = '$uper$ecretPass123' | ConvertTo-SecureString -AsPlainText -force
```

2. Validate the deployment template

```Powershell
$pass = '' | ConvertTo-SecureString -AsPlainText -force
Test-AzResourceGroupDeployment -ResourceGroupName Signalwarrant-Domain -TemplateFile '.\ADForest-deploy.json' -adminUsername 'chief' -adminPassword $pass -Verbose
```

3. Run the command to kick off the template

```Powershell
New-AzResourceGroupDeployment -Name SignalWarrantDomain -ResourceGroupName Signalwarrant-Domain -TemplateFile '.\ADForest-deploy.json' -adminUsername 'chief' -adminPassword $pass -Verbose
```