# # KV
module "kv" {
  source  = "app.terraform.io/rapiddeploy/kv/azure"
  version = "1.0.7"

  name_prefix  = ["${var.prefix}-${var.env}-${var.postfix}${var.primary}", "${var.prefix}-${var.env}-${var.postfix}${var.secondary}"]
  vault_config = var.resource.kv.config
  location     = var.regions
  tenant_id    = data.azurerm_client_config.current.tenant_id
  # USER OBJECT ID'S PASSED INTO MODULE LOCAL
  object_full_access = flatten([data.azurerm_client_config.current.object_id])
  object_cert_access = []
  rg                 = data.azurerm_resource_group.rg.name
  whitelist          = var.whitelist
  # RESOURCE DIAGNOSTICS, AUDITING  
  storage_account_id = ""
  enable_mui         = false
  tag                = local.default_tags
}

module "storage" {
  source  = "app.terraform.io/rapiddeploy/storage/azure"
  version = "1.0.5"

  storage_config   = var.resource.storage.config
  enable_sas_token = true
  name_prefix      = "${var.prefix}-${var.env}-${var.postfix}${var.primary}"
  rg               = data.azurerm_resource_group.rg.name
  # NOTE SINGLE LOCATION, PRIMARY
  location = var.regions[0]
  tag      = local.default_tags
}

resource "azurerm_container_registry" "repo" {
  name                = replace("${var.prefix}${var.env}${var.postfix}${var.primary}repo", "-", "") # alphanumeric only 
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.regions[0]
  sku                 = "Standard" # Basic, Premium
  admin_enabled       = false      # true

  # NOTE ONLY POSSIBLE WITH PREMIUNM SKU
  # georeplication_locations = ["East US"]

  tags = local.default_tags
}

module "aks-plus" {
  source  = "app.terraform.io/rapiddeploy/aks-plus/azure"
  version = "1.0.1"

  rg                      = data.azurerm_resource_group.rg.name
  location                = var.regions[0]
  aks_config              = local.aks_cluster.config
  name_prefix             = "${var.prefix}-${var.env}-${var.postfix}${var.primary}"
  vault_id                = module.kv.azurerm_key_vault[0].id
  enable_bastion_vm       = false
  enable_auth             = false
  private_cluster_enabled = false
  tag                     = merge(local.default_tags, map("role", "microservices"))
}