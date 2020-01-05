tf-init:
	rm -rf .terraform
	az account set -s "${AZURE_LAB_SUBSCRIPTION}"  
	terraform init

tf-plan:
	az account set -s "${AZURE_LAB_SUBSCRIPTION}" 
	terraform fmt
	terraform plan

tf-apply:
	az account set -s "${AZURE_LAB_SUBSCRIPTION}" 
	terraform fmt
	terraform apply

tf-destroy:
	az account set -s "${AZURE_LAB_SUBSCRIPTION}" 
	terraform destroy