@description('The name of the function app that you wish to create.')
param appName string = 'fnapp-resume-${uniqueString(resourceGroup().id)}'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The language worker runtime to load in the function app.')
@allowed([
  'node'
  'dotnet'
  'java'
  'python'
])
param runtime string = 'python'
param linuxFxVersion string
param storageAccountName string
param keyvaultName string

var functionAppName = appName
var hostingPlanName = appName
var functionWorkerRuntime = runtime

resource hostingPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: hostingPlanName
  location: location
  kind: 'linux'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {
    reserved: true
    maximumElasticWorkerCount: 1
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyvaultName
}

module functionApp '../modules/functionApp.bicep' = {
  name: 'deployFunctionApp'
  params: {
    location: location
    fncAppName: functionAppName
    hostingPlanId: hostingPlan.id
    storageAccountName: storageAccountName
    fncWorkerRuntime: functionWorkerRuntime
    linuxFxVersion: linuxFxVersion
    AzureResumeConnectionString: kv.getSecret('cosmos-counter-PrimaryConnectionString')
  }
}
