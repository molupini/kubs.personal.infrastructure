resource "time_static" "time" {}

locals {
  default_tags = merge(var.default_tags, { env = var.env }, { time = formatdate("DD MMM YYYY hh:mm ZZZ", time_static.time.rfc3339) })
  aks_cluster = {
    config = [
      {
        kubernetes_version             = "1.18.8"
        aks_agent_os_disk_size         = 128
        aks_max_pods                   = 110
        aks_agent_vm_size              = "Standard_D2s_v3" # , Standard_D2s_v3 Standard_F8s
        aks_node_count                 = 1
        aks_min_node_count             = 1
        aks_max_node_count             = 3 # 16
        aks_agent_pool_name            = "nodepool1"
        aks_sku_tier                   = "Free"
        aks_availability_zones         = []
        oauth_reply_url                = "https://azrc.yourdomain.net/login/generic_oauth"
        enable_auto_scaling            = "true"
        virtual_network_address_prefix = "10.0.0.0/8"    # --address-prefixes, super scope 
        aks_subnet_address_prefix      = "10.0.0.0/16"   # aks full subnet cidr range 
        aks_service_cidr               = "10.240.0.0/16" # --service-cidr
        aks_dns_service_ip             = "10.240.0.10"   # --dns-service-ip, needs to be within the service cidr but not the first address
        aks_docker_bridge_cidr         = "172.17.0.1/16" # --docker-bridge-address
        cluster_id                     = "aks"
        dns_prefix                     = "aks"
        aks_flux_ssh_key               = module.kv.azurerm_key_vault[0].name            # place holder
        storage_name                   = module.storage.azurerm_storage_account[0].name # place holder
        # env_keyvault                 = module.kv.azurerm_key_vault[0].name
        env_keyvault_rg               = var.rg
        bastion_subnet_address_prefix = "10.2.0.0/16"
        bastion_ip                    = "10.2.0.5"
        tenant_id                     = data.azurerm_client_config.current.tenant_id
      }
    ]
  }
}