# ============================================================================
# Jamf Pro macOS Configuration Profile Module - main.tf
# ============================================================================
# Purpose:
# - Generate reusable, production-grade macOS configuration profile payloads
# - Supports advanced scoping, limitations, exclusions, self service, payloads
# - Designed to be paired with jamfpro_macos_configuration_profile
# ============================================================================

# ============================================================================
# Locals
# ============================================================================

locals {
  # Profile name with optional version suffix
  profile_name_normalized = (
    var.version_number != "1.0"
    ? "${var.profile_name}-v${var.version_number}"
    : var.profile_name
  )

  # Sorted scope lists for deterministic plans
  sorted_computer_ids       = sort(var.scope_computer_ids)
  sorted_computer_group_ids = sort(var.scope_computer_group_ids)
  sorted_jss_user_ids       = sort(var.scope_jss_user_ids)
  sorted_jss_user_group_ids = sort(var.scope_jss_user_group_ids)

  # Scope checks
  has_scope = (
    var.scope_all_computers ||
    var.scope_all_jss_users ||
    length(var.scope_computer_ids) > 0 ||
    length(var.scope_computer_group_ids) > 0 ||
    length(var.scope_building_ids) > 0 ||
    length(var.scope_department_ids) > 0 ||
    length(var.scope_jss_user_ids) > 0 ||
    length(var.scope_jss_user_group_ids) > 0
  )

  has_limitations = (
    length(var.limitation_network_segment_ids) > 0 ||
    length(var.limitation_ibeacon_ids) > 0 ||
    length(var.limitation_directory_service_usernames) > 0 ||
    length(var.limitation_directory_service_usergroup_ids) > 0
  )

  has_exclusions = (
    length(var.exclusion_computer_ids) > 0 ||
    length(var.exclusion_computer_group_ids) > 0 ||
    length(var.exclusion_building_ids) > 0 ||
    length(var.exclusion_department_ids) > 0 ||
    length(var.exclusion_network_segment_ids) > 0 ||
    length(var.exclusion_jss_user_ids) > 0 ||
    length(var.exclusion_jss_user_group_ids) > 0 ||
    length(var.exclusion_directory_service_usernames) > 0 ||
    length(var.exclusion_directory_service_usergroup_ids) > 0 ||
    length(var.exclusion_ibeacon_ids) > 0
  )

  # Default Self Service install button text
  install_button_text = (
    var.version_number != "1.0"
    ? "Install - v${var.version_number}"
    : "Install"
  )
}

# ============================================================================
# macOS Configuration Profile Plist Generator
# ============================================================================

resource "jamfpro_macos_configuration_profile_plist_generator" "this" {
  name        = local.profile_name_normalized
  description = var.profile_description

  distribution_method = var.distribution_method
  redeploy_on_update  = var.redeploy_on_update
  user_removable      = var.user_removable
  level               = var.level

  # ============================================================================
  # Scope
  # ============================================================================
  dynamic "scope" {
    for_each = local.has_scope || local.has_limitations || local.has_exclusions ? [1] : []
    content {
      all_computers = var.scope_all_computers
      all_jss_users = var.scope_all_jss_users

      computer_ids       = local.sorted_computer_ids
      computer_group_ids = local.sorted_computer_group_ids
      building_ids       = var.scope_building_ids
      department_ids     = var.scope_department_ids
      jss_user_ids       = local.sorted_jss_user_ids
      jss_user_group_ids = local.sorted_jss_user_group_ids

      dynamic "limitations" {
        for_each = local.has_limitations ? [1] : []
        content {
          network_segment_ids                  = var.limitation_network_segment_ids
          ibeacon_ids                          = var.limitation_ibeacon_ids
          directory_service_or_local_usernames = var.limitation_directory_service_usernames
          directory_service_usergroup_ids      = var.limitation_directory_service_usergroup_ids
        }
      }

      dynamic "exclusions" {
        for_each = local.has_exclusions ? [1] : []
        content {
          computer_ids                         = var.exclusion_computer_ids
          computer_group_ids                   = var.exclusion_computer_group_ids
          building_ids                         = var.exclusion_building_ids
          department_ids                       = var.exclusion_department_ids
          network_segment_ids                  = var.exclusion_network_segment_ids
          jss_user_ids                         = var.exclusion_jss_user_ids
          jss_user_group_ids                   = var.exclusion_jss_user_group_ids
          directory_service_or_local_usernames = var.exclusion_directory_service_usernames
          directory_service_usergroup_ids      = var.exclusion_directory_service_usergroup_ids
          ibeacon_ids                          = var.exclusion_ibeacon_ids
        }
      }
    }
  }

  # ============================================================================
  # Self Service
  # ============================================================================
  dynamic "self_service" {
    for_each = var.self_service_enabled ? [1] : []
    content {
      install_button_text = coalesce(
        var.self_service_install_button_text,
        local.install_button_text
      )

      self_service_description        = var.self_service_description
      force_users_to_view_description = var.self_service_force_view_description
      feature_on_main_page            = var.self_service_feature_on_main_page
      notification                    = var.self_service_notification
      notification_subject            = var.self_service_notification_subject
      notification_message            = var.self_service_notification_message

      dynamic "self_service_category" {
        for_each = var.self_service_categories
        content {
          id         = self_service_category.value.id
          display_in = self_service_category.value.display_in
          feature_in = self_service_category.value.feature_in
        }
      }
    }
  }

    # ============================================================================
  # Payloads
  # ============================================================================
  payloads {
    payload_description_header  = coalesce(var.payload_root_description, var.profile_description)
    payload_enabled_header      = var.payload_root_enabled
    payload_organization_header = coalesce(var.payload_root_organization, "Organization")
    payload_type_header         = var.payload_root_type
    payload_version_header      = tonumber(replace(var.version_number, ".", ""))

    payload_content {
      payload_enabled      = var.payload_content_enabled
      payload_type         = var.payload_content_type != "" ? var.payload_content_type : "com.apple.configuration"
      payload_organization = var.payload_content_organization != "" ? var.payload_content_organization : "Organization"
      payload_version      = tonumber(replace(var.version_number, ".", ""))
      payload_description  = var.payload_content_description
      payload_display_name = var.payload_content_display_name != "" ? var.payload_content_display_name : "Configuration"
    }
  }
}

