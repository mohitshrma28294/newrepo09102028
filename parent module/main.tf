module "resource_group" {
  source = "../child module/azurerm_resource_group"
  rgs = var.rgs
}
module "virtual_network" {
    depends_on = [ module.resource_group ]
    source = "../child module/azurerm_virtual_network"
    vnets = var.vnets
  
}
module "subnet" {
    depends_on = [ module.resource_group, module.virtual_network ]
  source = "../child module/azurerm_subnet"
  subnet = var.subnet
}
module "pip" {
    depends_on = [ module.resource_group ]
    source = "../child module/azurerm_public_ip"
  pips = var.pips
}
module "virtual_machine" {
    depends_on = [ module.virtual_network, module.subnet, module.pip ]
    source = "../child module/azurerm_virtual_machine"
    vms = var.vms
  
}
