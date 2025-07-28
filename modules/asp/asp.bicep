@description('Name of the App Service Plan')
param aspName string

@description('Location for the App Service Plan')
param location string

@description('Resource ID of the existing App Service Environment')
param aseId string

@description('SKU for the App Service Plan in ASE')
param aspSKU string

@description('Number of worker instances for the App Service Plan')
@minValue(1)
@maxValue(30)
param aspCapacity int

@description('Optional information including tags details')
param optionalInfo object

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: aspName
  location: location
  tags: {
    Platform: optionalInfo.tagsdetail.platform
    Workload: optionalInfo.tagsdetail.workload
    Architect: optionalInfo.tagsdetail.architect
    Owner: optionalInfo.tagsdetail.owner
    Support: optionalInfo.tagsdetail.support
  }
  properties: {
    hostingEnvironmentProfile: {
      id: aseId
    }
  }
  sku: {
    name: aspSKU
    capacity: aspCapacity
  }
}
