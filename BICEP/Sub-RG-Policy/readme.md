## A demonstration of how to target different scopes in Bicep deployments

### Subscription Scope

At the top of main.bicep file you will see ```targetScope = 'subscription'``` indicating this deployment will be targeted to the **Subscription** scope. We deploy a sample **policy** and create a **resource group** at the **Subscription** scope.

### Resource Group Scope
Further down in the main.bicep you will see a **virtualNetwork** module referenced. This particular resource is deployed at the **resource group** scope as indicated by ```scope: resourceGroup``` in the code. The actual code for the vNet is in modules/vNet.bicep.

```
module virtualNetwork 'modules/vNet.bicep' = {
  scope: resourceGroup
  name: 'virtualNetwork'
  params: {
    virtualNetworkName: virtualNetworkName
    virtualNetworkAddressPrefix: virtualNetworkAddressPrefix
    subnetAddress: subnetAddress
  }
}
```