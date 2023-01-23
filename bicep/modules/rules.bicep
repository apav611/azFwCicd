param projectName string

var afwPolRuleName = '${projectName}-afw-pol-rules'
var afwPolName = '${projectName}-afw-pol'

resource azFWPolRule 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-03-01' = {
  name: '${afwPolName}/${afwPolRuleName}'
  properties: {
    priority: 100
    ruleCollections: [
      {
        name: 'test-collection'
        priority: 100
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            description: 'Testing Rule'
            name: 'Allow_Azure'
            ruleType: 'ApplicationRule'
            protocols: [
              {
                port: 443
                protocolType: 'Https'
              }
            ]
            sourceAddresses: [
              '*' 
            ]
            webCategories: [ 
              'ComputersAndTechnology'
              'Business'
            ]
          }
        ]
      }
      // add more rule collections here
      {
        name: 'test-collection2'
        priority: 200
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Deny'
        }
        rules: [
          {
            description: 'Testing Rule'
            name: 'Deny_Azure'
            ruleType: 'ApplicationRule'
            protocols: [
              {
                port: 443
                protocolType: 'Https'
              }
            ]
            targetFqdns: [
              'www.google.com'
            ]
            sourceAddresses: [
              '*' 
            ]
          }
        ]
      }
      {
        name: 'test-collection3'
        priority: 300
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Deny'
        }
        rules: [
          {
            description: 'Testing Rule'
            name: 'Deny_Azure'
            ruleType: 'ApplicationRule'
            protocols: [
              {
                port: 443
                protocolType: 'Https'
              }
            ]
            targetFqdns: [
              'www.bing.com'
            ]
            sourceAddresses: [
              '*' 
            ]
          }
        ]
      }
    ]
  }
}
