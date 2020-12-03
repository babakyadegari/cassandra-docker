NAME = byadegari/docker-emqx-prod
INSTANCE = emqx-tmp
CURRENT_DIR = $(shell pwd)
TMP_EXIST:=${shell docker container ls -a | grep $(INSTANCE)}
.PHONY: default build compile debug clean push buildrelease

default: buildrelease

build:
	docker build --file ./emqx_cassandra_backend/Dockerfile-emqx-builder --tag byadegari/emqx-builder-deps --target emqx-builder ./emqx_cassandra_backend/
	#docker push byadegari/emqx-builder:deps

compile:
	@if [ -n "$(TMP_EXIST)" ]; then \
		docker rm $(INSTANCE); \
	fi
	docker run -it --name $(INSTANCE) --mount type=bind,source=$(CURRENT_DIR)/emqx_cassandra_backend,target=/emqx_cassandra_backend byadegari/emqx-builder-deps
	docker commit $(INSTANCE) byadegari/emqx-builder-latest

release:
	docker build -t $(NAME):latest --target docker-emqx-prod --file ./emqx_cassandra_backend/Dockerfile-emqx-prod ./emqx_cassandra_backend

buildrelease: build compile release

clean:
	docker rm $(INSTANCE)

# debug:
# 	docker run --rm -it --name $(INSTANCE) $(NAME)-dev /bin/bash
#
# run:
# 	docker run --rm -p 80:80 --name $(INSTANCE) $(NAME)

dev:
	docker run -it --entrypoint /bin/bash --mount type=bind,source=$(CURRENT_DIR)/emqx_cassandra_backend,target=/emqx_cassandra_backend byadegari/emqx-builder:deps
	#--entrypoint /docker-entrypoint-dev.sh
	#docker-compose up emqx-dev

push:
	docker push $(NAME):latest
