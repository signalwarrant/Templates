# ARM Template: New AD Forest (Single DC, Multiple VMs)

## Prerequisites

1. Upload the CreateADPDC.zip file to Github.
2. Upload the templates in the nestedtemplates folder to Github (SVR2012.json, SVR2016.json, SVR2019.json)
3. Create a Shared Access Signature to access the file share (edit the value of the sasToken parameter).
4. Provide a value for the domainName parameter.
5. Provide a value for the filePath parmeter to coorespond to the path of your fileshare created in Step 1.
6. Provide a value for the adminPassword parameter.
7. If you're deploying to Azure Government you'll need to change the default value of the azurePlatform parameter, otherwise the default is fine for Azure Commercial.
8. Create a resource group in Azure.


## Note: The Automatic Guest OS Patch features does not currently work with smalldisk images. 
----------------------------

## Overview

This template will deploy 1 Windows Server 2019 (by Default) Domain controller and set the DNS server on the VNet to the IP of the Domain Controller to facilitate easily adding more VMs. You can create X number of Windows Server 2019 Member Servers, X number of Windows Server 2016 Member Servers, X number of Windows Server 2012 R2 Member Servers, and X number of Windows 10 1909 Clients. All of the members servers and clients will be added to the same vNET of the DC and added to the Domain defined in the domainName parameter.

----------------------

## Deployment Options

This template can be used in Azure Commercial or Azure Government with a some slight changes to a few parameters. In it's default form it's suited for Azure Commercial. To use the template in Azure Government follow the instructions below. **NOTE: You only need to change clouds if you're deploying to Azure Government, generally the default should be Azure Commercial.**

### Azure CLI

Open and elevated CMD prompt to access the Azure CLI.

#### List the available clouds

```
az cloud list --output table
```

#### Example output of the command above

| IsActive | Name              | Profile |
|----------|-------------------|---------|
| True     | AzureCloud        | latest  |
| False    | AzureChinaCloud   | latest  |
| False    | AzureUSGovernment | latest  |

#### Change to Azure Government if applicable

```
az cloud set --name AzureCloud
```

#### Login

```
az login
```

#### Validate the template using the command below.

```
az deployment group validate --resource-group your-RG --template-file c:\templates\ADForest-deploy.json
```

#### Deploy the template using the command below.

```
az deployment group create --name TestLab --resource-group your-RG --template-file c:\templates\ADForest-deploy.json --verbose
```

------------------------------------

### PowerShell

The new(er) Az module is required to run the commands below.

#### Validate the template using the command below.

```PowerShell
Test-AzResourceGroupDeployment -ResourceGroupName testRG -TemplateFile 'C:\templates\ADForest-deploy.json' -Verbose
```

#### Deploy the template using the command below.

```PowerShell
New-AzResourceGroupDeployment -Name TestLab -ResourceGroupName your-RG -TemplateFile 'c:\Templates\ADForest-deploy.json'
```
