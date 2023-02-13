dev:
	rm -rf .terraform
	terraform init -backend-config=env/dev-backend.tfvars
	terraform plan -var-file=env/dev.tfvars
	terraform apply -auto-approve -var-file=env/dev.tfvars
prod:
	rm -rf .terraform
	terraform init -backend-config=env/prod-backend.tfvars
	terraform plan -var-file=env/dev.tfvars
	terraform apply -auto-approve -var-file=env/prod.tfvars
dev-destroy:
	rm -rf .terraform
	terraform init -backend-config=env/dev-backend.tfvars
	terraform plan -var-file=env/dev.tfvars
	terraform destroy -auto-approve -var-file=env/dev.tfvars
prod-destroy:
	rm -rf .terraform
	terraform init -backend-config=env/prod-backend.tfvars
	terraform plan -var-file=env/dev.tfvars
	terraform destroy -auto-approve -var-file=env/prod.tfvars