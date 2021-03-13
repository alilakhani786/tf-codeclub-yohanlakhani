provider "akamai" {
  edgerc = "~/.edgerc"
  config_section = "Default"
}

locals {
  email           = "nlakhani@akamai.com"
  group_name      = "Akamai Demo-M-1YX7F61"
  tdenabled       = true
}

resource "akamai_property" "test-yohanlakhani" {
  name        = var.propertyName
  product_id  = var.prodId
  group_id    = var.groupId
  contract_id = var.contractId
  hostnames = {
      "test1.yohanlakhani.com" = var.edgeHostName
  }
  rule_format = "latest"
  rules       = data.template_file.rules.rendered
  //rules = local.json 
}

resource "akamai_edge_hostname" "edgeHostname" {
  group_id      = data.akamai_group.akagroup.id
  contract_id   = var.contractId
  product_id    = var.prodId
  edge_hostname = var.edgeHostName
  certificate   = var.enrollmentId
  ip_behavior   = var.ipBehavior
}

resource "akamai_property_activation" "test-yohanlakhani-staging" {
     property_id =  akamai_property.test-yohanlakhani.id
     contact  = [local.email] 
     version = akamai_property.test-yohanlakhani.latest_version
}