# Terraform script to create a Debian 12 Azure Virtual Machine with Cosmos DB setup and SSH access

# Provider block specifies the Azure provider and features
provider "azurerm" {
  features {}
}

# Resource block defines the Azure virtual machine
resource "azurerm_virtual_machine" "example" {
  name                  = "example-vm"                 # Specify the name of the VM
  location              = "Canada East"                # Specify the Azure region
  resource_group_name   = "example-resources"          # Specify the resource group
  vm_size               = "Standard_DS1_v2"            # Specify the VM size
  network_interface_ids = [azurerm_network_interface.example.id]  # Attach NIC to VM

  storage_image_reference {
    publisher = "Debian"
    offer     = "debian-12"
    sku       = "12"
    version   = "latest"
  }

  storage_os_disk {
    name              = "example-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "adminuser"
    admin_password = "Password1234!" # Replace with your desired admin password
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/adminuser/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")  # Specify the path to your SSH public key
    }
  }
}

# Define network interface for the VM
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_virtual_network.example.location
  resource_group_name = azurerm_virtual_network.example.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Define virtual network for the VM
resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = "Canada East"
  resource_group_name = "example-resources"

  subnet {
    name           = "example-subnet"
    address_prefix = "10.0.1.0/24"
  }
}

# Define subnet for the VM
resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = "example-resources"
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Resource block defines the Azure Cosmos DB
resource "azurerm_cosmosdb_account" "example" {
  name                = "example-cosmosdb"
  location            = "Canada East"
  resource_group_name = "example-resources"
  offer_type          = "Standard"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = "Canada East"
    failover_priority = 0
  }
}
