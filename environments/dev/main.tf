resource "jamfpro_macos_configuration_profile_plist_generator" "this" {
  name                = "${var.profile_name_prefix}-${var.plist_version_number}"
  description         = var.profile_description
  distribution_method = var.distribution_method
  redeploy_on_update  = var.redeploy_on_update
  user_removable      = var.user_removable
  level               = var.profile_level

  scope {
    all_computers = var.scope.all_computers
    all_jss_users = var.scope.all_jss_users

    computer_ids       = var.scope.computer_ids
    computer_group_ids = sort(var.scope.computer_group_ids)
    building_ids       = var.scope.building_ids
    department_ids     = var.scope.department_ids
    jss_user_ids       = sort(var.scope.jss_user_ids)
    jss_user_group_ids = var.scope.jss_user_group_ids

    dynamic "limitations" {
      for_each = var.scope.limitations == null ? [] : [var.scope.limitations]
      content {
        network_segment_ids                  = limitations.value.network_segment_ids
        ibeacon_ids                          = limitations.value.ibeacon_ids
        directory_service_or_local_usernames = limitations.value.directory_service_or_local_usernames
        directory_service_usergroup_ids      = limitations.value.directory_service_usergroup_ids
      }
    }

    dynamic "exclusions" {
      for_each = var.scope.exclusions == null ? [] : [var.scope.exclusions]
      content {
        computer_ids                         = exclusions.value.computer_ids
        computer_group_ids                   = sort(exclusions.value.computer_group_ids)
        building_ids                         = exclusions.value.building_ids
        department_ids                       = exclusions.value.department_ids
        network_segment_ids                  = exclusions.value.network_segment_ids
        jss_user_ids                         = sort(exclusions.value.jss_user_ids)
        jss_user_group_ids                   = exclusions.value.jss_user_group_ids
        directory_service_or_local_usernames = exclusions.value.directory_service_or_local_usernames
        directory_service_usergroup_ids      = exclusions.value.directory_service_usergroup_ids
        ibeacon_ids                          = exclusions.value.ibeacon_ids
      }
    }
  }

  dynamic "self_service" {
    for_each = var.self_service_enabled ? [1] : []
    content {
      install_button_text             = "Install - ${var.version_number}"
      self_service_description        = var.self_service.description
      force_users_to_view_description = var.self_service.force_view_description
      feature_on_main_page            = var.self_service.feature_on_main_page
      notification                    = var.self_service.notification
      notification_subject            = var.self_service.notification_subject
      notification_message            = var.self_service.notification_message

      dynamic "self_service_category" {
        for_each = var.self_service.categories
        content {
          id         = self_service_category.value.id
          display_in = self_service_category.value.display_in
          feature_in = self_service_category.value.feature_in
        }
      }
    }
  }

  payloads {
    payload_root {
      payload_description_root        = var.profile_description
      payload_enabled_root            = true
      payload_organization_root       = var.organization_name
      payload_removal_disallowed_root = false
      payload_scope_root              = var.profile_level
      payload_type_root               = "Configuration"
      payload_version_root            = var.plist_version_number
    }

    payload_content {
      dynamic "configuration" {
        for_each = var.payload_configurations
        content {
          key   = configuration.value.key
          value = configuration.value.value
        }
      }

      payload_display_name = var.payload_display_name
      payload_enabled      = true
      payload_organization = var.organization_name
      payload_type         = var.payload_type
      payload_version      = var.plist_version_number
      payload_scope        = var.profile_level
    }
  }
}
