## Prerequisites
  
  1. Azure Subscription (DUH)
  2. Storage Account
     1. SAS token (is there a better method for the artifacts? Maybe host them on Github then this is not a requirement)
  3. Resource Group
  4. Keyvault and Key for Azure Disk Encryption
  5. Whatever the list of Prereqs end up being I need to script these with PowerShell
     1. Create the Resource Group
     2. Create a secure storage account in the RG above (Look at daveTestSA in Azure Commercial Sub)
        1. Configure Private Links
        2. Customer Managed Encryption (https://aka.ms/storageencryptionkeys)
     3. Configure the KeyVault

``` Powershell
    New-AzResourceGroup -Name ARMLab -Location westus
    Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate -PatchMode "AutomaticByPlatform"
```

## What makes this secure?

1. Bastion host, no RDP to VMs
2. Turn on Azure Disk Encryption
3. MAYBE - Enabled automatic updates (preview functionality)
4. MAYBE - Private endpoint for Storage account (e.g. https://github.com/Azure/azure-quickstart-templates/tree/master/201-blob-storage-private-endpoint)

## What makes it cheap?

1. Spot Instance VMs
2. Small Disk Sizes for Server OS
