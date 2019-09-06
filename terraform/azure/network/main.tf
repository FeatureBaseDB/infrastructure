resource "azurerm_resource_group" "rg" {
    name     = "${var.prefix_name}-rg"
    location = "${var.resource_group_location}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix_name}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.resource_group_location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_subnet" "subnets" {
  name                 = "${var.prefix_name}-subnet-${count.index}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.0.${count.index + 100}.0/24"

  count = "${var.subnet_count}"
}

resource "azurerm_subnet_network_security_group_association" "security_group_association" {
  subnet_id                 = "${azurerm_subnet.subnets.*.id[count.index]}"
  network_security_group_id = "${azurerm_network_security_group.security_group.id}"

  count = "${var.subnet_count}"
}
