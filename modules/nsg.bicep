targetScope = 'resourceGroup'

@description('Define the Network Security Group Name')
param nsgName string

@description('define the location of resources to be deployed')
param location string

@description('Define the Tags')
param optionalInfo object

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name:nsgName
  location:location
  tags:{
    Platform:optionalInfo.tagsdetail.platform
    Workload:optionalInfo.tagsdetail.workload
    Architect:optionalInfo.tagsdetail.architect
    Owner:optionalInfo.tagsdetail.owner
    Support:optionalInfo.tagsdetail.support
  }
  properties:{
    securityRules:[]
  }
}

output nsgId string = nsg.id
