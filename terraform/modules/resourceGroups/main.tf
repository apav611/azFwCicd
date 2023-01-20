# Create DEMO resource groups

resource "azurerm_resource_group" "resourceGroup-azfw" {
    name = "rg-${var.env["name"]}-azfw"
    location = var.env["region"]
}

resource "azurerm_resource_group" "resourceGroup-vnet1" {
    name = "rg-${var.env["name"]}-vnet1"
    location = var.env["region"]
}

resource "azurerm_resource_group" "resourceGroup-vnet2" {
    name = "rg-${var.env["name"]}-vnet2"
    location = var.env["region"]
}

output "azfw-rg" {
    value = azurerm_resource_group.resourceGroup-azfw.name
}

output "vnet1-rg" {
    value = azurerm_resource_group.resourceGroup-vnet1.name
}

output "vnet2-rg" {
    value = azurerm_resource_group.resourceGroup-vnet2.name
}