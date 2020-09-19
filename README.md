# Consul - namespaces

## Requirements
- [ansible](https://www.ansible.com/)
- [jq](https://stedolan.github.io/jq/)
- [curl](https://curl.haxx.se/)

## Steps to reproduce

- Creates two namespaces ["team1","team2"] using bootstrap token (my case its `master`)
- Generate tokens for namespace's admins with policy `namespace-management` within namespace
- Try register service within namespace `team1` using admin token of namespace `team2` (should fail, but do not)

## Expected

I expect that admin token within namespace 'team1' with policy `namespace-management` does not have `write` access to others namespace(s), like 'default' or 'team2'



Next commands should fail, examples:
```
## checking write access
CONSUL_HTTP_TOKEN=<team1_token> ./consul services register -namespace=default -name=web -address=1.1.1.1 -port=80
CONSUL_HTTP_TOKEN=<team1_token> ./consul services register -namespace=team2 -name=web -address=1.1.1.1 -port=80

## checking read access
CONSUL_HTTP_TOKEN=<team1_token> ./consul catalog services -namespace=team2
```

- [Meetup video Consul 1.7 - Namespaces: Simplifying Self-Service, Governance and Operations Across Teams at 22:33](https://youtu.be/Ff6kLvKkJBE?t=1353)

## Reference
- [ACL policies](https://www.consul.io/docs/security/acl/acl-system#acl-policies)
