
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
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }    
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }      
      }
      keySource: 'Microsoft.Storage'      
    }
  }
}

output name string = storage.name
