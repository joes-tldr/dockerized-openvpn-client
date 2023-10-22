IMAGE_REPO?=joestldr
IMAGE_NAME?=openvpn-client
IMAGE_TAG?=latest

IMAGE=$(IMAGE_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)

build:
	@docker build --tag $(IMAGE) .
	@if [ ${IMAGE_TAG} != "latest" ]; then \
		docker tag $(IMAGE) $(IMAGE_REPO)/$(IMAGE_NAME):latest; \
	fi

push: build
	@docker push $(IMAGE)
	@if [ ${IMAGE_TAG} != "latest" ]; then \
		docker push $(IMAGE_REPO)/$(IMAGE_NAME):latest; \
	fi

save: build
	@rm -rf out
	@mkdir out
	@docker save $(IMAGE) | pigz -9 > ./out/$(IMAGE_REPO)-$(IMAGE_NAME)-$(IMAGE_TAG).tar.gz
	@cd out; sha256sum $(IMAGE_REPO)-$(IMAGE_NAME)-$(IMAGE_TAG).tar.gz > $(IMAGE_REPO)-$(IMAGE_NAME)-$(IMAGE_TAG).tar.gz.sha256sum

jenkins: build push save

test-run: build
	@docker run --name $(IMAGE_REPO)-$(IMAGE_NAME) -it --rm \
			--dns 9.9.9.9 \
			--dns 149.112.112.112 \
			--cap-add NET_ADMIN \
			--device /dev/net/tun \
			--mount="type=bind,source=./test/client.ovpn,target=/client.ovpn,readonly" \
			--mount="type=bind,source=./test/client.pass,target=/client.pass,readonly" \
			--env PRE_CONNECT_CHECK_CMD="ping -W 3 -c 4 9.9.9.9" \
			--env PRE_CONNECT_CHECK_MAX_RETRIES="3" \
		$(IMAGE) \
			--config /client.ovpn --auth-user-pass /client.pass --auth-nocache
