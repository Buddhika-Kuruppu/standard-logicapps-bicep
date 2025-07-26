targetScope = 'resourceGroup'

@description('Define Virtual network Name')
param virtualnetworkName string

@description('Define Location of resources going to deploy')
param location string

@description('Define IP Address Spaces')
param virtualNetworkaddressSpace string
param dnsServers string
param subnet01Name string
param Subnet01CIDR string
param subnet02Name string
param Subnet02CIDR string

@description('Define the Tags')
param optionalInfo object

@description('Define the Network Security Group Id from NSG module')
param PEnetworkSecurityGroupId string
param ASEnetworkSecurityGroupId string

resource VNET 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name:virtualnetworkName
  location:location
  tags:{
    Platform:optionalInfo.tagsdetail.platform
    Workload:optionalInfo.tagsdetail.workload
    Architect:optionalInfo.tagsdetail.architect
    Owner:optionalInfo.tagsdetail.owner
    Support:optionalInfo.tagsdetail.support
  }
  properties:{
    addressSpace:{
      addressPrefixes:[virtualNetworkaddressSpace]   
    }
    dhcpOptions:{
      dnsServers:[dnsServers]
    }
  }
}

resource subnet01 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name:subnet01Name
  parent:VNET
  properties:{
    addressPrefix:Subnet01CIDR
    privateEndpointNetworkPolicies:'Enabled'
    privateLinkServiceNetworkPolicies:'Enabled'
    networkSecurityGroup:{
      id:PEnetworkSecurityGroupId
    }
  }
}

resource subnet02 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name:subnet02Name
  parent:VNET
  properties:{
    addressPrefix:Subnet02CIDR
    privateEndpointNetworkPolicies:'Enabled'
    privateLinkServiceNetworkPolicies:'Enabled'
    networkSecurityGroup:{
      id:ASEnetworkSecurityGroupId
    }
    delegations: [
      {
        name: 'Microsoft.Web.hostingEnvironments'
        properties: {
          serviceName: 'Microsoft.Web/hostingEnvironments'
        }
      }
    ]
  }
}

output aseSubnetId string = subnet02.id
