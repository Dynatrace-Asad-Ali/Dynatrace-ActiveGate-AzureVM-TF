#####################################
## Linux VM with Web Server - Main ##
#####################################

# Generate random password
resource "random_password" "ag-linux-vm-password" {
  length           = 16
  min_upper        = 2
  min_lower        = 2
  min_special      = 2
  number           = true
  special          = true
  override_special = "!@#$%&"
}

# Generate randon name for virtual machine
resource "random_string" "random-linux-vm" {
  length  = 8
  special = false
  lower   = true
  upper   = false
  number  = true
}

# Create Security Group to access ag
resource "azurerm_network_security_group" "ag-linux-vm-nsg" {
  depends_on=[azurerm_resource_group.network-rg]

  name                = "${lower(replace(var.app_name," ","-"))}-${var.environment}-ag-linux-vm-nsg"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name

  security_rule {
    name                       = "allow-ssh"
    description                = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http"
    description                = "allow-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = {
    application = var.app_name
    environment = var.environment
  }
}

# Associate the ag NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "ag-linux-vm-nsg-association" {
  depends_on=[azurerm_network_security_group.ag-linux-vm-nsg]

  subnet_id                 = azurerm_subnet.network-subnet.id
  network_security_group_id = azurerm_network_security_group.ag-linux-vm-nsg.id
}

# Get a Static Public IP
resource "azurerm_public_ip" "ag-linux-vm-ip" {
  depends_on=[azurerm_resource_group.network-rg]

  name                = "linux-${random_string.random-linux-vm.result}-vm-ip"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  allocation_method   = "Static"
  
  tags = { 
    application = var.app_name
    environment = var.environment
  }
}

# Create Network Card for ag VM
resource "azurerm_network_interface" "ag-linux-vm-nic" {
  depends_on=[azurerm_public_ip.ag-linux-vm-ip]

  name                = "linux-${random_string.random-linux-vm.result}-vm-nic"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.network-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ag-linux-vm-ip.id
  }

  tags = { 
    application = var.app_name
    environment = var.environment
  }
}

# Create Linux VM with Dynatrace ActiveGate
resource "azurerm_linux_virtual_machine" "ag-linux-vm" {
  depends_on=[azurerm_network_interface.ag-linux-vm-nic]

  name                  = "linux-${random_string.random-linux-vm.result}-vm"
  location              = azurerm_resource_group.network-rg.location
  resource_group_name   = azurerm_resource_group.network-rg.name
  network_interface_ids = [azurerm_network_interface.ag-linux-vm-nic.id]
  size                  = var.ag-linux-vm-size

  source_image_reference {
    offer     = lookup(var.ag-linux-vm-image, "offer", null)
    publisher = lookup(var.ag-linux-vm-image, "publisher", null)
    sku       = lookup(var.ag-linux-vm-image, "sku", null)
    version   = lookup(var.ag-linux-vm-image, "version", null)
  }

  os_disk {
    name                 = "linux-${random_string.random-linux-vm.result}-vm-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  computer_name  = "linux-${random_string.random-linux-vm.result}-vm"
  admin_username = var.ag-linux-admin-username
  admin_password = random_password.ag-linux-vm-password.result
  custom_data    = base64encode(data.template_file.linux-vm-cloud-init.rendered)

  disable_password_authentication = false

  tags = {
    application = var.app_name
    environment = var.environment
  }
}

# Data template Bash bootstrapping file
data "template_file" "linux-vm-cloud-init" {
  template = file("azure-user-data.sh")
}
