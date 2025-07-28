targetScope = 'resourceGroup'

@description('Define the Network Security Group Name')
param nsgpeName string
param nsgaseName string

@description('define the location of resources to be deployed')
param location string

@description('Define the Tags')
param optionalInfo object

resource nsgPE 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name:nsgpeName
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

resource nsgASE 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name:nsgaseName
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

output nsgpeId string = nsgPE.id
output nsgaseId string = nsgPE.id
