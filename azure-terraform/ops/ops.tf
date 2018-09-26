provider "azurerm" {
  subscription_id = "${var.subscription_id}"
}

variable "pubkey_file" {
  default = "~/.ssh/id_rsa.pub"
}

variable "prefix" {
  default = "pilosa"
}

variable "subscription_id" {
  default = ""
}

variable "vm_size"  {
  default = "Standard_D8s_v3"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}ops-rg"
  location = "South Central US"
}


resource "azurerm_network_security_group" "opssec" {
  name                = "${var.prefix}security-group"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_virtual_network" "vnet" {
  name                = "ops-network"
  address_space       = ["10.1.0.0/16"]
  location            = "South Central US"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "ops-subnet"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.1.3.0/24"
  network_security_group_id = "${azurerm_network_security_group.opssec.id}"
}


resource "azurerm_public_ip" "ops" {
  name                         = "opsip"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "Dynamic"
  idle_timeout_in_minutes      = 30
}

data "azurerm_public_ip" "ops" {
  name = "${azurerm_public_ip.ops.name}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  depends_on = ["azurerm_virtual_machine.ops"]
}

resource "azurerm_network_interface" "ops_iface" {
  name                = "ops-iface"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "ops-ipconfig"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.ops.id}"
  }
}

resource "azurerm_virtual_machine" "ops" {
  name                  = "ops-vm"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.ops_iface.id}"]
  vm_size               = "${var.vm_size}"

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
    name              = "ops-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    disk_size_gb      = "800"
    os_type           = "linux"
  }

  os_profile {
    computer_name  = "ops"
    admin_username = "ubuntu"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = "${file(pathexpand(var.pubkey_file))}"
      path = "/home/ubuntu/.ssh/authorized_keys"
    }
  }
}

output "ops_ip" {
  value = "${data.azurerm_public_ip.ops.ip_address}"
}
