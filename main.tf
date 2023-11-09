resource "azurerm_resource_group" "rg" {
   name     = "rg-test"
   location = "Uk South"
}

resource "azurerm_virtual_network" "vnet" {
    name                  = "test-vnet"
    address_space         = ["10.0.0.0/16"]
    location              = azurerm_resource_group.rg.location
    resource_group_name   = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
    count                 = 3
    name                  = "subnet-${count.index}"
    resource_group_name   = azurerm_resource_group.rg.name
    virtual_network_name  = azurerm_virtual_network.vnet.name
    address_prefixes      = ["10.0.${count.index}.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
    count                 = 3
    name                  = "vm-${count.index}_public_ip"
    resource_group_name   = azurerm_resource_group.rg.name
    location              = azurerm_resource_group.rg.location
    allocation_method     = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
    count                 = 3
    name                  = "nic-${count.index}"
    resource_group_name   = azurerm_resource_group.rg.name
    location              = azurerm_resource_group.rg.location

    ip_configuration {
        name                           = "my-ip-config"
        subnet_id                      = azurerm_subnet.subnet[count.index].id
        private_ip_address_allocation  = "Dynamic"
        public_ip_address_id           = azurerm_public_ip.public_ip[count.index].id
    }

}
resource "azurerm_linux_virtual_machine" "vm" {
    count                = 3
    name                 = "vm-${count.index}"
    resource_group_name  = azurerm_resource_group.rg.name
    location             = azurerm_resource_group.rg.location
    size                 = "Standard_B1s"
    admin_username       = "linuxadmin"

       source_image_reference {
        publisher  = "Canonical"
        offer      = "0001-com-ubuntu-server-jammy"
        sku        = "22_04-lts-gen2"
        version    = "latest"

       }
      network_interface_ids = [
        azurerm_network_interface.nic[count.index].id
      ]
     admin_ssh_key {
        username    = "linuxadmin"
        public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCs57du3yU9h9gUgjr3nOVGz60NxNLjRQ3VyCk5P40sJYbvaDurw9LfeWFDp9TLA7GjP0TyvZCC/5pC2iR69ZgRCYv11B4aKuTTjIm3L/pymjv6VEVg7UjvngLPhWrf2I9x3lOOEaWFleEeN8HXmcCZPR4RDJMoVBrTpyr/t4gyn+A4SPiF0X0hAkPjM6Hhk5ERZ0qE8L5anybS/mgvMxU8iqYkRKwELIcEuyuoXO06rberF4Kav7DZvtvdWS5Vtlto7ijqxqnTviMFQM4BRuAT3CbvpL6dU7vIj+SxaR2jQX9imdquSseqfV63l91lVX5p0tyshX+iDWLA/gHEi5af linuxadmin"
     } 
     os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
     }
}