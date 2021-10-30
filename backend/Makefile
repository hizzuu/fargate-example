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
	docker run --rm --name new_migrate -v $(PWD)/tools/db/migration:/migration \
	migrate/migrate:latest create -ext sql -dir ./migration $(CMD)

migrate:
	docker run --rm --name migrate --net $(NET) \
	-v $(PWD)/tools/db/migration:/migration migrate/migrate:latest \
	-path /migration/ -database "mysql://root:password@tcp($(DB_SVC):3306)/$(DB_NAME)" $(CMD)
