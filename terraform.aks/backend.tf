terraform {
  backend "remote" {
    organization = "rapiddeploy"
    workspaces {
      prefix = "rd-aks-"
    }
  }
}