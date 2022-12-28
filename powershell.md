# Sign in to your Azure account
Connect-AzAccount

# Get the subscription ID. Running the following command lists your subscriptions and their IDs. copy the ID from the second column.
Get-AzSubscription

# Set the default subscription for all the Azure Powershell commands that you run in this session.
$context = Get-AzSubscription -SubscriptionName ''
Set-AzContext $context

# Change your active subscription. Be sure to replace {Your subscription ID} with the one that you copied.
$context = Get-AzSubscription -SubscriptionID {Your Subscription ID}
Set-AzContext $context

$storageAccount = Get-AzStorageAccount -ResourceGroupName '<resource-group-name>' -AccountName '<storage-account-name>'
$ctx = $storageAccount.Context

# Deploy Bicep to a resource group.
New-AzResourceGroupDeployment  -location eastus2 -ResourceGroupName '' -TemplateFile deploy/main.bicep -TemplateParameterFile deploy/main.parameters.json -WhatIf

# Create Azure Storage Static Website 
Update-AzStorageBlobServiceProperty -ResourceGroupName '' -AccountName '' -StaticWebsite -ErrorDocument404Path "404.html" -IndexDocument "index.html"

Enable-AzStorageStaticWebsite -Context $ctx -IndexDocument 'index.html' -ErrorDocument404Path '404.html'

# Authenticate GitHub workflow with Azure AD

1. Create the Azure Active Directory application. _This command will output the AppId property that is your ClientId. The Id property is APPLICATION-OBJECT-ID and it will be used for creating federated credentials with Graph API calls._

        New-AzADApplication -DisplayName myApp

2. Create a service principal. Replace the $clientId with the AppId from your output. This command generates output with a different Id and will be used in the next step. The new Id is the ObjectId.
   
        $clientId = (Get-AzADApplication -DisplayName myApp).AppId
        New-AzADServicePrincipal -ApplicationId $clientId

3. Create a new role assignment. Beginning with Az PowerShell module version 7.x, New-AzADServicePrincipal no longer assigns the Contributor role to the service principal by default. Replace $resourceGroupName with your resource group name, and $objectId with generated Id.

        $objectId = (Get-AzADServicePrincipal -DisplayName myApp).Id
        New-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName Contributor -ResourceGroupName $resourceGroupName

4. Get the values for clientId, subscriptionId, and tenantId to use later in your GitHub Actions workflow.

        $clientId = (Get-AzADApplication -DisplayName myApp).AppId
        $subscriptionId = (Get-AzContext).Subscription.Id
        $tenantId = (Get-AzContext).Subscription.TenantId