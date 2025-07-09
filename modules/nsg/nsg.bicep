targetScope = 'resourceGroup'

param nsgName string
param location string

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name:nsgName
  location:location
  properties:{
    securityRules:[]
  }
}
