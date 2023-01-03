param storageAccountName string
param location string = resourceGroup().location
param skuName string
param utcValue string = utcNow()

var userAssignedIdentityName = 'configDeployer'
var roleAssignmentName = guid(resourceGroup().id, 'contributor')
var contributorRoleDefinitionId = resourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')

// Deploy Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: skuName
  }
  properties: {
    allowBlobPublicAccess: false
  }
}

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userAssignedIdentityName
  location: location
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentName
  properties: {
    roleDefinitionId: contributorRoleDefinitionId
    principalId: userAssignedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource runAzureCLIInline 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'runAzureCLIInline'
  location: location
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentity.id}': {}
    }
  }
  properties: {
    forceUpdateTag: utcValue
    azCliVersion: '2.42.0'
    timeout: 'PT10M'
    arguments: ''
    scriptContent: '''
      az login
      az storage blob service-properties update --account-name ashearinresumeproject --static-website true --404-document 404.html --index-document index.html
      az storage blob upload-batch --account-name ashearinresumeproject -d '$web' -s frontend/
      '''
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'PT1H'
  }
  dependsOn: [
    roleAssignment
    storageAccount
  ]
}
