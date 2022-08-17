## resource group variables
## Define location for resource groups
$technology = "avs"
$resourceGroupLocation = "germanywestcentral"

$actionGroupRgName = "$technology-$resourceGroupLocation-operational_rg"

## TODO - create Action group

## GUID work
$guid = New-Guid
$actionGroupSuffix = $guid.ToString().Split("-")[0]
$actionGroupName = "avs_" + $actionGroupSuffix

$receivers = "flkelly@microsoft.com" #,"robin.heringa@microsoft.com"

foreach ($receiver in $receivers) {
    $name = $receiver.Split("@")[0].replace(".","")
    $email = $receiver
    # $emailReceiver = New-AzActionGroupReceiver -Name $name -EmailReceiver -EmailAddress '$email'
    $emailReceiver
    $emailReceiver = New-AzActionGroupReceiver -Name $name -EmailReceiver -EmailAddress $email
    $actionGroup = Set-AzActionGroup -Name $actionGroupName -ShortName "avsalerts" -ResourceGroupName $actionGroupRgName -Receiver $email1
}

# Creates an ActionGroup reference object in memory.
$actionGroupId = New-AzActionGroup -ActionGroupId $actionGroup.Id

## Reporting variables
$technology = "avs"
$resourceGroupLocation = "germanywestcentral"
$privateCloudRgName = "$technology-$resourceGroupLocation-private_cloud_rg"
$privateCloud = Get-AzVMwarePrivateCloud -ResourceGroupName $privateCloudRgName

## varibales for alerts
$subID = (Get-AzContext).Subscription.id
$privateCloudName = $privateCloud.Name

## Dimension variables
$clusternameDim1 = New-AzMetricAlertRuleV2DimensionSelection -DimensionName "clustername" -ValuesToInclude "*"

## EffectiveCpuAverage
$criteria1 = New-AzMetricAlertRuleV2Criteria -MetricName "EffectiveCpuAverage" -DimensionSelection $clusternameDim1 -TimeAggregation Average -Operator GreaterThan -Threshold 80
$targetResourceID = "/subscriptions/$subID/resourceGroups/$privateCloudRgName/providers/Microsoft.AVS/privateClouds/$privateCloudName"
Add-AzMetricAlertRuleV2 -Name "EffectiveCpuAverage" -ResourceGroupName $actionGroupRgName -WindowSize 0:30 -Frequency 0:5 -TargetResourceId $targetResourceID -Condition $criteria1 -ActionGroup $act -Severity 2 -Description "CPU Usage per Cluster"

## UsageAverage
$criteria2 = New-AzMetricAlertRuleV2Criteria -MetricName "UsageAverage" -DimensionSelection $clusternameDim1 -TimeAggregation Average -Operator GreaterThan -Threshold 80
$targetResourceID = "/subscriptions/$subID/resourceGroups/$privateCloudRgName/providers/Microsoft.AVS/privateClouds/$privateCloudName"
Add-AzMetricAlertRuleV2 -Name "UsageAverage" -ResourceGroupName $actionGroupRgName -WindowSize 0:30 -Frequency 0:5 -TargetResourceId $targetResourceID -Condition $criteria2 -ActionGroup $act -Severity 2 -Description "Memory Usage per Cluster"

## Dimension variables
$dsnameDim1 = New-AzMetricAlertRuleV2DimensionSelection -DimensionName "dsname" -ValuesToInclude "*"

## DiskUsedPercentage
$criteria3 = New-AzMetricAlertRuleV2Criteria -MetricName "DiskUsedPercentage" -DimensionSelection $dsnameDim1 -TimeAggregation Average -Operator GreaterThan -Threshold 70
Add-AzMetricAlertRuleV2 -Name "DiskUsedPercentage" -ResourceGroupName $actionGroupRgName -WindowSize 0:30 -Frequency 0:5 -TargetResourceId $targetResourceID -Condition $criteria2 -ActionGroup $act -Severity 2 -Description "Storage Usage per Datastore"

## DiskUsedPercentage
$criteria4 = New-AzMetricAlertRuleV2Criteria -MetricName "DiskUsedPercentage" -DimensionSelection $dsnameDim1 -TimeAggregation Average -Operator GreaterThan -Threshold 75
Add-AzMetricAlertRuleV2 -Name "DiskUsedPercentageCritical" -ResourceGroupName $actionGroupRgName -WindowSize 0:30 -Frequency 0:5 -TargetResourceId $targetResourceID -Condition $criteria2 -ActionGroup $act -Severity 0 -Description "Storage Usage per Datastore Critical"

## Azure Activity Log Alerts
## TODO - Look at continuing to use bicepo file and pass parameters to the script
$condition1 = New-AzActivityLogAlertCondition -Field 'category' -Equal 'ServiceHealth'
$condition2 = New-AzActivityLogAlertCondition -Field 'properties.impactedServices[*].ServiceName' -equal 'Azure VMware Solution'
$condition3 = New-AzActivityLogAlertCondition -Field 'properties.impactedServices[*].ImpactedRegions[*].RegionName' -equal 'germanywestcentral'

## TODO - convert dashboard to workbook?
## deploy workbook as referenced object