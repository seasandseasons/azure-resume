@secure()
param AzureResumeConnectionString string

param fncAppName string

resource functionCounter 'Microsoft.Web/sites/functions@2022-03-01' = {
  name: '${fncAppName}/${'functionResumeCounter'}'
  properties: {
    config: {
      bindings: [
        {
          name: 'req'
          authLevel: 'function'
          type: 'httpTrigger'
          direction: 'in'
          methods: [
            'get'
            'post'
          ]
          route: 'counter/list'
        }
        {
          name: '$return'
          type: 'http'
          direction: 'out'
        }
        {
          name: 'doc'
          type: 'cosmosDB'
          databaseName: 'azure-resume'
          collectionName: 'counter'
          connectionStringSetting: AzureResumeConnectionString
        
          direction: 'in'
          sqlQuery: 'SELECT * from c'
        }
        {
          name: 'out'
          type: 'cosmosDB'
          databaseName: 'azure-resume'
          collectionName: 'counter'
          connectionStringSetting: AzureResumeConnectionString
          direction: 'out'
        }
      ]
    }
    files: {
      '__init__.py': loadTextContent('__init__.py')
      }
    }
  }
