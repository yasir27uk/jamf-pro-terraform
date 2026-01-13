output "ids" {
  value       = { for k, r in jamfpro_macos_configuration_profile_plist.this : k => r.id }
  description = "Map of profile key to created profile id."
}

output "uuids" {
  value       = { for k, r in jamfpro_macos_configuration_profile_plist.this : k => r.uuid }
  description = "Map of profile key to created profile uuid."
}

output "names" {
  value       = { for k, r in jamfpro_macos_configuration_profile_plist.this : k => r.name }
  description = "Map of profile key to profile name."
}
