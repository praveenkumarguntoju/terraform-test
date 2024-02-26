resource "azurerm_container_registry" "acr" {
  name                          = "${replace("${var.solution-name}${var.environment}acr", "-","")}"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  sku                           = "Premium"
  admin_enabled                 = true
  public_network_access_enabled = true
}
