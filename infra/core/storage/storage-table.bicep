
param storageAccountName string
param tableName string

resource ordersTable 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-06-01' = {
  name: '${storageAccountName}/default/${tableName}'
}

output tableId string = ordersTable.id
