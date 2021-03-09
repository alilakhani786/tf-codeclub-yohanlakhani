output "aka_contract" {
  value = data.akamai_contract.akacontract.id
}

output "aka_group" {
  value = data.akamai_group.akagroup.group_name
  
}

output "aka_edgehost_ipbehavior" {
  value = akamai_edge_hostname.edgeHostname.ip_behavior
}

output "aka_edgehost_name" {
  value = akamai_edge_hostname.edgeHostname.edge_hostname
}
/*
output "json" {
  value = data.akamai_property_rules.rules.json
}
*/