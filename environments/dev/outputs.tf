output "id" {
  description = "Jamf Pro configuration profile ID."
  value       = jamfpro_macos_configuration_profile_plist_generator.this.id
}

output "name" {
  description = "Configuration profile name."
  value       = jamfpro_macos_configuration_profile_plist_generator.this.name
}

output "payload_version" {
  description = "Payload plist version."
  value       = var.plist_version_number
}
