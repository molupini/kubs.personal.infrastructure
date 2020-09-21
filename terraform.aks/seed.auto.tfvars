resource = {
  kv = {
    config = [
      {
        name                      = "kv"
        whitelist                 = []
        keyvault_access_object_id = ""
      },
      # {
      #   name                      = "ops"
      #   whitelist                 = []
      #   keyvault_access_object_id = ""
      # }
    ]
  },
  storage = {
    config = [
      {
        name                  = "aks"
        kind                  = "StorageV2"
        tier                  = "Standard"
        redundancy            = "LRS" # or RA-GRS
        public_access         = false
        container_access_type = "private"
        container             = ["log"]
        web_page              = "false" # NOTE: IF TRUE BELOW ARGUMENTS ARE REQUIRED 
        index                 = ""
        error                 = ""
      }
    ]
  }
  # AKS MOVED TO LOCAL
}

prefix      = "mo"
env         = "dev"
environment = "public"
rg          = "rg-personal"
regions     = ["North Europe", "West Europe"]
postfix     = ""
primary     = "pri-"
secondary   = "sec-"

default_tags = {
  managedWith = "terraform"
  costCenter  = "personal"
  repo        = "none"
}

whitelist = ["165.255.253.181/32"]
