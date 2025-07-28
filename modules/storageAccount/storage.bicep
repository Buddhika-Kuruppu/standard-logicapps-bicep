@description('Name of the Storage Account')
param storageAccountName string

@description('Location for the Storage Account')
param location string

@description('Storage Account SKU')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
])
param storageAccountSku string = 'Standard_LRS'

@description('Storage Account access tier')
@allowed([
  'Hot'
  'Cool'
])
param accessTier string = 'Hot'

@description('Optional information including tags details')
param optionalInfo object

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  tags: {
    Platform: optionalInfo.tagsdetail.platform
    Workload: optionalInfo.tagsdetail.workload
    Architect: optionalInfo.tagsdetail.architect
    Owner: optionalInfo.tagsdetail.owner
    Support: optionalInfo.tagsdetail.support
  }
  sku: {
    name: storageAccountSku
  }
  kind: 'StorageV2'
  properties: {
    accessTier: accessTier
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

@description('Storage Account resource ID')
output storageAccountId string = storageAccount.id

@description('Storage Account name')
output storageAccountName string = storageAccount.name

@description('Storage Account primary key')
output storageAccountKey string = storageAccount.listKeys().keys[0].value

@description('Storage Account connection string')
output storageAccountConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=core.windows.net'