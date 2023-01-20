variable "env" {
    type = map
}

variable "rgName" {
  type = string
}

variable "vnet1-id" {
  type = string

}

# Azure Firewall Policy - Applied to Secure Virtual Hub
resource "azurerm_firewall_policy" "fwHubPol" {
  name                = "fwpolicy-${var.env["name"]}"
  resource_group_name = var.rgName
  location            = var.env["region"]
  sku = "Premium"
}

# Default Azure Firewall Policy Rule Collection Group
## -- Additional rules can be loaded using add-on module
resource "azurerm_firewall_policy_rule_collection_group" "fwHubPol-defaultPolCol" {
  name               = "fwpolicy-rcg-${var.env["name"]}"
  firewall_policy_id = azurerm_firewall_policy.fwHubPol.id
  priority           = 500

  application_rule_collection {
    name  = "example-application-Rule"
    priority = 1000
    action = "Deny"
    rule {
      name  = "rule1"
      protocols {
        type = "Https"
        port  = 443
      }
      source_addresses = [ "10.1.0.0/16" ]
      destination_fqdns = [ "*.microsoft.com" ]
    }
  }
}

# Deploy public IP for Azure Firewall
resource "azurerm_public_ip" "azfw-pip" {
  name                = "azfw-pip-${var.env["name"]}"
  location            = var.env["region"]
  resource_group_name = var.rgName
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Deploy Azure Firewall
resource "azurerm_firewall" "azfw" {
  name                = "azfw-${var.env["name"]}"
  location            = var.env["region"]
  resource_group_name = var.rgName

  sku_name            = "AZFW_Hub"
  sku_tier            = "Premium"

  ip_configuration {
    name                 = "fw-config"
    subnet_id            = var.azfw-subnet-id
    public_ip_address_id = azurerm_public_ip.azfw-pip.id
  }
  firewall_policy_id  = azurerm_firewall_policy.fwHubPol.id
}

# data "azurerm_firewall" "azfw" {
#   # depends_on = [
#   #   azurerm_resource_group_tempate_deployment.azfw_template_deployment
#   # ]
#   name = "azfw-${var.env["name"]}"
#   resource_group_name = var.rgName
# }

# Output - Policy Group resource ID
output "default-policyGroup" {
    value = azurerm_firewall_policy_rule_collection_group.fwHubPol-defaultPolCol.id
}

# Output - Azure Firewall ID
output "azfw-name" {
  value = "azfw-${var.env["name"]}"
}
