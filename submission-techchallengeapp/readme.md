# Servian Technical Challenge

## Prerequisites

- azure cli 
- kubectl 
- elevated powershell/vscode terminal
- PowerShell script execution policy set to bypass, set it with the help of below command:
  - Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine

## Overview of the folder structure
```
├───readme.md│     
├───architecture-diagrams
├───CI-CD-pipeline
├───deployment
│   ├───infrastructure
│   │       Deploy-Infrastructure.ps1
│   │       
│   └───techapp
│           Create-ImagePullSecret.ps1
│           Deploy-TechApp.ps1
│           
└───kubernetes-manifests
        app-namespace.yaml
        app-svc.yaml
        ingress-nginx-controller.yaml
        ingress-rule.yaml
        postgres-pvc.yaml
        postgres-svc.yaml
        postgres.yaml
        secret.yaml
        servian-app.yaml
```

## Infrastructure overview

I have used Azure as cloud hosting platform. Azure services used are as follows:

- Azure Kubernetes Services (to host TechAppChallenge container and Postgres Server)
- Azure VNET and Subnet
- Azure Container Registry (to act as an image repository when CI-CD pipeline is used)
- Azure App Registration (to propagate correct roles to azure resources)
- Azure Devops Services (to create CI and CD pipelines)

## Deploy infrastructure

Infrastructure is deployed with the help of azure cli and PowerShell Scripts.

### Steps:

1. clone the repository https://github.com/mbilung/Servian-TechChallengeApp 

2. Navigate to the sub-folder <b>infrastructure</b> which is under the folder <b>deployment</b>

```
cd submission-techchallengeapp/deployment/infrastructure
```
```
├───deployment
│   ├───infrastructure
│   │       Deploy-Infrastructure.ps1
```

3. Make sure that you are on an elavated terminal and powershell execution policy is set to <b>Bypass</b>

4. Login to azure using azure cli
```
az login
```
5. Provide the subscription id as a variable to the script: <b>Deploy-Infrastructure.ps1</b>

6. Run the powershell script using the below command
```
./Deploy-Infrastructure.ps1
```

7. Once the infrastructure is deployed, you will get the message: "Infrastructure Created Successfully"

## Deploy TechApp

TechApp and PostgresDB is deployed through Kubenretes Manifests.

### Steps:

1. Navigate to the sub-folder <b>techapp</b> which is under the folder <b>deployment</b>

```
cd submission-techchallengeapp/deployment/techapp
```
```
├───deployment
│   ├───infrastructure
│   │       Deploy-Infrastructure.ps1
│   │       
│   └───techapp
│           Create-ImagePullSecret.ps1
│           Deploy-TechApp.ps1
```

2. Provide the azure subscription id as a variable to the script

3. Run the below command:
```
./Deploy-TechApp
```
4. Once the TechApp gets deployed to AKS, login to azure and get the public ip created under services:



## CI CD

## Improvement
