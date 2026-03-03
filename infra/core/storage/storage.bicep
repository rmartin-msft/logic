
param name string
param tags object = {}


resource storage 'Microsoft.Storage/storageAccounts@2025-06-01' = {  
  name: name
  kind: 'StorageV2'
  location : resourceGroup().location
  tags: tags
  sku: { 
    name: 'Standard_LRS' 
  }
  properties: {
    accessTier: 'Hot'
  }
}

output name string = storage.name
