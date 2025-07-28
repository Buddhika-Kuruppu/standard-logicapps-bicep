targetScope = 'subscription'

@description('Define the Resource Group Name')
param resourceGroupName string

@description('Define the Location of resources to be deployed')
param location string

@description('Define the Tags')
param optionalInfo object

resource RG 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: location
  tags:{
    Platform:optionalInfo.tagsdetail.platform
    Workload:optionalInfo.tagsdetail.workload
    Architect:optionalInfo.tagsdetail.architect
    Owner:optionalInfo.tagsdetail.owner
    Support:optionalInfo.tagsdetail.support
  }
}
