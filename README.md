# azure_pwd_put
Generate a Random Password and store it on a Azure Vault

In the following example if I call the module only if the enviroment is not sandbox. Because I have different vault for sandbox and production. 
Moreover It will genereate a password for every member of VM_DEF. 
In module calling it is fundamental redefine the providers is the vault is on a different subscription (IE on the Identity subscription)

Example of usage:

module "put_pwd_vm_prod" {
  source      = "git::https://github.com/L-u-k-e-GIT/azure_pwd_put.git"
  for_each = var.VM_DEF

  MD_RUN                 = var.SUBSCRIPTION_PREFIX == "sandbox" ? 0 : 1 ## run only if 
  MD_VAULT_ID            = var.SUBSCRIPTION_PREFIX == "sandbox" ? var.KEY_VAULT_SANDBOX : var.KEY_VAULT_PROD
  MD_VM_NAME_PREFIX      = var.VM_NAME_PREFIX
  MD_VM_NAME             = each.value.name
  MD_PROJECT_NAME        = var.PROJECT_NAME
  MD_VM_ENV              = local.VM_ENV
  MD_SUBSCRIPTION_PREFIX = var.SUBSCRIPTION_PREFIX
  MD_ALL_TAGS            = local.all_tags
  MD_ADMIN_USERNAME      = var.ADMIN_USERNAME
  providers = {
    azurerm = azurerm.prod  # required provider with alias  azurerm.prod defined
  }

}


In the following example if I call the module only if the enviroment is sandbox. Because I have different vault for sandbox and production. 
Moreover It will genereate a password for every member of VM_DEF.
Example of usage:


module "put_pwd_vm_sandbox" {
  source   = "./modules/put_pwd_vm"
  for_each = var.VM_DEF

  MD_RUN                 = var.SUBSCRIPTION_PREFIX == "sandbox" ? 1 : 0
  MD_VAULT_ID            = var.SUBSCRIPTION_PREFIX == "sandbox" ? var.KEY_VAULT_SANDBOX : var.KEY_VAULT_PROD
  MD_VM_NAME_PREFIX      = var.VM_NAME_PREFIX
  MD_VM_NAME             = each.value.name
  MD_PROJECT_NAME        = var.PROJECT_NAME
  MD_VM_ENV              = local.VM_ENV
  MD_SUBSCRIPTION_PREFIX = var.SUBSCRIPTION_PREFIX
  MD_ALL_TAGS            = local.all_tags
  MD_ADMIN_USERNAME      = var.ADMIN_USERNAME
  providers = {
    azurerm = azurerm.sandbox  # required provider with alias  azurerm.sandbox defined
  }

}
