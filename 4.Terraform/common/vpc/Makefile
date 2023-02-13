dev:
	rm -rf .terraform
	terraform init -backend-config=env/dev-backend.tfvars
	terraform apply -auto-approve -var-file=env/dev.tfvars
prod:
	rm -rf .terraform
	terraform init -backend-config=env/prod-backend.tfvars
	terraform apply -auto-approve -var-file=env/prod.tfvars