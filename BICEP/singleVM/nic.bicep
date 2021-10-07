@description('Value passed from main.bicep for NIC naming purposes')
param vmName string 

@description('Resource Group location, defaults to the parent RG')
param location string = resourceGroup().location

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

output nicID string = vmNIC.id
