# Insert data into the container
$accountName = 'cosmos-counter'
$databaseName = 'azure-resume'
$resourceGroupName = 'rg-azureResume'
$partitionKey = '1'

$cosmosDbContext = New-CosmosDbContext -Account $accountName -Database $databaseName -ResourceGroup $resourceGroupName
$document = @{id="1";counter=0} | ConvertTo-Json

New-CosmosDbDocument -Context $cosmosDbContext -CollectionId 'counter' -DocumentBody $document -PartitionKey $partitionKey