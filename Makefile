UNAME := $(shell uname -s)
consul_version := 1.8.4+ent
vault_version := 1.5.3+ent

.PHONY: consul vault

### consul installation
install: download unzip

download:
ifeq ($(UNAME),Linux)
	curl -L -s https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip -o consul.zip
	curl -L -s https://releases.hashicorp.com/vault/{vault_version}/vault_${vault_version}_linux_amd64.zip -o vault.zip
endif
ifeq ($(UNAME),Darwin)
	curl -L -s http://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_darwin_amd64.zip -o consul.zip
	curl -L -s https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_darwin_amd64.zip -o vault.zip
endif

unzip:
	unzip consul.zip
	unzip vault.zip
	rm consul.zip
	rm vault.zip
	chmod +x ./consul
	chmod +x ./vault

### consul run
consul-local:
	./consul agent -dev -config-file=consul-config.hcl

### ansible
#run-local:
#	ansible-playbook playbook.yml
#
#run:
#	cd vagrant-hashistack; make up
#destroy:
#	cd vagrant-hashistack; make clean

vault:
	./vault server -dev -dev-root-token-id=master -config=./

### debug
# deregister services (token: master)
clean: deregister

deregister:
	CONSUL_HTTP_TOKEN=master ./consul services deregister -namespace team1 -id=web || true
	CONSUL_HTTP_TOKEN=master ./consul services deregister -namespace team2 -id=web || true
	CONSUL_HTTP_TOKEN=master ./consul services deregister -namespace default -id=web || true
