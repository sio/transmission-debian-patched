# BUILD TRANSMISSION PACKAGE FOR DEBIAN AFTER APPLYING PATCHES
# https://github.com/sio/transmission-debian-patched


DOCKER?=docker
TAG=transmission-patched


BUILD_ARTIFACTS=\
	pkg \
	.image-is-ready


pkg: | image check-deps
	CONTAINER=$$($(DOCKER) create $(TAG)) && \
	$(DOCKER) cp $$CONTAINER:/packages/. $@/ && \
	$(DOCKER) rm $$CONTAINER
	cd $@; sha256sum * > checksums.sha256


.image-is-ready: Dockerfile $(wildcard *.patch)
	$(DOCKER) build --rm -t $(TAG) .
	touch $@


.PHONY: image
image: .image-is-ready


.PHONY: check-deps
check-deps:
	$(DOCKER) --version


.PHONY: inspect
inspect:
	$(DOCKER) run --rm -it $(TAG) /bin/sh


.PHONY: clean
clean: docker-clean
	-$(RM) -r $(BUILD_ARTIFACTS)


.PHONY: docker-clean
docker-clean:
	-$(DOCKER) rmi $(TAG)
	-$(DOCKER) image prune -f --filter label=github=sio/transmission-debian-patched
