resource "azurerm_resource_group" "rg" {
    name     = "${var.prefix_name}-rg"
    location = "${var.resource_group_location}"
}

resource "azurerm_network_security_group" "security_group" {
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

  # TODO: Make less permissive
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
}


resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix_name}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.resource_group_location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_subnet" "subnets" {
  name                 = "${var.prefix_name}-subnet"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.0.${count.index + 100}.0/24"

  count = 10
}

resource "azurerm_subnet_network_security_group_association" "security_group_association" {
  subnet_id                 = "${azurerm_subnet.subnets.*.id[count.index]}"
  network_security_group_id = "${azurerm_network_security_group.security_group.id}"

  count = 10
}
