# Deploying Linux VM with Bootstrapping using Terraform

This repo deploy a virtual machine with  **Linux Ubuntu 18.04 with Dynatrace ActiveGate**.
Before deploying the virtual machine, please update the following files:
* terraform.tfvars 
    Update your Azure subscription information in this file

* azure-user-data.sh
    Update this file to put wget command for the activegate for your Dynatrace tenat

* linux-vm-variables.tf
    Update this file if you want to change the flavor of Linux used. By default, it is going to use UbuntuServer

The code uses AzureRM Provider 2.x
