param storageAccountName string
param location string = resourceGroup().location
param skuName string
param utcValue string = utcNow()

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

resource runAzureCLIInline 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'runAzureCLIInline'
  location: location
  kind: 'AzureCLI'
  properties: {
    forceUpdateTag: utcValue
    azCliVersion: '2.43.0'
    timeout: 'PT10M'
    arguments: ''
    scriptContent: '''
      az storage blob service-properties update --account-name ashearinresumeproject --static-website true --404-document 404.html --index-document index.html
      az storage blob upload-batch --account-name ashearinresumeproject -d '$web' -s frontend/
      '''
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'PT1H'
  }
  dependsOn: [
    storageAccount
  ]
}
