# Create an image pull secret
# Prerequisite: create a namespace in AKS

$jsonString = Get-Content -Path ../../deployment/infrastructure/sp_aks.json
$jsonObj = $jsonString | ConvertFrom-Json

# service principal details to be used while AKS creation
$aks_clientId = $jsonObj.appId
$aks_clientSecret = $jsonObj.password

kubectl create secret docker-registry acr-secret `
--namespace servian `
--docker-server=servianacr.azurecr.io `
--docker-username=$aks_clientId `
--docker-password=$aks_clientSecret