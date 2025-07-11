targetScope = 'subscription'
param resourceGroupName string
param location string
param nsgName string

@description('Define Virtual network Name')
param virtualnetworkName string

@description('Define IP Address Spaces')
param virtualNetworkaddressSpace string
param dnsServers string
param subnet01Name string
param Subnet01CIDR string

@description('Define the Tags')
param optionalInfo object

module RG '../../modules/rg.bicep' = {
  name:'deploy-resourceGroup'
  params:{
    resourceGroupName:resourceGroupName
    location:location
    optionalInfo:optionalInfo
  }
}

module NSG '../../modules/nsg.bicep' = {
  name:'deploy-NSG'
  scope:resourceGroup(resourceGroupName)
  params: {
    nsgName:nsgName
    location:location
    optionalInfo:optionalInfo
  }
  dependsOn:[RG]
}

module VNET '../../modules/vnet.bicep' = {
  name:'deploy-VNET'
  scope:resourceGroup(resourceGroupName)
  params:{
    virtualnetworkName:virtualnetworkName
    location:location
    virtualNetworkaddressSpace:virtualNetworkaddressSpace
    dnsServers:dnsServers
    subnet01Name:subnet01Name
    Subnet01CIDR:Subnet01CIDR
    networkSecurityGroupId:NSG.outputs.nsgId
    optionalInfo:optionalInfo
  }
  dependsOn:[RG]
}
