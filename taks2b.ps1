#2.	We have an Azure Traffic Manager with 3 App Services as Endpoints. 
#We need to build a script that disable each of the endpoints at a time,and while performing the disabling, it must change the App Service Size.


#In this case, the App Service size will decrease.


$ResourceGroupName = "rg-altudo-staging"
$ProfileName = "traf-altudoweb"

$ServicePlanname1 = "giselle_bc93_asp_Windows_brazilsouth_0"
$ServicePlanname2 = "giselle_bc93_asp_Windows_westeurope_0"
$ServicePlanname3 = "giselle_bc93_asp_Windows_eastasia_0"

# Disabling App Service 1 and decreasing disk size

Disable-AzTrafficManagerEndpoint    -ResourceGroupName $ResourceGroupName -ProfileName $ProfileName -Type AzureEndpoints -Force -Name America
Set-AzAppServicePlan -Name $ServicePlanname1 -ResourceGroupName $ResourceGroupName -Tier S1
Enable-AzTrafficManagerEndpoint    -ResourceGroupName $ResourceGroupName -ProfileName $ProfileName -Type AzureEndpoints -Name America
Start-Sleep -s 30

# Disabling App Service 2 and decreasing disk size
Disable-AzTrafficManagerEndpoint    -ResourceGroupName $ResourceGroupName -ProfileName $ProfileName -Type AzureEndpoints -Force -Name Europe
Set-AzAppServicePlan -Name $ServicePlanname2 -ResourceGroupName $ResourceGroupName -Tier S1
Enable-AzTrafficManagerEndpoint    -ResourceGroupName $ResourceGroupName -ProfileName $ProfileName -Type AzureEndpoints -Name Europe
Start-Sleep -s 30

# Disabling App Service 3 and decreasing disk size
Disable-AzTrafficManagerEndpoint    -ResourceGroupName $ResourceGroupName -ProfileName traf-altudoweb -Type AzureEndpoints -Force -Name Asia
Set-AzAppServicePlan -Name 'giselle_bc93_asp_Windows_eastasia_0' -ResourceGroupName $ProfileName -Tier S1
Enable-AzTrafficManagerEndpoint    -ResourceGroupName $ResourceGroupName -ProfileName $ProfileName -Type AzureEndpoints -Name Asia