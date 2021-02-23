provider "akamai" {
  edgerc = "~/.edgerc"
  config_section = "Default"
}

locals {
    group_name      = "Akamai Demo-M-1YX7F61"
    cpcode_name     = "My CP Code"
    group_id        = "grp_93068"
    contract_id     = "ctr_M-1YX7F61"
    product_id      = "prd_SPM"
    edge_hostname   = "test1.yohanlakhani.com.edgekey.net"
    certificate     = 97582
    ip_behavior     = "IPV6_PERFORMANCE"
    json            = file("rules.json")
}

resource "akamai_property" "test-yohanlakhani" {
  name           = "test1.yohanlakhani.com"
  product_id     = local.product_id
  group_id      = local.group_id
  contract_id   = local.contract_id
  hostnames = {
      "test.yohanlakhani.com" = "test1.yohanlakhani.com.edgekey.net"
  }
  rule_format = "latest"
  rules = local.json 
}


data "akamai_contract" "akacontract" {
  group_name = var.group

}

data "akamai_group" "akagroup" {
  group_name    = var.group
  contract_id   = data.akamai_contract.akacontract.id
}

resource "akamai_edge_hostname" "edgeHostname" {
  group_id      = local.group_id
  contract_id   = local.contract_id
  product_id    = local.product_id
  edge_hostname = local.edge_hostname
  certificate   = local.certificate
  ip_behavior   = local.ip_behavior
}

