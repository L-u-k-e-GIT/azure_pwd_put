#### Define again provider , required if Vault is on a different subscription
terraform {
  required_providers {

    azurerm = {
      source = "hashicorp/azurerm"
      #version = "=2.97.0"
    }
  }
}

#Create KeyVault VM password
resource "random_password" "vmpassword" {
  count   = var.MD_RUN
  length  = 20
  special = true
}

resource "azurerm_key_vault_secret" "vmpassword" {
  count        = var.MD_RUN
  name         = "pwd-${var.MD_VM_NAME_PREFIX}${var.MD_PROJECT_NAME}-${var.MD_VM_NAME}-${var.MD_VM_ENV}"
  value        = random_password.vmpassword[0].result
  content_type = "Vm Password for ${var.MD_ADMIN_USERNAME}"
  key_vault_id = var.MD_VAULT_ID
  tags         = var.MD_ALL_TAGS
}

output "vm_password" {
  #count     = var.MD_RUN
  value     = var.MD_RUN == 0 ? "" : random_password.vmpassword[0].result
  sensitive = true
}

###############################VARIABLES

variable "MD_VAULT_ID" {}
variable "MD_ALL_TAGS" {}
variable "MD_ADMIN_USERNAME" {}

variable "MD_RUN" {
  description = "On/Off module. Useful to skip module on the root tf. 0 will not run, 1 will run the module"
  type        = number
  default     = "0"
}


###############################VARIABLES Naming Convention

variable "MD_VM_NAME_PREFIX" {}
variable "MD_PROJECT_NAME" {}
variable "MD_SUBSCRIPTION_PREFIX" {}
variable "MD_VM_ENV" {}
variable "MD_VM_NAME" {}
