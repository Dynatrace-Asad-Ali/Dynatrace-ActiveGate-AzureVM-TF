#######################################
## Linux VM with Web Server - Output ##
#######################################

output "ag_linux_vm_id" {
  description = "Virtual Machine id"
  value       = azurerm_linux_virtual_machine.ag-linux-vm.id
}

output "ag_linux_vm_name" {
  description = "Virtual Machine name"
  value       = azurerm_linux_virtual_machine.ag-linux-vm.name
}

output "ag_linux_vm_ip_address" {
  description = "Virtual Machine name IP Address"
  value       = azurerm_public_ip.ag-linux-vm-ip.ip_address
}

output "ag_linux_vm_admin_username" {
  description = "Username password for the Virtual Machine"
  value       = var.ag-linux-admin-username
  #sensitive   = true
}

output "ag_linux_vm_admin_password" {
  description = "Administrator password for the Virtual Machine"
  value       = random_password.ag-linux-vm-password.result
  #sensitive   = true
}

