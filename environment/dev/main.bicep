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

module RG '../../modules/rg/rg.bicep' = {
  name:'deploy-resourceGroup'
  params:{
    resourceGroupName:resourceGroupName
    location:location
    optionalInfo:optionalInfo
  }
}

module NSG '../../modules/nsg/nsg.bicep' = {
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

module VNET '../../modules/vnet/vnet.bicep' = {
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

module ASP '../../modules/asp/asp.bicep' = {
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
