.PHONY: main init run status push deploy_to_pages clean

main: run

init:
	docker-compose pull

run:
	docker-compose up -d

status:
	docker-compose ps

push:
	git push origin main
	git push gh main

deploy_to_pages:
	mkdir public/
	cp *.md	*.html public/
	cp -r commands imgs posts public/

clean:
	docker-compose stop wiki
	docker-compose rm -f wiki
	rm -rf public/
