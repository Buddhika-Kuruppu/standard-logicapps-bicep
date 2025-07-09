param resourceGroupName string
param location string
param nsgName string

module RG '../../modules/resourcegroup/rg.bicep' = {
  name:'deploy-resourceGroup'
  scope:subscription()
  params:{
    resourceGroupName:resourceGroupName
    location:location
  }
}

module NSG '../../modules/nsg/nsg.bicep' = {
  name:'deploy-NSG'
  scope:resourceGroup(resourceGroupName)
  params: {
    nsgName:nsgName
    location:location
  }
}
