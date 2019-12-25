DOCKER?=docker
TAG=transmission-fdlimit-patch


pkg: deps build
	$(DOCKER) cp $(TAG):/packages/. pkg/


.PHONY: deps
deps:
	$(DOCKER) --version


.PHONY: build
build:
	$(DOCKER) build --rm -t $(TAG) .


.PHONY: run
run:
	$(DOCKER) run --rm -t $(TAG)


.PHONY: clean
clean: docker-clean
	-$(RM) -r pkg


.PHONY: docker-clean
docker-clean:
	-$(DOCKER) rm -t $(TAG)
