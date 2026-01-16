# ============================================================================
# Jamf Pro macOS Configuration Profile Module - Outputs
# ============================================================================
# These outputs provide useful information about the created configuration
# profile for reference and use in other modules or resources.

output "profile_id" {
  description = "The ID of the created configuration profile"
  value       = jamfpro_macos_configuration_profile_plist_generator.this.id
}

output "profile_name" {
  description = "The normalized name of the created profile"
  value       = local.profile_name_normalized
}

output "profile_description" {
  description = "The description of the profile"
  value       = var.profile_description
}

output "profile_version" {
  description = "The version number of the profile"
  value       = var.version_number
}

output "profile_level" {
  description = "The level at which the profile is applied (System/User)"
  value       = var.level
}

output "distribution_method" {
  description = "The distribution method configured for the profile"
  value       = var.distribution_method
}

output "scope_summary" {
  description = "Summary of the scope configuration"
  value = {
    all_computers    = var.scope_all_computers
    all_jss_users    = var.scope_all_jss_users
    computer_count   = length(var.scope_computer_ids)
    computer_groups  = length(var.scope_computer_group_ids)
    building_count   = length(var.scope_building_ids)
    department_count = length(var.scope_department_ids)
    user_count       = length(var.scope_jss_user_ids)
    user_groups      = length(var.scope_jss_user_group_ids)
    has_limitations  = local.has_limitations
    has_exclusions   = local.has_exclusions
  }
}

output "self_service_enabled" {
  description = "Whether self-service is enabled for this profile"
  value       = var.self_service_enabled
}

output "payload_count" {
  description = "Number of payload configurations"
  value       = length(var.payload_content_configurations)
}

output "payload_type" {
  description = "The type of payload configured"
  value       = var.payload_content_type
}

output "tags" {
  description = "Tags applied to the profile"
  value       = var.tags
}

output "deployment_targets" {
  description = "Total number of deployment targets (computers, groups, users, etc.)"
  value       = length(var.scope_computer_ids) + length(var.scope_computer_group_ids) + length(var.scope_building_ids) + length(var.scope_department_ids) + length(var.scope_jss_user_ids) + length(var.scope_jss_user_group_ids) + (var.scope_all_computers ? 999999 : 0) + (var.scope_all_jss_users ? 999999 : 0)
}

output "is_deployed" {
  description = "Whether the profile will be deployed (has scope defined)"
  value       = local.has_scope
}

output "user_removable" {
  description = "Whether users can remove the profile"
  value       = var.user_removable
}

output "category_id" {
  description = "Category ID assigned to the profile"
  value       = var.category_id
}

output "site_id" {
  description = "Site ID assigned to the profile"
  value       = var.site_id
}

output "redeploy_strategy" {
  description = "The redeployment strategy configured"
  value       = var.redeploy_on_update
}