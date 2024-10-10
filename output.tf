output "vm_identity" {
  description = "The VM system-assigned identity"
  value       = module.vm_linux.identity
}

output "vm_ssh_command" {
  value = "ssh -i modules/suse/id_rsa suseadmin@${module.vm_linux.public_ip_address}"
}

output "primary_blob_endpoint" {
  value = module.storage.primary_blob_endpoint
}
