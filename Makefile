DOCKER?=docker
TAG=transmission-patched

BUILD_ARTIFACTS=\
	pkg \
	.image-is-ready


pkg: .image-is-ready | deps
	IMAGE=$$($(DOCKER) create $(TAG)) && \
	$(DOCKER) cp $$IMAGE:/packages/. $@/ && \
	$(DOCKER) rm $$IMAGE


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
	-$(DOCKER) image prune -f --filter label=status=intermediate
