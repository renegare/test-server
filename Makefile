APP_NAME=$(notdir $(shell pwd))
DOCKER_REGISTRY=$(if $(DOCKER_REGISTRY_USER),$(DOCKER_REGISTRY_USER),$(USER))/$(APP_NAME)

start:
	echo '$(if $(RESPONSE), $(RESPONSE), Test Server)' > /var/www/html/index.html
	nginx

build:
	docker build --force-rm=true -t $(APP_NAME) .

up:
	docker run -P \
		-e RESPONSE='$(RESPONSE)' \
		$(APP_NAME) start

tag: ## tag latest image using git sha as tag
	printf "Tagging $(APP_NAME):latest > $(DOCKER_REGISTRY):$(APP_VERSION) ... "
	docker tag -f $(APP_NAME):latest $(DOCKER_REGISTRY):$(APP_VERSION) 
	docker tag -f $(APP_NAME):latest $(DOCKER_REGISTRY):latest
	echo Done
	docker images

push: ## push latest built image to registry
	printf "Pushing $(DOCKER_REGISTRY):$(APP_VERSION) ... "
	if [ -n "$(DOCKER_REGISTRY_USER)" ]; then \
		docker login -e $(DOCKER_REGISTRY_EMAIL) -u $(DOCKER_REGISTRY_USER) -p $(DOCKER_REGISTRY_PASS) $(DOCKER_REGISTRY_HOST) https://index.docker.io/v1/; \
	fi
	docker push $(DOCKER_REGISTRY)
	echo Done
