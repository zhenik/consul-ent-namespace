primary_datacenter = "dc1"

acl {
  default_policy = "allow"
  down_policy = "extend-cache"
  enabled = true
  tokens {
    master = "master"
  }
}

//bind_addr = "{{ GetInterfaceIP \"docker0\" }}"
//client_addr = "{{ GetInterfaceIP \"docker0\" }}"
//
//ports = {
//  dns = 53
//  grpc = 8502
//}

