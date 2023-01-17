param location string
param cosmosName string
param cosmosDbName string
param keyvaultName string

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  name: cosmosName
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    publicNetworkAccess: 'Enabled'
    enableFreeTier: true
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
      maxIntervalInSeconds: 5
      maxStalenessPrefix: 100
    }
  }
}

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-08-15' = {
  name: '${cosmosAccount.name}/${cosmosDbName}'
  properties: {
    resource: {
      id: cosmosDbName
    }
  }
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-08-15' = {
  name: '${cosmosDb.name}/counter'
  properties: {
    resource: {
      id: 'counter'
      partitionKey: {
        paths: [
          '/id'
        ]
      }
    }
  }
}

module cosmosKeyVaultSecretPrimaryConnectionString '../modules/KeyVaultSecret.bicep' = {
  name: 'cosmosKeyVaultSecretPrimaryConnectionString'
  params: {
    keyvaultName: keyvaultName
    secretName: '${cosmosAccount.name}-PrimaryConnectionString'
    secretValue: listConnectionStrings(resourceId('Microsoft.DocumentDB/databaseAccounts', cosmosAccount.name), '2020-04-01').connectionStrings[0].connectionString
  }
}
