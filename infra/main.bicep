targetScope = 'subscription'

// The main bicep module to provision Azure resources.
// For a more complete walkthrough to understand how this file works with azd,
// see https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/make-azd-compatible?pivots=azd-create

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

param appServicePlanName string = ''

param storageAccountName string = ''

// Optional parameters to override the default azd resource naming conventions.
// Add the following to main.parameters.json to provide values:
// "resourceGroupName": {
//      "value": "myGroupName"
// }
param resourceGroupName string = ''

var abbrs = loadJsonContent('./abbreviations.json')

// tags that should be applied to all resources.
var tags = {
  // Tag all resources with the environment name.
  'azd-env-name': environmentName
}

// Generate a unique token to be used in naming resources.
// Remove linter suppression after using.
#disable-next-line no-unused-vars
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

// Name of the service defined in azure.yaml
// A tag named azd-service-name with this value should be applied to the service host resource, such as:
//   Microsoft.Web/sites for appservice, function
// Example usage:
//   tags: union(tags, { 'azd-service-name': apiServiceName })
#disable-next-line no-unused-vars
var apiServiceName = 'api'

// Organize resources in a resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : '${abbrs.resourcesResourceGroups}${environmentName}'
  location: location
  tags: tags
}

// // Backing storage for Azure functions backend API
// module storage './core/storage/storage-account.bicep' = {
//   name: 'storage'
//   scope: rg
//   params: {
//     name: !empty(storageAccountName) ? storageAccountName : '${abbrs.storageStorageAccounts}${resourceToken}'
//     location: location
//     tags: tags
//     subnet: vnet.outputs.logicAppsSubnet
//   }
// }

// Create an App Service Plan to group applications under the same payment plan and SKU
module appServicePlan './core/host/appserviceplan.bicep' = {
  name: 'appserviceplan'
  scope: rg
  params: {
    name: !empty(appServicePlanName) ? appServicePlanName : '${abbrs.webServerFarms}${resourceToken}'
    location: location
    tags: tags
    kind: 'elastic'
    sku: {
      name: 'WS1'
      tier: 'WorkflowStandard'
      size: 'WS1'      
      family: 'WS'
      capacity: 1
    }    
  }
}

module storage 'core/storage/storage.bicep' = {
  scope: rg
  name: 'logic'
  params : {
    name: !empty(storageAccountName) ? storageAccountName : '${abbrs.storageStorageAccounts}${resourceToken}'
  }
}


module ordersTable 'core/storage/storage-table.bicep' = {
  name: 'ordersTable'
  scope: rg
  params: {
    storageAccountName: storage.outputs.name
    tableName: 'orders'
  }
}

// @description('The runtime version for Node.js Azure Functions in Logic Apps. Common values include "~18", "~16", or "~14" depending on the Node.js LTS version support desired. Check Azure Functions documentation for currently supported versions.')
module functions 'core/host/functions.bicep' = {
  name: 'logic-app'
  scope: rg
  params: {
    name: '${abbrs.logicWorkflows}${environmentName}-${resourceToken}'
    location: location
    appServicePlanId: appServicePlan.outputs.id
    storageAccountName: storage.outputs.name
    runtimeName: 'node'    
    runtimeVersion: '~18'
    // applicationInsightsName: monitoring.outputs.applicationInsightsName
    tags: union(tags, { 'azd-service-name': 'api' })        
  }
}



// Add resources to be provisioned below.
// A full example that leverages azd bicep modules can be seen in the todo-python-mongo template:
// https://github.com/Azure-Samples/todo-python-mongo/tree/main/infra



// Add outputs from the deployment here, if needed.
//
// This allows the outputs to be referenced by other bicep deployments in the deployment pipeline,
// or by the local machine as a way to reference created resources in Azure for local development.
// Secrets should not be added here.
//
// Outputs are automatically saved in the local azd environment .env file.
// To see these outputs, run `azd env get-values`,  or `azd env get-values --output json` for json output.
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
