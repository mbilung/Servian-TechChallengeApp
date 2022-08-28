#########################################################################
# Author: Manish Bilung (manish.bilung@outlook.com)
# Prerequsite to run this script: 
# 1. AzureCLI, https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
# 2. Have contributor role assigned to you by your Azure admin
# This script creates the below resources on azure:
# 1. Resource Group
# 2. VNET
# 3. SUBNET
# 4. Azure Kubernetes Services
# 5. ACR (Azure Container Registry)
#########################################################################
# Script Varables Block
$resourceGroup = "ServianTechapp-RG-WestEurope"
$location = "westeurope" 
$vnetName = "vnet-techapp"
$subnetName = "subnet-techapp"
$aksName = "servian-techapp-aks"
$acrName = "servian-acr"
$subscriptionID = "f73e27ea-9e93-4f2e-9043-5fe661e47340" # change this value based on subscription in use
#########################################################################
# create resource group
az group create --name $resourceGroup --location $location

# create ACR
az acr create --resource-group $resourceGroup `
--name $acrName --sku Basic

# create a service principal and store it in the file in the same folder
az ad sp create-for-rbac > sp.json

$jsonString = Get-Content -Path ./sp.json
$jsonObj = $jsonString | ConvertFrom-Json

# extract service principal name from the file generated 
$spnName = $jsonObj.displayName

# create service principal and propagate contributor role to resource groups:
az ad sp create-for-rbac --name $spnName --role contributor --scopes /subscriptions/$subscriptionID/resourceGroups/$resourceGroup > sp_aks.json

$jsonString = Get-Content -Path ./sp_aks.json
$jsonObj = $jsonString | ConvertFrom-Json

# service principal details to be used while AKS creation
$aks_clientId = $jsonObj.appId
$aks_clientSecret = $jsonObj.password

# create VNET and SUBNET
az network vnet create `
--resource-group $resourceGroup `
--name $vnetName `
--address-prefixes 192.168.0.0/16 `
--subnet-name $subnetName `
--subnet-prefix 192.168.1.0/24

# Store the vnet subnet id in a variable
$SUBNET_ID=$(az network vnet subnet show --resource-group $resourceGroup --vnet-name $vnetName --name $subnetName --query id -o tsv)

Write-Output $SUBNET_ID

# create AKS cluster
az aks create `
--resource-group $resourceGroup `
--name $aksName `
--node-count 1 `
--network-plugin kubenet `
--network-policy calico `
--service-principal $aks_clientId `
--client-secret $aks_clientSecret `
--vnet-subnet-id $SUBNET_ID