targetScope = 'subscription'
param resourceGroupName string
param location string
param nsgpeName string
param nsgaseName string

@description('Define Virtual network Name')
param virtualnetworkName string

@description('Define IP Address Spaces')
param virtualNetworkaddressSpace string
param dnsServers string
param subnet01Name string
param Subnet01CIDR string
param subnet02Name string
param Subnet02CIDR string

@description('Define the Tags')
param optionalInfo object

@description('define the ASE Parameters')
param aseName string

@description('Define ASP Parameter Values')
param aspName string
param aspSKU string
param aspCapacity int

@description('Define Logic App Parameter Values')
param logicAppName string
param storageAccountName string
param appInsightsConnectionString string = ''

module RG '../modules/rg/rg.bicep' = {
  name:'deploy-resourceGroup'
  params:{
    resourceGroupName:resourceGroupName
    location:location
    optionalInfo:optionalInfo
  }
}

module NSG '../modules/nsg/nsg.bicep' = {
  name:'deploy-NSG'
  scope:resourceGroup(resourceGroupName)
  params: {
    nsgpeName:nsgpeName
    nsgaseName:nsgaseName
    location:location
    optionalInfo:optionalInfo
  }
  dependsOn:[RG]
}

module VNET '../modules/vnet/vnet.bicep' = {
  name:'deploy-VNET'
  scope:resourceGroup(resourceGroupName)
  params:{
    virtualnetworkName:virtualnetworkName
    location:location
    virtualNetworkaddressSpace:virtualNetworkaddressSpace
    dnsServers:dnsServers
    subnet01Name:subnet01Name
    Subnet01CIDR:Subnet01CIDR
    subnet02Name:subnet02Name
    Subnet02CIDR:Subnet02CIDR
    PEnetworkSecurityGroupId:NSG.outputs.nsgpeId
    ASEnetworkSecurityGroupId:NSG.outputs.nsgaseId
    optionalInfo:optionalInfo
  }
  dependsOn:[RG]
}

//Here App Service Environment is deployed through Azure Verified Modules Registry
module ASE 'br/public:avm/res/web/hosting-environment:0.4.0' = {
  name: 'hostingEnvironmentDeployment'
  scope:resourceGroup(resourceGroupName)
  params: {
    // Required parameters for basic deployment
    name: aseName
    subnetResourceId: VNET.outputs.aseSubnetId
  }
}

module ASP '../modules/asp/asp.bicep' = {
  name:'AppS-ervice-Plan-Deployment'
  scope:resourceGroup(resourceGroupName)
  params:{
    aspName:aspName
    location:location
    optionalInfo:optionalInfo
    aseId:ASE.outputs.resourceId
    aspSKU:aspSKU
    aspCapacity:aspCapacity
  }
}

// Deploy private DNS zones for storage account private endpoints
module privateDnsZoneBlob '../modules/privateDnsZone/privateDnsZone.bicep' = {
  name: 'deploy-privateDnsZone-blob'
  scope: resourceGroup(resourceGroupName)
  params: {
    privateDnsZoneName: 'privatelink.blob.core.windows.net'
    virtualNetworkId: VNET.outputs.vnetId
    optionalInfo: optionalInfo
  }
  dependsOn: [RG, VNET]
}

module privateDnsZoneFile '../modules/privateDnsZone/privateDnsZone.bicep' = {
  name: 'deploy-privateDnsZone-file'
  scope: resourceGroup(resourceGroupName)
  params: {
    privateDnsZoneName: 'privatelink.file.core.windows.net'
    virtualNetworkId: VNET.outputs.vnetId
    optionalInfo: optionalInfo
  }
  dependsOn: [RG, VNET]
}

module privateDnsZoneTable '../modules/privateDnsZone/privateDnsZone.bicep' = {
  name: 'deploy-privateDnsZone-table'
  scope: resourceGroup(resourceGroupName)
  params: {
    privateDnsZoneName: 'privatelink.table.core.windows.net'
    virtualNetworkId: VNET.outputs.vnetId
    optionalInfo: optionalInfo
  }
  dependsOn: [RG, VNET]
}

module privateDnsZoneQueue '../modules/privateDnsZone/privateDnsZone.bicep' = {
  name: 'deploy-privateDnsZone-queue'
  scope: resourceGroup(resourceGroupName)
  params: {
    privateDnsZoneName: 'privatelink.queue.core.windows.net'
    virtualNetworkId: VNET.outputs.vnetId
    optionalInfo: optionalInfo
  }
  dependsOn: [RG, VNET]
}

// Deploy Logic App with private endpoints
module LogicApp '../modules/logicApp/logicApp.bicep' = {
  name: 'deploy-logicApp'
  scope: resourceGroup(resourceGroupName)
  params: {
    logicAppName: logicAppName
    location: location
    appServicePlanId: ASP.outputs.aspId
    storageAccountName: storageAccountName
    appInsightsConnectionString: appInsightsConnectionString
    optionalInfo: optionalInfo
    subnetId: VNET.outputs.peSubnetId
    privateDnsZoneId: privateDnsZoneBlob.outputs.privateDnsZoneId
  }
  dependsOn: [ASP, privateDnsZoneBlob, privateDnsZoneFile, privateDnsZoneTable, privateDnsZoneQueue]
}
