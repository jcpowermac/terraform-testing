#!/bin/bash


export TF_LOG_PATH=./terraform.log
export TF_LOG=trace

rm terraform.log terraform.tfstate*

terraform init
terraform apply -auto-approve
