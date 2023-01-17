param storageAccountName string
param skuName string
param location string
param keyvaultName string
param tenantId string
param enabledForDeployment bool
param enabledForTemplateDeployment bool
param enabledForDiskEncryption bool
param enabledRbacAuthorization bool
param accessPolicies array
param publicNetworkAccess string
param enableSoftDelete bool
param softDeleteRetentionInDays int
param networkAcls object

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

// Deploy key vault using module
module kv 'modules/keyvault.bicep' = {
  name: keyvaultName
  scope: rg
  params: {
    location: location
    accessPolicies: accessPolicies
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enabledRbacAuthorization: enabledRbacAuthorization
    enableSoftDelete: enableSoftDelete
    keyvaultName: keyvaultName
    networkAcls: networkAcls
    publicNetworkAccess: publicNetworkAccess
    softDeleteRetentionInDays: softDeleteRetentionInDays
    tenantId: tenantId
  }
}
