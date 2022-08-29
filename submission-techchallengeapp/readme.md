
# Servian Technical Challenge
My take at the Servian Tech Challenge: https://github.com/servian/TechChallengeInstructions

## Prerequisites

- azure cli 
- kubectl 
- elevated powershell/vscode terminal
- PowerShell script execution policy set to bypass, set it with the help of below command:
  - Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine

## Overview of the folder structure
```
│   
└───Servian-TechChallengeApp
    │       
    ├───submission-techchallengeapp
    │   ├───readme.md
    │   │   
    │   ├───CI-CD-pipeline
    │   │       azure-pipeline.yaml
    │   │       
    │   ├───deployment
    │   │   ├───infrastructure
    │   │   │       Deploy-Infrastructure.ps1
    │   │   │       
    │   │   └───techapp
    │   │           Create-ImagePullSecret.ps1
    │   │           Deploy-TechApp.ps1
    │   │           
    │   └───kubernetes-manifests
    │           app-namespace.yaml
    │           app-svc.yaml
    │           ingress-nginx-controller.yaml
    │           ingress-rule.yaml
    │           postgres-pvc.yaml
    │           postgres-svc.yaml
    │           postgres.yaml
    │           secret.yaml
    │           servian-app.yaml
```

## Infrastructure Architecture and Overview

I have used Azure as cloud hosting platform. Azure services used are as follows:

- Azure Kubernetes Services - to host TechAppChallenge container and Postgres Server
- Azure VNET and Subnet
- Azure Container Registry - to act as an image repository when CI-CD pipeline is used
- Azure App Registration - to propagate correct roles to azure resources
- Azure Devops Services - to create CI and CD pipelines

![servian-architecture-techappchallenge](https://user-images.githubusercontent.com/25122904/187151034-575b26b3-99eb-45ee-9826-7a4a0ecdc52e.png)


## Deploy Infrastructure

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
5. Provide the subscription id as a command line argument to the script: <b>Deploy-Infrastructure.ps1</b>
```
Usage: ./Deploy-Infrastructure.ps1 [<azure-subscription>]
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

2. Provide the subscription id as a command line argument to the script: <b>Deploy-TechApp.ps1</b>
```
Usage: ./Deploy-TechApp.ps1 [<azure-subscription>]
```

3. Select yes for both the prompts:
```
A different object named servian-techapp-aks already exists in your kubeconfig file.(y/n)
A different object named clusterUser_ServianTechapp-RG-WestEurope_servian-techapp-aks already exists in your kubeconfig file.(y/n)
```

4. Once the TechApp gets deployed to AKS, login to azure and get the public ip created under services:
![public ip assigned to ingress controller](https://user-images.githubusercontent.com/25122904/187092495-eec560a9-dc60-4fb0-a914-fe40b98105a0.png)

| **IP Address will change for each deployment, IP Addresses used below are as examples** |
| ------------- | 

5. Navigate to TechApp using the public ip provided
```
http://20.23.149.33/
```
6. TechApp is ready to serve requests:
![TechApp hosted on AKS](https://user-images.githubusercontent.com/25122904/187092577-bb717b0d-0645-4226-af43-ff472d48faab.png)

7. Healthchecks done to determine database connectivity status (http://20.23.149.33/healthcheck)
![image](https://user-images.githubusercontent.com/25122904/187092684-09d57e06-2c18-483c-a7b8-a264625352a0.png)



## CI CD

I am using Azure Devops as a CI tool to deploy TechApp to azure platform.

yaml templates for the CI and CD pipelines can be found here:
```
Servian-TechChallengeApp/submission-techchallengeapp/CI-CD-pipeline
```

```
├───CI-CD-pipeline
│   ├───azure-pipeline.yaml
```

### Architecure of CI and CD pipeline
![16617614367441111](https://user-images.githubusercontent.com/25122904/187158064-16e48b29-f4fb-480d-879d-cf369cf14b61.jpg)

### A write up on the CI and CD process

- Code
  - The TechApp application is hosted on github which is made available to azure devops through service connections.
- Service connections
  - Below are the required service connection in azure devops
    - Github service connection - act as code repository
    - Azure Container Registry (ACR) - to push images
    - Azure Resource Manager - to deploy to azure resources
    - AKS Service Connection - to run kubectl commands on AKS
- Piplines
  - pipelines are created using yaml and are multi-staged:
    - build
    - deploy

### Build process

Building the application is straightforward, docker tasks looks for the Dockerfile and starts building the app. Once the app is built, I am using azure devops pipeline tasks to push the image to Azure Container Registry (ACR) using the service connections.

### Deployment process
Once the build process completes, we will deploy the app through azure pipeline kubernetes tasks.
- Refer the kubernetes manifest files
- Use kubectl apply -f commands on the manifest files using azure pipeline kubernetes tasks
- Pull the image from ACR instead of docker resgistry

### Service Connections in Azure Devops
![image](https://user-images.githubusercontent.com/25122904/187134419-8d6bf47d-7d31-4625-9944-5295884ee612.png)

### Multi-Staged yaml pipeline execution in Azure Devops
![image](https://user-images.githubusercontent.com/25122904/187142445-bbb9b7ad-12e0-49a1-b59e-9402be3e2522.png)


### Images pushed to ACR through azure devops pipelines
![image](https://user-images.githubusercontent.com/25122904/187140646-1423ba1e-bd06-4030-a2a9-e0aedb821cc2.png)


## Improvements
- The app deployed on AKS can be secured with a SSL certificate
- Modern tools like terraform can be used to deploy the azure platform
- Key vault feature can be used to store keys
- VNET and SUBNET can be further secured using NSG and firewalls
- PowerShell scripts can be further improved by adding functions and usage details
