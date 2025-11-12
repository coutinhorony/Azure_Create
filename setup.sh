#! /usr/bin/sh

# Create random string
guid=$(cat /proc/sys/kernel/random/uuid)
suffix=${guid//[-]/}
suffix=${suffix:0:18}

# Set the necessary variables
RESOURCE_GROUP="rg-dp100-l${suffix}"
RESOURCE_PROVIDER="Microsoft.MachineLearningServices"
REGIONS=("eastus" "westus" "centralus" "northeurope" "westeurope")
RANDOM_REGION=${REGIONS[$RANDOM % ${#REGIONS[@]}]}
WORKSPACE_NAME="mlw-dp100-l${suffix}"
COMPUTE_INSTANCE="ci${suffix}"
COMPUTE_CLUSTER="aml-cluster"
storageAccountName='sampleblobstorage2025'
containerName='sampleblobdp100'
containerName2='secondcontainer'

# Register the Azure Machine Learning resource provider in the subscription
echo "Register the Machine Learning resource provider:"
az provider register --namespace $RESOURCE_PROVIDER

# Create the resource group and workspace and set to default
echo "Create a resource group and set as default:"
az group create --name $RESOURCE_GROUP --location $RANDOM_REGION
az configure --defaults group=$RESOURCE_GROUP

# Crie uma conta de armazenamento
az storage account create --name $storageAccountName --resource-group $resourceGroupName --location $location --sku Standard_LRS

# Crie um container de blob
az storage container create --name $containerName --account-name $storageAccountName

# Crie um container de blob 2 
az storage container create --name $containerName2 --account-name $storageAccountName

echo "Create an Azure Machine Learning workspace:"
az ml workspace create --name $WORKSPACE_NAME 
az configure --defaults workspace=$WORKSPACE_NAME 

# Create compute instance
echo "Creating a compute instance with name: " $COMPUTE_INSTANCE
az ml compute create --name ${COMPUTE_INSTANCE} --size STANDARD_DS11_V2 --type ComputeInstance 

# Create compute cluster
echo "Creating a compute cluster with name: " $COMPUTE_CLUSTER
az ml compute create --name ${COMPUTE_CLUSTER} --size STANDARD_DS11_V2 --max-instances 2 --type AmlCompute 

