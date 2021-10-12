@description('This is the name for the VM you will see in the Azure portal')
param vmName string = 'DC1' 

@description('The resource group where the resource will be created, in my case the parent RG')
param location string = resourceGroup().location

@description('The default vmSize, this can be changed to any permitted VM size')
param vmSize string = 'Standard_A2_v2'

@description('This can be different than the vmName. Computername is the value inside the VM OS.')
param computerName string = 'DC'

@minLength(3)
@maxLength(11)
@description('Prefix that the storage account begins with')
param storagePrefix string = 'sig'

@allowed([
  'Standard_LRS'
  'Premium_LRS'
])
@description('Storage Account SKU')
param storageSKU string = 'Standard_LRS'

@secure()
@description('Admin username')
param adminUsername string 

@secure()
@description('Admin password')
param adminPassword string 

@description('Operating System Image SKU for the VM')
param vmSKU string = '2022-Datacenter-smalldisk'

@description('The address space allocated for the virtual network')
param addressSpace string = '10.0.0.0/16'

@description('Subnet(s) for the Virtual Network')
param vnetSubnet string = '10.0.1.0/24'

@description('The public IP address of my workstation')
param myIP string 

var uniqueStorageName = '${storagePrefix}${uniqueString(resourceGroup().id)}'

resource DC 'Microsoft.Compute/virtualMachines@2021-04-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: computerName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        patchSettings: {
          enableHotpatching: false
          patchMode: 'AutomaticByOS'
        }
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: vmSKU
        version: 'latest'
      }
      osDisk: {
        name: '${vmName}-OSDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vmNIC.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: domainSA.properties.primaryEndpoints.blob
      }
    }
  }
}

resource domainSA 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: uniqueStorageName
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

resource vmNIC 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: '${vmName}-IPConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId('Microsoft.Network/publicIPAddresses', '${vmName}-PIP')
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', '${vmName}-vNet', '${vmName}-Subnet1')
          }
        }
      }
    ]
  }
}

resource vmVNET 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: '${vmName}-vNet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpace
      ]
    }
    subnets: [
      {
        name: '${vmName}-Subnet1'
        properties: {
          addressPrefix: vnetSubnet
        }
      }
    ]
  }
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: '${vmName}-PIP'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'

  }
}

resource vmNSG 'Microsoft.Network/networkSecurityGroups@2018-08-01' = {
  name: '${vmName}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: '${vmName}-allowRDP'
        properties: {
          description: 'description'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: myIP
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

