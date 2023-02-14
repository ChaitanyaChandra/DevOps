dev:
	git pull
	rm -rf .terraform
	terraform init -backend-config=env/dev-backend.tfvars
	terraform plan -var-file=env/dev.tfvars
	terraform apply -auto-approve -var-file=env/dev.tfvars
prod:
	git pull
	rm -rf .terraform
	terraform init -backend-config=env/prod-backend.tfvars
	terraform plan -var-file=env/prod.tfvars
	terraform apply -auto-approve -var-file=env/prod.tfvars
dev-destroy:
	git pull
	rm -rf .terraform
	terraform init -backend-config=env/dev-backend.tfvars
	terraform plan -var-file=env/dev.tfvars
	terraform destroy -auto-approve -var-file=env/dev.tfvars
prod-destroy:
	git pull
	rm -rf .terraform
	terraform init -backend-config=env/prod-backend.tfvars
	terraform plan -var-file=env/prod.tfvars
	terraform destroy -auto-approve -var-file=env/prod.tfvars