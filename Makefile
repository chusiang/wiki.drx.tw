.PHONY: main init run status clean deploy_to_pages

main: run

init:
	docker-compose pull

run:
	docker-compose up -d

status:
	docker-compose ps

clean:
	docker-compose stop wiki
	docker-compose rm -f wiki
	rm -rf public/

deploy_to_pages:
	mkdir 	public/
	cp -r commands imgs public/
	cp *.md public/
