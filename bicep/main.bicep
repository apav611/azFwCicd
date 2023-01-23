param projectNameFile string
param locationFile string
param dateNow string = utcNow('yyyy-MM-dd')
param emailFile string
param vnetAddressPrefixFile string
param monNameFile string
param afwSKUFile string
@secure()
param vmPassFile string
param vmAdmFile string
param vmSizeFile string
param vmNameFile string

module monMDL 'modules/monitor.bicep' = {
  name: 'mon-deploy'
  params: {
    location: locationFile
    date: dateNow
    email: emailFile
    name: monNameFile
  }
}

module vnetMDL 'modules/network.bicep' = {
  name: 'vnet-deploy'
  params: {
    projectName: projectNameFile
    vnetAddress: vnetAddressPrefixFile
    location: locationFile
    date: dateNow
    email: emailFile
  }
}

module bstMDL 'modules/bastion.bicep' = {
  name: 'bst-deploy'
  dependsOn: [
    vnetMDL
  ]
  params: {
    projectName: projectNameFile
    location: locationFile
    date: dateNow
    email: emailFile
    vnet: vnetMDL.outputs.net
  }
}

module afwMDL 'modules/afw.bicep' = {
  name: 'afw-deploy'
  dependsOn: [
    vnetMDL
  ]
  params: { 
    log: monMDL.outputs.workspace
    location: locationFile
    date: dateNow
    email: emailFile
    projectName: projectNameFile
    vnet: vnetMDL.outputs.net
    afwSKU: afwSKUFile
  }
}

module ruleMDL 'modules/rules.bicep' = {
  name: 'rules-deploy'
  dependsOn: [
    afwMDL
  ]
  params: { 
    projectName: projectNameFile
  }
}

module w10MDL 'modules/w10.bicep' = {
  name: 'w10-deploy'
  dependsOn: [
    vnetMDL
  ]
  params: {
    location: locationFile
    date: dateNow
    email: emailFile
    vnet: vnetMDL.outputs.net
    nextHop: afwMDL.outputs.nextHop
    rt: vnetMDL.outputs.rt
    vmName: vmNameFile
    vmPass: vmPassFile
    vmAdm: vmAdmFile
    vmSize: vmSizeFile
    vnetAddress: vnetAddressPrefixFile
  }
}
