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

// resource stg 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
//   name: storageAccountName
// }

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyvaultName
}

// resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
//   name: functionAppName
//   location: location
//   kind: 'functionapp,linux'
//   identity: {
//     type: 'SystemAssigned'
//   }
//   properties: {
//     serverFarmId: hostingPlan.id
//     siteConfig: {
//       appSettings: [
//         {
//           name: 'AzureWebJobsStorage'
//           value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${stg.listKeys().keys[0].value}'
//         }
//         {
//           name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
//           value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${stg.listKeys().keys[0].value}'
//         }
//         {
//           name: 'WEBSITE_CONTENTSHARE'
//           value: toLower(functionAppName)
//         }
//         {
//           name: 'FUNCTIONS_EXTENSION_VERSION'
//           value: '~4'
//         }
//         {
//           name: 'FUNCTIONS_WORKER_RUNTIME'
//           value: functionWorkerRuntime
//         }
//       ]
//       cors: {
//         allowedOrigins: [
//             '*'
//         ]
//       }
//       ftpsState: 'FtpsOnly'
//       minTlsVersion: '1.2'
//       linuxFxVersion: linuxFxVersion
//       use32BitWorkerProcess: false
//     }
//     httpsOnly: true
//     clientAffinityEnabled: false
//   }
// }

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

// module function '../modules/functionCounter.bicep' = {
//   name: 'deployFunction'
//   dependsOn: [
//     functionApp
//   ]
//   params: {
//     AzureResumeConnectionString: kv.getSecret('cosmos-counter-PrimaryConnectionString')
//     fncAppName: functionAppName
//   }
// }
