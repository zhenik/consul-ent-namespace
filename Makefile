UNAME := $(shell uname -s)
version := 1.8.4+ent

.PHONY: consul

install: download exec-right

download:
ifeq ($(UNAME),Linux)
	curl -L -s https://releases.hashicorp.com/consul/${version}/consul_${version}_linux_amd64.zip -o consul.zip
	unzip consul.zip
	rm consul.zip
endif
ifeq ($(UNAME),Darwin)
	curl -L -s http://releases.hashicorp.com/consul/${version}/consul_${version}_darwin_amd64.zip -o consul.zip
	unzip consul.zip
	rm consul.zip
endif

exec-right:
	chmod +x ./consul

consul:
	./consul agent -dev -config-file=consul-config.hcl
