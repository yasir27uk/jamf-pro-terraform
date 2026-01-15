terraform {
  required_providers {
    jamfpro = {
      source = "deploymenttheory/jamfpro"
    }
  }
}

locals {
  effective_payload_header = var.payloads != null ? {
    payload_description_header        = try(var.payloads.payload_root.payload_description_root, "")
    payload_enabled_header            = try(var.payloads.payload_root.payload_enabled_root, true)
    payload_organization_header       = var.payloads.payload_root.payload_organization_root
    payload_type_header               = var.payloads.payload_root.payload_type_root
    payload_version_header            = var.payloads.payload_root.payload_version_root
    payload_display_name_header       = null
    payload_removal_disallowed_header = try(var.payloads.payload_root.payload_removal_disallowed_root, false)
    payload_scope_header              = try(var.payloads.payload_root.payload_scope_root, "System")
  } : var.payload_header

  effective_payload_content = var.payloads != null ? {
    payload_description        = try(var.payloads.payload_content.payload_description, "")
    payload_display_name       = try(var.payloads.payload_content.payload_display_name, null)
    payload_enabled            = try(var.payloads.payload_content.payload_enabled, true)
    payload_organization       = var.payloads.payload_content.payload_organization
    payload_type               = var.payloads.payload_content.payload_type
    payload_version            = var.payloads.payload_content.payload_version
    payload_removal_disallowed = false
    payload_scope              = try(var.payloads.payload_content.payload_scope, "System")
    settings                   = {}
    settings_list              = []
  } : var.payload_content

  effective_setting_map = var.payloads != null ? {
    for c in try(var.payloads.payload_content.configuration, []) : c.key => c.value
  } : merge(
    try(var.payload_content.settings, {}),
    {
      for s in try(var.payload_content.settings_list, []) : s.key => s.value
    }
  )
}

resource "jamfpro_macos_configuration_profile_plist_generator" "this" {
  name                = var.name
  description         = var.description
  distribution_method = var.distribution_method
  redeploy_on_update  = var.redeploy_on_update
  user_removable      = coalesce(var.user_removable, false)
  level               = var.level
  site_id             = var.site_id
  category_id         = var.category_id

  scope {
    all_computers = coalesce(var.scope.all_computers, false)
    all_jss_users = coalesce(var.scope.all_jss_users, false)

    building_ids       = var.scope.building_ids
    computer_group_ids = var.scope.computer_group_ids
    computer_ids       = var.scope.computer_ids
    department_ids     = var.scope.department_ids
    jss_user_group_ids = var.scope.jss_user_group_ids
    jss_user_ids       = var.scope.jss_user_ids

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
        computer_group_ids                   = exclusions.value.computer_group_ids
        building_ids                         = exclusions.value.building_ids
        department_ids                       = exclusions.value.department_ids
        network_segment_ids                  = exclusions.value.network_segment_ids
        jss_user_ids                         = exclusions.value.jss_user_ids
        jss_user_group_ids                   = exclusions.value.jss_user_group_ids
        directory_service_or_local_usernames = exclusions.value.directory_service_or_local_usernames
        directory_service_usergroup_ids      = exclusions.value.directory_service_usergroup_ids
        ibeacon_ids                          = exclusions.value.ibeacon_ids
      }
    }
  }

  dynamic "self_service" {
    for_each = var.self_service == null ? [] : [var.self_service]
    content {
      install_button_text             = self_service.value.install_button_text
      self_service_description        = self_service.value.self_service_description
      force_users_to_view_description = coalesce(self_service.value.force_users_to_view_description, false)
      feature_on_main_page            = coalesce(self_service.value.feature_on_main_page, false)
      notification                    = coalesce(self_service.value.notification, false)
      notification_subject            = self_service.value.notification_subject
      notification_message            = self_service.value.notification_message

      dynamic "self_service_category" {
        for_each = self_service.value.self_service_categories
        content {
          id         = self_service_category.value.id
          display_in = coalesce(self_service_category.value.display_in, false)
          feature_in = coalesce(self_service_category.value.feature_in, false)
        }
      }
    }
  }

  payloads {
    payload_description_header  = local.effective_payload_header.payload_description_header
    payload_enabled_header      = coalesce(local.effective_payload_header.payload_enabled_header, true)
    payload_organization_header = local.effective_payload_header.payload_organization_header
    payload_type_header         = local.effective_payload_header.payload_type_header
    payload_version_header      = local.effective_payload_header.payload_version_header

    payload_display_name_header       = try(local.effective_payload_header.payload_display_name_header, null)
    payload_removal_disallowed_header = coalesce(try(local.effective_payload_header.payload_removal_disallowed_header, null), false)
    payload_scope_header              = try(local.effective_payload_header.payload_scope_header, "System")

    payload_content {
      payload_description        = local.effective_payload_content.payload_description
      payload_display_name       = local.effective_payload_content.payload_display_name
      payload_enabled            = coalesce(local.effective_payload_content.payload_enabled, true)
      payload_organization       = local.effective_payload_content.payload_organization
      payload_type               = local.effective_payload_content.payload_type
      payload_version            = local.effective_payload_content.payload_version
      payload_removal_disallowed = coalesce(try(local.effective_payload_content.payload_removal_disallowed, null), false)
      payload_scope              = try(local.effective_payload_content.payload_scope, "System")

      dynamic "setting" {
        for_each = local.effective_setting_map
        content {
          key = setting.key

          value = can(tomap(setting.value)) ? null : tostring(setting.value)

          dynamic "dictionary" {
            for_each = can(tomap(setting.value)) ? [tomap(setting.value)] : []
            content {
              key = dictionary.key

              dynamic "dictionary" {
                for_each = dictionary.value
                content {
                  key   = dictionary.key
                  value = tostring(dictionary.value)
                }
              }
            }
          }
        }
      }
    }
  }

  dynamic "timeouts" {
    for_each = (
      var.timeouts.create != null ||
      var.timeouts.read != null ||
      var.timeouts.update != null ||
      var.timeouts.delete != null
    ) ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      read   = timeouts.value.read
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }

  lifecycle {
    precondition {
      condition     = var.scope.all_computers == false || var.allow_all_computers == true
      error_message = "scope.all_computers=true requires allow_all_computers=true to reduce accidental broad deployments."
    }

    precondition {
      condition = (
        (var.distribution_method == "Make Available in Self Service" && var.self_service != null) ||
        (var.distribution_method != "Make Available in Self Service" && var.self_service == null)
      )
      error_message = "self_service must be provided only when distribution_method is 'Make Available in Self Service'."
    }
  }
}
