provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  tenant_id = "${var.tenant_id}"
}

variable "subscription_id" {
  default = ""
}

variable "client_id" {
  default = ""
}

variable "client_secret" {
  default = ""
}

variable "tenant_id" {
  default = ""
}

variable "prefix_name" {
  default = "test"
}

variable "resource_group_location" {
  default = "South Central US"
}

variable "failover_location" {
  default = "East US"
}

variable "pubkey_file" {
  default = "~/.ssh/id_rsa.pub"
}

variable "ops_ip" {
  type = "string"
  description = "IP address of control host which is used to manage infrastructure and as a bastion."
  default = "127.0.0.1"
}

resource "azurerm_resource_group" "rg" {
    name     = "${var.prefix_name}-rg"
    location = "${var.resource_group_location}"
}

resource "azurerm_network_security_group" "sec_group" {
  name                = "${var.prefix_name}-security-group"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "SSH"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name = "AllInternalIn"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "10.0.0.0/16"
  }

  security_rule {
    name = "AllInternalOut"
    priority = 101
    direction = "Outbound"
    access = "Allow"
    protocol = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "10.0.0.0/16"
  }

  security_rule {
    name                       = "OpsAccess"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "${var.ops_ip}"
    destination_address_prefix = "*"
  }
}


resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix_name}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.resource_group_location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix_name}-subnet"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.0.2.0/24"
  network_security_group_id = "${azurerm_network_security_group.sec_group.id}"
}

// Pilosa machines
variable "pilosa_count" {
  description = "Number of Pilosa nodes."
  type = "string"
  default = "3"
}

variable "pilosa_vm_size" {
  description = "Azure VM size to use for Pilosa nodes."
  type = "string"
  default = "Standard_D4s_v3" # 4vcpu 16GB
}

output "pilosa_ips" {
  value = "${data.azurerm_public_ip.pilosa.*.ip_address}"
}

resource "azurerm_public_ip" "pilosa" {
  name                         = "${var.prefix_name}-pilosa-ip${count.index}"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "Dynamic"
  idle_timeout_in_minutes      = 30
  count = "${var.pilosa_count}"
}

data "azurerm_public_ip" "pilosa" {
  name = "${azurerm_public_ip.pilosa.*.name[count.index]}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  count = "${var.pilosa_count}"
  depends_on = ["azurerm_virtual_machine.pilosa"]
}

resource "azurerm_network_interface" "pilosa_iface" {
  name                = "${var.prefix_name}-pilosa-iface${count.index}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  count = "${var.pilosa_count}"

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
  count = "${var.pilosa_count}"

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
}
// END PILOSA MACHINES


// Kafka machines
variable "kafka_count" {
  description = "Number of Kafka nodes."
  type = "string"
  default = "0"
}

variable "kafka_vm_size" {
  description = "Azure VM size to use for Kafka nodes."
  type = "string"
  default = "Standard_D4s_v3" # 4vcpu 16GB
}

output "kafka_ips" {
  value = "${data.azurerm_public_ip.kafka.*.ip_address}"
}

resource "azurerm_public_ip" "kafka" {
  name                         = "${var.prefix_name}-kafka-ip${count.index}"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "Dynamic"
  idle_timeout_in_minutes      = 30
  count = "${var.kafka_count}"
}

data "azurerm_public_ip" "kafka" {
  name = "${azurerm_public_ip.kafka.*.name[count.index]}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  count = "${var.kafka_count}"
  depends_on = ["azurerm_virtual_machine.kafka"]
}

resource "azurerm_network_interface" "kafka_iface" {
  name                = "${var.prefix_name}-kafka-iface${count.index}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  count = "${var.kafka_count}"

  ip_configuration {
    name                          = "${var.prefix_name}-kafka-ipconfig${count.index}"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.kafka.*.id[count.index]}"
  }
}

resource "azurerm_virtual_machine" "kafka" {
  name                  = "${var.prefix_name}-kafka-vm${count.index}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.kafka_iface.*.id[count.index]}"]
  vm_size               = "${var.kafka_vm_size}"
  count = "${var.kafka_count}"

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
    name              = "${var.prefix_name}-kafka-disk${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    disk_size_gb      = "255"
    os_type           = "linux"
  }

  os_profile {
    computer_name  = "kafka${count.index}"
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
// END KAFKA MACHINES
