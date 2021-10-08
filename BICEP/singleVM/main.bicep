@description('This is the name for the VM you will see in the Azure portal')
param vmName string = 'DC' 

@description('The resource group where the resource will be created, in my case the parent RG')
param location string = resourceGroup().location

@description('The default vmSize, this can be changed to any permitted VM size')
param vmSize string = 'Standard_A2_v2'

@description('This can be different than the vmName. Computername is the value inside the VM OS.')
param computerName string = 'DC'

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
          id: nicModule.outputs.nicID
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: storageModule.outputs.storageEndpoint
      }
    }
  }
}

module storageModule 'modules/domainSA.bicep' = {
  name: 'storageDeploy'
  params: {
    storagePrefix: 'sig'
  }
}

module nicModule 'modules/nic.bicep' = {
  name: 'nicDeploy'
  params: {
    vmName: vmName
  }
}

module vNetModule 'modules/vNet.bicep' = {
  name: 'vNetDeploy'
  params: {
    vmName: vmName
    addressSpace: addressSpace
    vnetSubnet: vnetSubnet
  }
}

module pipModule 'modules/PIP.bicep' = {
  name: 'pipDeploy'
  params: {
    vmName: vmName
  }
}

resource mdeAgent 'Microsoft.Compute/virtualMachines/extensions@2021-04-01' = {
  name: 'mdeAgent'
  location: location
  parent: DC
  properties: {
    publisher: 'Microsoft.Azure.AzureDefenderForServers'
    type: 'MDE.Windows'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
}

// Outputs from this template that will be passed to other templates
output vmName string = vmName
output addressSpace string = addressSpace
output vnetSubnet string = vnetSubnet
