
param location string
param environment string

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: uniqueString('sala', environment)
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: 'asp-workflows-${environment}'
  location: location
  sku: {
    name: 'WS1'
    tier: 'WorkflowStandard'
  }
}

resource logicAppStandard 'Microsoft.Web/sites@2023-01-01' = {
  name: 'wf-${environment}'
  location: location
  kind: 'workflowapp,functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
  }
}

output principalId string = logicAppStandard.identity.principalId


