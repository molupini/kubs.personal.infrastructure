provider "azurerm" {
  // environment = var.environment
  # TODO:MAKE USE OF VAULT SECRET STORE, SET ENVIRONMENT VARIABLES WITHIN PIPELINE

  # STABLE RELEASE,  
  version = "~> 2.18.0"
  features {}
}


provider "random" {
  // version = "~> 2.2.1"
}
