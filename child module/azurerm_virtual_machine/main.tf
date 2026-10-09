resource "azurerm_network_interface" "nics" {
  for_each = var.vms
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = data.azurerm_public_ip.pips[each.key].id

  }
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  for_each = var.vms
  name                = each.value.vm_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = "Standard_D2s_v3"
  admin_username      = each.value.admin_username
  admin_password = each.value.admin_password
  network_interface_ids = [azurerm_network_interface.nics[each.key].id,]
  disable_password_authentication = false
  


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

   source_image_reference {
  publisher = "Canonical"
  offer     = "ubuntu-24_04-lts"
  sku        = "server"
  version    = "latest"
}
  }