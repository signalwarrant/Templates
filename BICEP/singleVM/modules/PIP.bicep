@description('Value passed from main.bicep for NIC naming purposes')
param vmName string 

@description('Resource Group location, defaults to the parent RG')
param location string = resourceGroup().location

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: '${vmName}-PIP'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'

  }
}
