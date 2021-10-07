@description('Value passed from main.bicep for NIC naming purposes')
param vmName string 

@description('Resource Group location, defaults to the parent RG')
param location string = resourceGroup().location

@description('The address space allocated for the virtual network')
param addressSpace string

@description('Subnet(s) for the Virtual Network')
param vnetSubnet string 

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

output vNetName string = vmVNET.name
