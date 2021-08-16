#3.	We have a set of Virtual Machines running, and we need to create a script to monitor CPU, Memory and 
#Disk and send an email to a Distribution List whenever one of the thresholds is met 90% CPU, 75% Memory and 20% of Free Disk Space


#Variables (Distribution List, Action Group, Resource Group and VM)
$DistributionList = "giselle_bc93@hotmail.com.br"
$ActionGroupName = "notify-admins"
$ResourceGroupName = "rg-altudo-staging"
$VMName = "M2ub-v1"

# Severity
$ServerityCritical = 0
$ServerityError = 1
$ServerityWarning = 2
$ServerityInformational = 3
$ServerityVerbose = 4


$receiver = New-AzActionGroupReceiver -Name "Admin" -EmailAddress $DistributionList
$actionGroup = Set-AzActionGroup -Name $ActionGroupName -ShortName "ActionGroup1" -ResourceGroupName $ResourceGroupName -Receiver $receiver

#Create an ActionGroup refence object
$actionGroupId = New-AzActionGroup -ActionGroupId $actionGroup.Id


# Creater a local criteria object

## Common Metric Names
$WindowSize = New-TimeSpan -Minutes 1
$frequency = New-TimeSpan -Minutes 1
$targetResourceId = (Get-AzResource -Name $VMName).ResourceId

# CPU Alert
$PercentageCPUMetricName = "Percentage CPU"
$condition = New-AzMetricAlertRuleV2Criteria -MetricName $PercentageCPUMetricName -TimeAggregation Average -Operator GreaterThan -Threshold 90
Add-AzMetricAlertRuleV2 -Name "CPU Alert" -ResourceGroupName $ResourceGroupName -WindowSize $WindowSize -Frequency $frequency -TargetResourceId $targetResourceId -Condition $condition -ActionGroup $actionGroupId -Severity $ServerityWarning

# Memory Alert
$PercentageMemoryMetricName = "Percentage Memory"
$condition = New-AzMetricAlertRuleV2Criteria -MetricName $PercentageMemoryMetricName -TimeAggregation Average -Operator GreaterThan -Threshold 75
Add-AzMetricAlertRuleV2 -Name "Memory Alert" -ResourceGroupName $ResourceGroupName -WindowSize $WindowSize -Frequency $frequency -TargetResourceId $targetResourceId -Condition $condition -ActionGroup $actionGroupId -Severity $ServerityWarning

