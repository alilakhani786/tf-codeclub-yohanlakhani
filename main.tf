provider "akamai" {
  edgerc = "~/.edgerc"
  config_section = "Default"
}

locals {
    email           = "nlakhani@akamai.com"
    group_name      = "Akamai Demo-M-1YX7F61"
//    cpcode_name     = "My CP Code"
    group_id        = "grp_93068"
    contract_id     = "ctr_M-1YX7F61"
    product_id      = "prd_SPM"
    edge_hostname   = "test1.yohanlakhani.com.edgekey.net"
    certificate     = 97582
    ip_behavior     = "IPV6_PERFORMANCE"
    //json            = file("rules.json")
    tdenabled       = true
}

data "template_file" "rule_template" {
  template = file("${path.module}/rules/main.json")
  vars = {
    snippets = "${path.module}/rules/snippets"
  }
}

data "template_file" "rules" {
  template = data.template_file.rule_template.rendered
  vars = {
    tdenabled = local.tdenabled
  }
}

resource "akamai_property" "test-yohanlakhani" {
  name           = var.propertyName
  product_id     = local.product_id
  group_id      = local.group_id
  contract_id   = local.contract_id
  hostnames = {
      "test1.yohanlakhani.com" = "test1.yohanlakhani.com.edgekey.net"
  }
  rule_format = "latest"
  rules     = data.template_file.rules.rendered
  //rules = local.json 
}


data "akamai_contract" "akacontract" {
  group_name = var.groupName

}

data "akamai_group" "akagroup" {
  group_name    = var.groupName
  contract_id   = data.akamai_contract.akacontract.id
}

resource "akamai_edge_hostname" "edgeHostname" {
  group_id      = data.akamai_group.akagroup.id
  contract_id   = local.contract_id
  product_id    = local.product_id
  edge_hostname = local.edge_hostname
  certificate   = local.certificate
  ip_behavior   = local.ip_behavior
}

resource "akamai_property_activation" "test-yohanlakhani-staging" {
     property_id =  akamai_property.test-yohanlakhani.id
     contact  = [local.email] 
     version = akamai_property.test-yohanlakhani.latest_version
}

/*
resource "akamai_property_activation" "test-yohanlakhani-production" {
     property_id =  akamai_property.test-yohanlakhani.id
     contact  = [local.email] 
     version = akamai_property.test-yohanlakhani.latest_version
     network = "PRODUCTION"
}
*/