APP_NAME=$(notdir $(shell pwd))

start:
	echo '$(if $(RESPONSE), $(RESPONSE), Test Server)' > /var/www/html/index.html
	nginx

build:
	docker build --force-rm=true -t $(APP_NAME) .

up:
	docker run -P \
		-e RESPONSE='$(RESPONSE)' \
		$(APP_NAME) start
