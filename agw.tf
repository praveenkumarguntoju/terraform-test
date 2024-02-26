locals {
  backend_address_pool_name              = "backend-pool"
  frontend_port_name                     = "${var.solution-name}-${var.environment}-aks-fpn"
  private_frontend_ip_configuration_name = "${var.solution-name}-${var.environment}-ficn-private"
  public_frontend_ip_configuration_name  = "${var.solution-name}-${var.environment}-ficn-public"
  http_setting_name                      = "${var.solution-name}-${var.environment}-hsn"
  private_listener_name                  = "${var.solution-name}-${var.environment}-ln-http-private"
  public_listener_name                   = "${var.solution-name}-${var.environment}-ln-http-public"
  request_routing_rule_name              = "${var.solution-name}-${var.environment}-rrrn"
  redirect_configuration_name            = "${var.solution-name}-${var.environment}-rrn"
}

resource "azurerm_public_ip" "ip" {
  name                = "${var.solution-name}-${var.environment}-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "agw" {
  name                = "${var.solution-name}-${var.environment}-agw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "${var.solution-name}-${var.environment}-ipc"
    subnet_id = azurerm_subnet.agw.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.public_frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.ip.id
  }

  frontend_ip_configuration {
    name                          = local.private_frontend_ip_configuration_name
    private_ip_address            = "10.1.0.4"
    private_ip_address_allocation = "Static"
    subnet_id                     = azurerm_subnet.agw.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.public_listener_name
    frontend_ip_configuration_name = local.public_frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.public_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 1
  }

  #ignore changes since AGW is managed by AGIC
  lifecycle {
    ignore_changes = [
      tags,
      backend_address_pool,
      backend_http_settings,
      frontend_port,
      http_listener,
      probe,
      redirect_configuration,
      request_routing_rule,
      ssl_certificate
    ]
  }
}