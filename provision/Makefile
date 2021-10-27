.PHONY: fmt
fmt:
	docker-compose run --rm terraform fmt

.PHONY: init
init:
	docker-compose run --rm terraform init

.PHONY: plan
plan:
	docker-compose run --rm terraform plan

.PHONY: apply
apply:
	docker-compose run --rm terraform apply

.PHONY: destroy
destroy:
	docker-compose run --rm terraform destroy
