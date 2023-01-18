@description('Virtual network name')
param virtualNetworkName string = 'vnet${uniqueString(resourceGroup().id)}'

@description('Location for all resources.')
param location string = resourceGroup().location
param infraIpGroupName string = '${location}-infra-ipgroup-${uniqueString(resourceGroup().id)}'
param workloadIpGroupName string = '${location}-workload-ipgroup-${uniqueString(resourceGroup().id)}'

param vnetAddressPrefix string = '10.10.0.0/24'
param azureFirewallSubnetPrefix string = '10.10.0.0/25'
param azureFirewallSubnetName string = 'AzureFirewallSubnet'

resource workloadIpGroup 'Microsoft.Network/ipGroups@2022-01-01' = {
  name: workloadIpGroupName
  location: location
  properties: {
    ipAddresses: [
      '10.20.0.0/24'
      '10.30.0.0/24'
    ]
  }
}

resource infraIpGroup 'Microsoft.Network/ipGroups@2022-01-01' = {
  name: infraIpGroupName
  location: location
  properties: {
    ipAddresses: [
      '10.40.0.0/24'
      '10.50.0.0/24'
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: virtualNetworkName
  location: location
  tags: {
    displayName: virtualNetworkName
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: azureFirewallSubnetName
        properties: {
          addressPrefix: azureFirewallSubnetPrefix
        }
      }
    ]
    enableDdosProtection: false
  }
}
