resource "azurerm_public_ip" "pilosa" {
  name                         = "${var.prefix_name}-pilosa-ip${count.index}"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "Dynamic"
  idle_timeout_in_minutes      = 30
  count = "${var.pilosa_cluster_size}"
}

data "azurerm_public_ip" "pilosa" {
  name = "${azurerm_public_ip.pilosa.*.name[count.index]}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  count = "${var.pilosa_cluster_size}"
  depends_on = ["azurerm_virtual_machine.pilosa"]
}

resource "azurerm_network_interface" "pilosa_iface" {
  name                = "${var.prefix_name}-pilosa-iface${count.index}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  count = "${var.pilosa_cluster_size}"

  ip_configuration {
    name                          = "${var.prefix_name}-pilosa-ipconfig${count.index}"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.pilosa.*.id[count.index]}"
  }
}

resource "azurerm_virtual_machine" "pilosa" {
  name                  = "${var.prefix_name}-pilosa-vm${count.index}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.pilosa_iface.*.id[count.index]}"]
  vm_size               = "${var.pilosa_vm_size}"
  count = "${var.pilosa_cluster_size}"

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
    name              = "${var.prefix_name}-pilosa-disk${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    disk_size_gb      = "255"
    os_type           = "linux"
  }

  os_profile {
    computer_name  = "pilosa${count.index}"
    admin_username = "ubuntu"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = "${file(pathexpand(var.pubkey_file))}"
      path = "/home/ubuntu/.ssh/authorized_keys"
    }
  }

  tags {
    index = "${count.index}"
  }
}
