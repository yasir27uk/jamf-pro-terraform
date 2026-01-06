terraform {
  required_providers {
    jamfpro = {
      source = "deploymenttheory/jamfpro"
    }
  }
}

locals {
  payloads_resolved = var.payloads_file != null ? file(var.payloads_file) : var.payloads
}

resource "jamfpro_macos_configuration_profile_plist" "this" {
  name              = var.name
  payloads           = local.payloads_resolved
  redeploy_on_update = var.redeploy_on_update

  description         = var.description
  level               = var.level
  distribution_method = var.distribution_method
  payload_validate    = var.payload_validate
  user_removable      = var.user_removable
  site_id             = var.site_id
  category_id         = var.category_id

  scope {
    all_computers = var.scope.all_computers
    all_jss_users = var.scope.all_jss_users

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
      condition     = length(trimspace(local.payloads_resolved)) > 0
      error_message = "Configuration profile payload is empty. Provide a Jamf-exported .mobileconfig via payloads or payloads_file (this is where Options payloads like PPPC/System Extensions/Certificates/etc are defined)."
    }

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

    precondition {
      condition     = var.level != null
      error_message = "level must be set (use 'System' for computer-level profiles)."
    }
  }
}
