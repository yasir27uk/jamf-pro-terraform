terraform {
  required_providers {
    jamfpro = {
      source = "deploymenttheory/jamfpro"
    }
  }
}

locals {
  profiles_payloads_resolved = {
    for k, p in var.profiles : k => (
      p.payloads_file != null ? file(p.payloads_file) : p.payloads
    )
  }
}

resource "jamfpro_macos_configuration_profile_plist" "this" {
  for_each = var.profiles

  name               = each.value.name
  payloads           = local.profiles_payloads_resolved[each.key]
  redeploy_on_update = each.value.redeploy_on_update

  description         = each.value.description
  level               = each.value.level
  distribution_method = each.value.distribution_method
  payload_validate    = each.value.payload_validate
  user_removable      = each.value.user_removable
  site_id             = each.value.site_id
  category_id         = each.value.category_id

  scope {
    all_computers = each.value.scope.all_computers
    all_jss_users = each.value.scope.all_jss_users

    building_ids       = each.value.scope.building_ids
    computer_group_ids = each.value.scope.computer_group_ids
    computer_ids       = each.value.scope.computer_ids
    department_ids     = each.value.scope.department_ids
    jss_user_group_ids = each.value.scope.jss_user_group_ids
    jss_user_ids       = each.value.scope.jss_user_ids

    dynamic "limitations" {
      for_each = each.value.scope.limitations == null ? [] : [each.value.scope.limitations]
      content {
        network_segment_ids                  = limitations.value.network_segment_ids
        ibeacon_ids                          = limitations.value.ibeacon_ids
        directory_service_or_local_usernames = limitations.value.directory_service_or_local_usernames
        directory_service_usergroup_ids      = limitations.value.directory_service_usergroup_ids
      }
    }

    dynamic "exclusions" {
      for_each = each.value.scope.exclusions == null ? [] : [each.value.scope.exclusions]
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
    for_each = each.value.self_service == null ? [] : [each.value.self_service]
    content {
      install_button_text             = self_service.value.install_button_text
      self_service_description        = self_service.value.self_service_description
      force_users_to_view_description = self_service.value.force_users_to_view_description
      feature_on_main_page            = self_service.value.feature_on_main_page
      notification                    = self_service.value.notification
      notification_subject            = self_service.value.notification_subject
      notification_message            = self_service.value.notification_message

      dynamic "self_service_category" {
        for_each = self_service.value.self_service_categories
        content {
          id         = self_service_category.value.id
          display_in = self_service_category.value.display_in
          feature_in = self_service_category.value.feature_in
        }
      }
    }
  }

  dynamic "timeouts" {
    for_each = (
      each.value.timeouts.create != null ||
      each.value.timeouts.read != null ||
      each.value.timeouts.update != null ||
      each.value.timeouts.delete != null
    ) ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      read   = timeouts.value.read
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }

  lifecycle {
    precondition {
      condition     = length(trimspace(local.profiles_payloads_resolved[each.key])) > 0
      error_message = "Configuration profile payload is empty for key '${each.key}'. Provide payloads or payloads_file."
    }

    precondition {
      condition     = each.value.scope.all_computers == false || each.value.allow_all_computers == true
      error_message = "scope.all_computers=true for key '${each.key}' requires allow_all_computers=true to reduce accidental broad deployments."
    }

    precondition {
      condition = (
        (each.value.distribution_method == "Make Available in Self Service" && each.value.self_service != null) ||
        (each.value.distribution_method != "Make Available in Self Service" && each.value.self_service == null)
      )
      error_message = "self_service must be provided only when distribution_method is 'Make Available in Self Service' (profile key '${each.key}')."
    }
  }
}
