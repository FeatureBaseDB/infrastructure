terraform {
  required_version = ">= 0.12.0"
  required_providers {
    azurerm = ">= 1.29"
  }
}

resource "azurerm_public_ip" "agent" {
  name                         = "${var.prefix_name}-agent-ip"
  location                     = "${var.resource_group_location}"
  resource_group_name          = "${var.resource_group_name}"
  allocation_method            = "Dynamic"
  idle_timeout_in_minutes      = 30
}

data "azurerm_public_ip" "agent" {
  name = "${azurerm_public_ip.agent.name}"
  resource_group_name   = "${var.resource_group_name}"
  depends_on = ["azurerm_virtual_machine.agent"]
}

resource "azurerm_network_interface" "agent_iface" {
  name                = "${var.prefix_name}-agent-iface"
  location            = "${var.resource_group_location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "${var.prefix_name}-agent-ipconfig"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.agent.id}"
  }
}

resource "azurerm_virtual_machine" "agent" {
  name                  = "${var.prefix_name}-agent-vm"
  location              = "${var.resource_group_location}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${azurerm_network_interface.agent_iface.id}"]
  vm_size               = "${var.agent_vm_size}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.prefix_name}-agent-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    disk_size_gb      = "255"
    os_type           = "linux"
  }

  os_profile {
    computer_name  = "agent"
    admin_username = "ubuntu"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = "${file(pathexpand(var.ssh_public_key))}"
      path = "/home/ubuntu/.ssh/authorized_keys"
    }
  }
}

