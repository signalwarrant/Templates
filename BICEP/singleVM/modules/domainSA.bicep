@minLength(3)
@maxLength(11)
@description('Prefix that the storage account begins with')
param storagePrefix string

@allowed([
  'Standard_LRS'
  'Premium_LRS'
])
@description('Storage Account SKU')
param storageSKU string = 'Standard_LRS'

@description('Resource Group location, defaults to the parent RG')
param location string = resourceGroup().location

// Creating a globally unique storage account name
var uniqueStorageName = '${storagePrefix}${uniqueString(resourceGroup().id)}'

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

output storageEndpoint string = domainSA.properties.primaryEndpoints.blob
