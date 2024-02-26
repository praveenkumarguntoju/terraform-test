resource "azurerm_resource_group" "rg" {
    name     = "${var.solution-name}-${var.environment}-rg"
    location = var.azure-region
}