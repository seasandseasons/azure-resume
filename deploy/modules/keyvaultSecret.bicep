param keyvaultName string
param secretName string

@secure()
param secretValue string

resource keyvaultSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: '${keyvaultName}/${secretName}' 
  properties: {
    value: secretValue
  }
}

output keyvaultSecretName string = keyvaultSecret.name
