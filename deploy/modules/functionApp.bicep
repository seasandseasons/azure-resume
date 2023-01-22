param fncAppName string
param location string

@secure()
param hostingPlanId string

param storageAccountName string
param fncWorkerRuntime string
param linuxFxVersion string

@secure()
param AzureResumeConnectionString string

resource stg 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName
}

resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: fncAppName
  location: location
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: hostingPlanId
    siteConfig: {
      appSettings: [
        // {
        //   name: 'WEBSITE_RUN_FROM_PACKAGE'
        //   value: 'https://ashearinresumeproject.blob.core.windows.net/functions/functionCounter.zip'
        // }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${stg.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${stg.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(fncAppName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: fncWorkerRuntime
        }
        {
          name: 'AzureResumeConnectionString'
          value: AzureResumeConnectionString
        }
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true'
        }
        {
          name: 'ENABLE_ORYX_BUILD'
          value: 'true'
        }
      ]
      cors: {
        allowedOrigins: [
            '*'
        ]
      }
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
      linuxFxVersion: linuxFxVersion
      use32BitWorkerProcess: false
    }
    httpsOnly: true
    clientAffinityEnabled: false
  }
}
