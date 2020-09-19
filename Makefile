UNAME := $(shell uname -s)
version := 1.8.4+ent

.PHONY: consul

### consul installation
install: download unzip

download:
ifeq ($(UNAME),Linux)
	curl -L -s https://releases.hashicorp.com/consul/${version}/consul_${version}_linux_amd64.zip -o consul.zip
endif
ifeq ($(UNAME),Darwin)
	curl -L -s http://releases.hashicorp.com/consul/${version}/consul_${version}_darwin_amd64.zip -o consul.zip
endif

unzip:
	unzip consul.zip
	rm consul.zip
	chmod +x ./consul

### consul run
consul:
	./consul agent -dev -config-file=consul-config.hcl

### ansible
run:
	ansible-playbook playbook.yml

### debug
# deregister services (token: master)
clean: deregister

deregister:
	CONSUL_HTTP_TOKEN=master ./consul services deregister -namespace team1 -id=web || true
	CONSUL_HTTP_TOKEN=master ./consul services deregister -namespace team2 -id=web || true
	CONSUL_HTTP_TOKEN=master ./consul services deregister -namespace default -id=web || true
