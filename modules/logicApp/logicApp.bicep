@description('Name of the Logic App Standard')
param logicAppName string

@description('Location for the Logic App Standard')
param location string

@description('Resource ID of the existing App Service Plan')
param appServicePlanId string

@description('Storage account connection string for Logic App Standard')
param storageAccountConnectionString string

@description('Storage account name for Logic App Standard')
param storageAccountName string

@description('Application Insights connection string')
param appInsightsConnectionString string = ''

@description('Optional information including tags details')
param optionalInfo object

@description('Logic App Standard configuration settings')
param appSettings object = {}

@description('Logic App Standard resource ID')
output logicAppId string = logicAppStandard.id

@description('Logic App Standard name')
output logicAppName string = logicAppStandard.name


resource logicAppStandard 'Microsoft.Web/sites@2024-04-01' = {
  name: logicAppName
  location: location
  tags: {
    Platform: optionalInfo.tagsdetail.platform
    Workload: optionalInfo.tagsdetail.workload
    Architect: optionalInfo.tagsdetail.architect
    Owner: optionalInfo.tagsdetail.owner
    Support: optionalInfo.tagsdetail.support
  }
  kind: 'functionapp,workflowapp'
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true
    siteConfig: {
      netFrameworkVersion: 'v6.0'
      use32BitWorkerProcess: false
      ftpsState: 'Disabled'
      appSettings: union([
        {
          name: 'AzureWebJobsStorage'
          value: storageAccountConnectionString
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: storageAccountConnectionString
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(logicAppName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~18'
        }
        {
          name: 'AzureFunctionsJobHost__extensionBundle__id'
          value: 'Microsoft.Azure.Functions.ExtensionBundle.Workflows'
        }
        {
          name: 'AzureFunctionsJobHost__extensionBundle__version'
          value: '[1.*, 2.0.0)'
        }
        {
          name: 'APP_KIND'
          value: 'workflowApp'
        }
      ], !empty(appInsightsConnectionString) ? [
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightsConnectionString
        }
      ] : [], items(appSettings))
    }
  }
}
