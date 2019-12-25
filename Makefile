DOCKER?=docker
TAG=transmission-fdlimit-patch


pkg: .image-is-ready | deps
	$(DOCKER) cp $(TAG):/packages/. pkg/


.image-is-ready: Dockerfile $(wildcard *.patch)
	$(DOCKER) build -t $(TAG) .
	touch $@


.PHONY: deps
deps:
	$(DOCKER) --version


.PHONY: inspect
inspect:
	$(DOCKER) run --rm -it $(TAG)


.PHONY: clean
clean: docker-clean
	-$(RM) -r pkg .image-is-ready


.PHONY: docker-clean
docker-clean:
	-$(DOCKER) rmi $(TAG)
