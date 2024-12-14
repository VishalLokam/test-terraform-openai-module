resource "azurerm_resource_group" "azureopenai_rg1" {
  name     = "azureopenai_rg1"
  location = var.location
}

# public_network_access_enabled set to false to restrict access from the internet.
# outbound_network_access_restricted set to true to deny access exceptions from trusted services.
# custom_subdomain_name required for private endpoint.
resource "azurerm_cognitive_account" "azureopenai_cognitive_account1" {
  resource_group_name        = azurerm_resource_group.azureopenai_rg1.name
  name                       = "azureopenai_cognitive_account"
  kind                       = "OpenAI"
  location                   = var.location
  sku_name                   = "S0"
  dynamic_throttling_enabled = true
}

# deployment named "gpt35turbo_0125_deployment" inside the cognitive account.
# model used is openai gpt-3.5-turbo(0125)
# sku is standard with 50k token per minute(TPM) limit. 1 capacity = 1k TPM
resource "azurerm_cognitive_deployment" "azureopenai_cognitive_deployment" {
  name                       = var.deployment_name
  cognitive_account_id       = azurerm_cognitive_account.azureopenai_cognitive_account.id
  dynamic_throttling_enabled = true
  model {
    format = "OpenAI"
    name   = var.model_name
  }

  sku {
    name     = "Standard"
    capacity = 50
  }

}




