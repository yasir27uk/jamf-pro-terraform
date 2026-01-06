output "id" {
  value       = jamfpro_macos_configuration_profile_plist.this.id
  description = "The unique identifier of the macOS configuration profile."
}

output "uuid" {
  value       = jamfpro_macos_configuration_profile_plist.this.uuid
  description = "The universally unique identifier for the profile."
}

output "name" {
  value       = jamfpro_macos_configuration_profile_plist.this.name
  description = "The Jamf UI name for the configuration profile."
}
