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

data "akamai_contract" "akacontract" {
  group_name = var.groupName

}

data "akamai_group" "akagroup" {
  group_name    = var.groupName
  contract_id   = data.akamai_contract.akacontract.id
}