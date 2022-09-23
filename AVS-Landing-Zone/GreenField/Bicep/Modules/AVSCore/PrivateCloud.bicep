param Prefix string
param NetworkBlock string
param ManagementClusterSize int
param SKUName string
param Location string
param Internet string

resource PrivateCloud 'Microsoft.AVS/privateClouds@2021-06-01' = {
  name: '${Prefix}-SDDC'
  sku: {
    name: SKUName
  }
  location: Location
  properties: {
    networkBlock: NetworkBlock
    internet: Internet
    managementCluster: {
      clusterSize: ManagementClusterSize
    }
  }
}

output PrivateCloudName string = PrivateCloud.name
output PrivateCloudResourceId string = PrivateCloud.id
