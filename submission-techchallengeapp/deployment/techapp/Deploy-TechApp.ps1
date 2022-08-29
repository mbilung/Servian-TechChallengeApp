#########################################################################
# Author: Manish Bilung (manish.bilung@outlook.com)
# Prerequsite to run this script: 
# 1. AzureCLI, https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
# 2. kubectl, https://kubernetes.io/docs/tasks/tools/
# 3. Subscription ID where AKS is deployed
#########################################################################
# Parameter Block
param(
    [Parameter()]
    [string]$subscriptionID
)
#########################################################################
# Open Cloud Shell or after installing azure cli on your local machine
# Run the following commands

az account set --subscription $subscriptionID # change the subscription id to the subscription you are using

Write-Output "subscription being used is: $subscriptionID"

az aks get-credentials --resource-group ServianTechapp-RG-WestEurope --name servian-techapp-AKS

kubectl apply -f ../../kubernetes-manifests/

Write-Output "waiting for ingress controller to set up"

Start-Sleep -seconds 45

kubectl apply -f ../../kubernetes-manifests/ingress-rule.yaml

# create image pull secret
$PSScriptRoot

& "$PSScriptRoot\Create-ImagePullSecret.ps1"