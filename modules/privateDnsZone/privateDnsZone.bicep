@description('Name of the private DNS zone')
param privateDnsZoneName string

@description('Virtual Network ID to link the private DNS zone')
param virtualNetworkId string

@description('Location for the private DNS zone (should be global)')
param location string = 'global'

@description('Optional information including tags details')
param optionalInfo object

@description('Private DNS Zone resource ID')
output privateDnsZoneId string = privateDnsZone.id

@description('Private DNS Zone name')
output privateDnsZoneName string = privateDnsZone.name

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: location
  tags: {
    Platform: optionalInfo.tagsdetail.platform
    Workload: optionalInfo.tagsdetail.workload
    Architect: optionalInfo.tagsdetail.architect
    Owner: optionalInfo.tagsdetail.owner
    Support: optionalInfo.tagsdetail.support
  }
}

resource privateDnsZoneVNetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: '${privateDnsZoneName}-vnet-link'
  location: location
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworkId
    }
  }
}

