Connect-AzAccount

$subscriptionId=""
$context = Get-AzSubscription -SubscriptionId $subscriptionId
Set-AzContext $context

$resourceGroup="ARMTemplates"
$location="eastus"
$today=(Get-Date).ToString('yyyy-MM-dd-HH-mm-ss')
$deploymentName="Deployment-$today"

New-AzResourceGroup -Name $resourceGroup -Location $location

New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile main.json -TemplateParameterFile parameters.json -Mode Incremental

Remove-AzResourceGroup -Name $resourceGroup