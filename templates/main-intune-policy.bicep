// Bicep template for Intune & AVD Network Infrastructure Setup
param location string = resourceGroup().location
param vnetName string = 'vnet-enterprise-workplace-prod'
param addressPrefix string = '10.2.0.0/16'
param avdSubnetPrefix string = '10.2.1.0/24'

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: 'nsg-avd-session-hosts'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowWVDOutbound'
        properties: {
          priority: 100
          direction: 'Outbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'WindowsVirtualDesktop'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'snet-avd-hosts'
        properties: {
          addressPrefix: avdSubnetPrefix
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
    ]
  }
}
