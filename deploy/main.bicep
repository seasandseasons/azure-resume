param storageAccountName string
param skuName string
param location string

// Setting target scope
targetScope = 'subscription'

// Create resource group
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-azureResume'
  location: location
}

// Deploy storage account using module
module stg 'modules/storage.bicep' = {
  name: 'storageDeployment'
  scope: rg    // Deployed in the scope of resource group we created above
  params: {
    storageAccountName: storageAccountName
    skuName: skuName
    location: location
  }
}
