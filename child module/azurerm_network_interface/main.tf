resource "azurerm_network_interface" "nics" {
  for_each = var.nics
  name                = each.value.nic_name
  location            = each.value.nic_location
  resource_group_name = each.value.resource_group_name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = each.value.private_ip_address_allocation
    private_ip_address = each.value.private_ip_address
    public_ip_address_id = data.azurerm_public_ip.pips[each.key].id
  }
}
data "azurerm_public_ip" "pips" {
    for_each = var.nics
  name                = each.value.pip_name
  resource_group_name = each.value.resource_group_name
}
data "azurerm_subnet" "subnet" {
    for_each = var.nics
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}