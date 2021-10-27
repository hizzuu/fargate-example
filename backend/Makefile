API_SVC = api
DB_SVC  = db
DB_NAME = app_db
NET     = app_net

up:
	docker compose up

build:
	docker compose up --build

down:
	docker compose down

lint:
	docker compose run --rm $(API_SVC) go vet ./...

shell:
	docker exec -it $(API_SVC) sh

migration-gen:
	docker run --rm --name new_migrate -v $(PWD)/tools/migrations:/migrations \
	migrate/migrate:latest create -ext sql -dir ./migrations $(CMD)

migrate:
	docker run --rm --name migrate --net $(NET) \
	-v $(PWD)/tools/migrations:/migrations migrate/migrate:latest \
	-path /migrations/ -database "postgres://root:password@$(DB_SVC):5432/$(DB_NAME)?sslmode=disable" $(CMD)

models-gen:
	docker exec -it ${API_SVC} sh tools/sqlboiler/codegen.sh

api-gen:
	docker run --rm -v "${PWD}:/api" openapitools/openapi-generator-cli generate \
			-i /api/docs/openapi.yaml \
			-g go \
			-o /api/gen
