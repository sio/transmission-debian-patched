DOCKER?=docker
TAG=transmission-fdlimit-patch

BUILD_ARTIFACTS=\
	pkg \
	.image-is-ready


pkg: .image-is-ready | deps
	$(DOCKER) cp $(TAG):/packages/. $@/


.image-is-ready: Dockerfile $(wildcard *.patch)
	$(DOCKER) build --rm -t $(TAG) .
	touch $@


.PHONY: deps
deps:
	$(DOCKER) --version


.PHONY: inspect
inspect:
	$(DOCKER) run --rm -it $(TAG)


.PHONY: clean
clean: docker-clean
	-$(RM) -r $(BUILD_ARTIFACTS)


.PHONY: docker-clean
docker-clean:
	-$(DOCKER) rmi $(TAG)
