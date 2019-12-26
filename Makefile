DOCKER?=docker
TAG=transmission-patched


BUILD_ARTIFACTS=\
	pkg \
	.image-is-ready


pkg: .image-is-ready | check-deps
	CONTAINER=$$($(DOCKER) create $(TAG)) && \
	$(DOCKER) cp $$CONTAINER:/packages/. $@/ && \
	$(DOCKER) rm $$CONTAINER


.image-is-ready: Dockerfile $(wildcard *.patch)
	$(DOCKER) build --rm -t $(TAG) .
	touch $@


.PHONY: check-deps
check-deps:
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
