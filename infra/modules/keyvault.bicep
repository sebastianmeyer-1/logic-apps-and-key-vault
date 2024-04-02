param location string
param principalId string
param environment string

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: uniqueString('kv-', environment)
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enableRbacAuthorization: true
  }
}

// Add Reader RoleDefinition for Logic App Standard to allow retrieve Secrets
//
// Key Vault Secrets User 
var roleDefinitionId = '4633458b-17de-408a-b874-0445c86b69e6'

resource readerRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' existing = {
  name: roleDefinitionId
}

resource roleAssignmentKeyVault 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: keyVault
  name: guid(subscription().id, principalId, roleDefinitionId)
  properties: {
    principalId: principalId
    roleDefinitionId: readerRoleDefinition.id
  }
}
